function [CF,warnings,tolerances,proportions,error,selectedTolerance,criticalLevel,criticalIndex] = colimg(C,Settings)

%COLget_fu Process and analyse colony images
%
%   COLIMG is a function that produces a binary version of the input image
%   C. COLIMG returns a binary image CF, along with any warnings. The
%   tolerances checked are provided, along with the corresponding
%   proportions and error. Also provided are the selected tolerance,
%   critical level and critical index.
%
%   Created by Hayden Tronnolone
%   Date created: 11/04/2017

%%%%%%%%%%%%%%
%%% Set up %%%
%%%%%%%%%%%%%%

% Settings
Method = Settings.Method;
RemoveBorders =Settings.RemoveBorders;
LevelMethod = Settings.LevelMethod;
ManualCheck = Settings.ManualCheck;
BorderMethod = Settings.BorderMethod;
InvertColour = Settings.InvertColour;
ChiMax = Settings.ChiMax;

%%%%%%%%%%%%%%%%%%%%%
%%% Process image %%%
%%%%%%%%%%%%%%%%%%%%%

% Load image and ensure correct format
if size(C,3)~=1

    try
        C = rgb2gray(C);
    catch
        C = C(:,:,1);
    end
    
end

% Get image size
[y,x] = size(C);
r = min([x y]);

% Correct colour
if InvertColour

    C = imcomplement(C);
    
end

% Check centre square for darkest colour
xc = round(x/2); yc = round(y/2);
wx = round(x/20); wy = round(y/20);
C_masked = nan(size(C));
C_masked(yc-wy:yc+wy,xc-wx:xc+wx) = C(yc-wy:yc+wy,xc-wx:xc+wx);
[mnc,mni] = min(C_masked(:));
[yv,xv] = ind2sub(size(C),mni);

% Initialise
tmn = 0;
tmx = max([mnc,255-mnc]);
nLevels = tmx - tmn + 1;
pcrit = 1;
proportions = nan(1,nLevels);
tolerances = tmn:tmx;
warnings = {};
CFMat = zeros([size(C),nLevels]);

% Set filter function
if strcmpi(Method,'Connected')
    
    imfilt = @(C,tol) grayconnected(C,yv,xv,tol);
    
else
    
    imfilt = @(C,tol) grayunconnected(C,yv,xv,tol);
    
end

% Remove borders
CT = double(C);
if strcmp(RemoveBorders,'Rectangle')
    
    CT(y-round(y/20):y,:) = NaN;
    CT(1:round(y/20),:) = NaN;
    CT(:,x-round(x/20):x) = NaN;
    CT(:,1:round(x/20)) = NaN;
    
elseif strcmp(RemoveBorders,'Disk')
    
    radius = 0.8*min([x y])/2;
    dx=1:x; dy=1:y;
    [DX,DY] = meshgrid(dx,dy);
    CT(sqrt((DX-xc).^2 + (DY-yc).^2)>radius) = NaN;
    
end

% Count pixels
nPixels = sum(~isnan(CT(:)));

% Check each level
for j=1:nLevels
    
    % Filter image and compute proportion occupied
    CF = imfilt(CT,round(tolerances(j)));
    CFMat(:,:,j) = CF;
    proportions(j) = sum(CF(:)/nPixels);
    
    % Stop checking if all pixels are selected
    if proportions(j)==1
        proportions(j:end) = 1;
        CFMat(:,:,j:end) = 1;
        break
    end
    
end

% Identify critical region allowing for approximate value
criticalIndex = max([find(proportions>(pcrit-1e-5),1),find(proportions==pcrit,1)]);

% Set to last index if no value found
if isempty(criticalIndex)
    criticalIndex = length(proportions);
    warnings{end+1} = {Critical index not found'};
end

criticalLevel = tolerances(criticalIndex);

% Identify filter point
switch LevelMethod
    
    case 1 % Jump in derivatives
        
        % Identify start of jump region with derivative
        dproportions = ddx(proportions,1);
        tol = 0.1*max(dproportions);
        [~,selectedIndex] = find(dproportions>tol,1);
        
    case 2 % Best linear fit
        
        % Initialise error
        error = zeros(length(2:criticalIndex-1));
        
        % Loop over join points
        for j=2:criticalIndex-1
            
            % Compute coefficients
            A_start = [ones(j,1) tolerances(1:j).'];
            b_start = proportions(1:j).';
            jj = criticalIndex-j;
            A_end = [ones(jj,1) tolerances(j+1:criticalIndex).'];
            b_end = proportions(j+1:criticalIndex).';
            ab_start = A_start\b_start;
            ab_end = A_end\b_end;
            
            % Compute fits
            y_start = ab_start(1) + tolerances(1:j)*ab_start(2);
            y_end = ab_end(1) + tolerances(j+1:criticalIndex)*ab_end(2);
            
            % Compute mean error
            error(j) = mean([abs(y_start - proportions(j:j)) abs(y_end - proportions(j+1:criticalIndex))]);
            
        end
        
        %[me,mi] = min(error(2:criticalIndex-1));
        [mes,mis] = findpeaks(-error(2:criticalIndex-1));
        %mi = min(mis);
        if ~isempty(mis)
            mi = mis(end);
        else
            mi = 1;
            warnings{end+1} = {'Threshold index not found'};
        end
        
        me = -mes(mis==mi);
        selectedIndex = mi + 1;
        
    case 3 % Pinned linear fit
        
        % Initialise error
        error = zeros(length(2:criticalIndex-1));
        
        % Loop over join points
        for j=2:criticalIndex-1
            
            % Compute coefficients
            ab_start = [proportions(1) (proportions(j)-proportions(1))/(tolerances(j) - tolerances(1))];
            ab_end = [proportions(j+1) (proportions(criticalIndex)-proportions(j+1))/(tolerances(criticalIndex) - tolerances(j+1))];
            
            % Compute fits
            y_start = ab_start(1) + (tolerances(1:j) - tolerances(1))*ab_start(2);
            y_end = ab_end(1) + (tolerances(j+1:criticalIndex) - tolerances(j+1))*ab_end(2);
            
            % Compute mean error
            error(j) = mean([abs(y_start - proportions(1:j)) abs(y_end - proportions(j+1:criticalIndex))]);
            
        end
        
%         % Remove values above threshold limit
%         low = proportions(mis+1)<=(pi*r^2/(x*y));
%         mes = mes(low);
%         mis = mis(low);

         % Select smallest minimum
         [~,mi] = min(error(2:criticalIndex-1));
        
        % Set level and error
        selectedIndex = mi + 1;
        
    case 4 % Changepoints method
        
        % Find changepoints
        q = findchangepts(proportions,'Statistic','linear','MaxNumChanges',4);
        selectedIndex = q(1);
        
    case 5 % Single linear fit to second line
        
        % Initialise error
        error = zeros(length(2:criticalIndex-1));
        
        for j=2:criticalIndex-1
            
            % Compute coefficients
            ab_end = [proportions(j+1) (proportions(criticalIndex)-proportions(j+1))/(tolerances(criticalIndex) - tolerances(j+1))];
            
            % Compute fits
            y_end = ab_end(1) + (tolerances(j+1:criticalIndex) - tolerances(j+1))*ab_end(2);
            
            % Compute mean error
            error(j) = mean(abs(y_end - proportions(j+1:criticalIndex)));
            
        end
        
        % Smallest error
        [~,mi] = min(error(2:criticalIndex-1));
        
        % Set level and error
        selectedIndex = mi + 1;
        %me = -mes(mis==mi);
        
end

% Ensure some index is found
if isempty(selectedIndex)
    selectedIndex = 1;
end

% Set selected tolerance
selectedTolerance = tolerances(selectedIndex);

% Maximum proportion
iChiMax = find(proportions>=ChiMax,1,'first');
if selectedIndex>iChiMax
    selectedIndex = iChiMax;
    selectedTolerance = tolerances(selectedIndex);
    warnings{end+1,1} = {['Reduced to maximum threshold ' num2str(ChiMax)]};
end

% Adjust images manually
if ManualCheck

    close all
    
    % Initialsie user flag
    global flagUser
    flagUser = 0;
    
    % Plot comparison
    subplot(1,2,1)
    %imshow(C)
    hold on
    green = cat(3,zeros(size(C)),ones(size(C)),zeros(size(C)));
    %h = imshow(green);
    set(gca,'YDir','Normal')
    set(h,'AlphaData',CFMat(:,:,selectedIndex)*0.3)
    
    % Plot proportions
    subplot(1,2,2)
    mx = 1.1;
    plot(tolerances,proportions,selectedTolerance*ones(1,100),linspace(0,mx),'k--',selectedTolerance,proportions(selectedIndex),'ro')
    xlabel('$\tau$')
    ylabel('$\chi$')
    ylim([0 mx])
    axis tight
    hf = gcf;
    hh = get(hf,'Children');
    set(gca,'FontSize',12)
    set(findall(hf,'Type','Text'),'FontSize',12,'FontWeight','Normal','Interpreter','LaTeX')
    set(findall(hh,'Type','Axes'),'FontSize',12,'FontWeight','Normal','TickLabelInterpreter','LaTeX')
    set(findall(hf,'Type','line'),'Linewidth',1.5)
    
    % Create function for plot callback
    complotw = @(source,event) complot(source,event,CFMat,h,tolerances,proportions);
    
    % Create slider
    uicontrol('Style', 'slider',...
        'Min',tmn,'Max',tmx,'Value',selectedTolerance,...
        'Position', [300 20 120 20],...
        'Callback',complotw);
    
    % Create accept button
    uicontrol('Style', 'pushbutton', 'String', 'Accept image',...
        'Position', [430 20 90 20],...
        'Callback','close');
    
    % Create warning button
    uicontrol('Style', 'pushbutton', 'String', 'Accept and warn',...
        'Position', [530 20 90 20],...
        'Callback',@complotbutton);
    
    % Format figure window
    set(gcf,'Position',[100 100 1000 1000])
        
    % Wait until image is approved
    waitfor(gcf)
    
    % Record if flagged by user
    if flagUser
        warnings{end+1,1} = {'Image flagged by user'};
    end
    
    % Set selected index
    selectedIndex = find(tolerances==selectedTolerance);
    
end

% Compute filtered binary image
CF = imfilt(CT,selectedTolerance);

% Remove border pixels
if BorderMethod
    
    % Check for border pixels
    borderFlag = any([CF(1,:) CF(end,:) CF(:,1).' CF(:,end).']);
    t = ones(size(CF));
    t(2:end-1,2:end-1) = NaN;
    
    % Record warning if border pixels found
    if borderFlag
        warnings{end+1,1} = {'Border pixels identified'};
    end
    
    while borderFlag
        
        switch BorderMethod
            
            case 'Remove'
                % Find border pixels
                cbi = find((CF.*t)==1);
                [by,bx] = ind2sub(size(CF),cbi(1));
                
                % Remove connected region
                br = grayconnected(int8(CF),by,bx,0);
                CF(br) = 0;
                
            case 'Reduce'
                % Reduce level if border pixels selected
                if selectedIndex==1
                    break
                elseif borderFlag
                    selectedIndex = selectedIndex - 1;
                    selectedTolerance = tolerances(selectedIndex);
                    CF = imfilt(CT,selectedTolerance);
                end
                
        end
        
        % Recheck border pixels
        borderFlag = any([CF(1,:) CF(end,:) CF(:,1).' CF(:,end).']);
        
    end
    
end

% Count neighbours
[ny,nx] = size(CF);
Neighbours = [zeros(1,nx); CF(1:(ny-1),1:nx)] + [CF(2:ny,1:nx); zeros(1,nx)] + [zeros(ny,1) CF(1:ny,1:(nx-1))] + [CF(1:ny,2:nx) zeros(ny,1)];
CFF = CF&(Neighbours>3);
   
% Remove any isolated pixels
if ~isequal(CF,CFF)

    warnings{end+1,1} = {['Removing ' num2str(sum(CF(:))-sum(CFF(:))) ' of ' num2str(numel(CF)) ' isolated pixels (' num2str((sum(CF(:))-sum(CFF(:)))/numel(CF)*100) '%)']};
    CF = CFF;

end

% Remove unconnected pixels
if strcmpi(Method,'Connected')
    
    % Only keep largest piece
    CC = bwconncomp(CF);
    L = labelmatrix(CC);
    nC = cellfun(@numel,CC.PixelIdxList);
    [~,j] = max(nC);
    CF = ismember(L,j);
    
end

%%%%%%%%%%%%%%%%%%%%
%%% Image checks %%%
%%%%%%%%%%%%%%%%%%%%

% Boundary pixels
borders = [CF(1,:) CF(end,:) CF(:,1).' CF(:,end).'];
if any(borders)
    warnings{end+1,1} = {'Border pixels selected'};
end

% Low index
if selectedTolerance<20
    warnings{end+1,1} = {['Image threshold below ' num2str(20)]};
end

function complot(source,event,CFMat,h,tolerances,proportions)

% Set tolerance and index
selectedTolerance = round(source.Value);
selectedIndex = find(tolerances==selectedTolerance);

% Adjust comparison plot
subplot(1,2,1)
set(h,'AlphaData',CFMat(:,:,selectedIndex)*0.3)

% Adjust intensity plot
subplot(1,2,2)
mx = 1.1;
plot(tolerances,proportions,selectedTolerance*ones(1,100),linspace(0,mx),'k--',selectedTolerance,proportions(selectedIndex),'ro')
axis tight
hf = gcf;
hh = get(hf,'Children');
set(gca,'FontSize',12)
set(findall(hf,'Type','Text'),'FontSize',12,'FontWeight','Normal','Interpreter','LaTeX')
set(findall(hh,'Type','Axes'),'FontSize',12,'FontWeight','Normal','TickLabelInterpreter','LaTeX')
set(findall(hf,'Type','line'),'Linewidth',1.5)

end

function complotbutton(source,event)
    close
    flagUser = 1;
end

end

% Filter function for unconnected regions
function C_filtered=grayunconnected(C,yv,xv,tol)

% Selected colour value
B = C(yv,xv);

% Filter
C_filtered = abs((C-B)<=tol);

end