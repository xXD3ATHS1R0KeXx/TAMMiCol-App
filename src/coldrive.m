function [output] = coldrive(Config,Img,ImgNo)

%COLDRIVE Driver script for image processing and statistics
%
%   COLDRIVE is the main script called by TAMMiCol. This script unpacks the
%   input, finds image files, and calls the image processing and statistics
%   functions.
%
%   All data is saved by COLDRIVE.
%
%   Created by Hayden Tronnolone
%   Date created: 10/05/2017

% Extract variables
ComputeImage = 1;
ComputeStatistics = 0;

SaveBinary = Config.exportFiles.SaveBinary;
SaveBinaryCSV = Config.exportFiles.SaveBinaryCSV;
SaveBinaryMAT = Config.exportFiles.SaveBinaryMAT;
SaveComparison = Config.exportFiles.SaveComparison;
SaveStatsCSV = Config.exportFiles.SaveStatsCSV;
SaveStatsMAT = Config.exportFiles.SaveStatsMAT;

SaveIntensity = Config.exportOpt.SaveIntensity;
SaveError = Config.exportOpt.SaveError;
SaveFourier = Config.exportOpt.SaveFourier;
SaveWave = Config.exportOpt.SaveWave;
SaveFR = Config.exportOpt.SaveFR;
SaveFA = Config.exportOpt.SaveFA;
SaveFP = Config.exportOpt.SaveFP;
ImageExtensionOut = char(Config.exportOpt.ImageExtensionOut);

ImgZoom = Img.zoom;
ImgTime = Img.time;
ImgTimeHrs = Img.timeHrs;
ImgTimeDays = Img.timeDays;
PathIn = Img.filePath;
File = Img.fileName;

ImageSeparator = '-';
ImageSuffix = 'binary';
%DirectorySeparator = '';
ShowProgress = 0;

% Ensure path out is set
% if ~isfield(Controls,'PathOut')||isempty(Controls.PathOut)
    %PathOut = PathIn;
% else
%     PathOut = Controls.PathOut;
% end

% Ensure directory suffix is set
% if ~isfield(Controls,'DirectorySuffix')
    %DirectorySuffix = 'Binary';
% else
%     DirectorySuffix = Controls.DirectorySuffix;
% end

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Image processing %%%
%%%%%%%%%%%%%%%%%%%%%%%%

if ComputeImage
    
    % Initialise warnings
    warnings = {};
    
    % Find all files in subdirectories
    files = dir(fullfile(PathIn,File));
    nFiles = 1;
    
    % Stop if no files found
    if nFiles==0
        return
    end
    
    % Progress
    if ShowProgress
        hw = waitbar(0,sprintf('Image analysis: %.2f %%',0));
    end
    
    % Loop over images
    for n=1:nFiles
        
        % Get metadata and create formatted filename
        [sample,time,magnification,extn] = colmeta(Img,ImgNo);
        name = Config.general.SetName;
        ImageExtensionIn = extn;
        names{1} = name;
        filename = strcat(name, '-s', num2str(sample), '-', num2str(time), 'h-', num2str(magnification), 'X');
        DirectoryOut = 'Output';
        %HolderOut = [name DirectorySeparator DirectorySuffix];
        %Holders{n} = HolderOut;

        % Create output folders
        if any([SaveBinary,SaveIntensity,SaveComparison,SaveError])
            
            warning('off','MATLAB:MKDIR:DirectoryExists')
            
            % Output folder
            mkdir(PathIn,DirectoryOut);
            
            warning('on','MATLAB:MKDIR:DirectoryExists')
            
        end
        
        % Set output location
        LocationOut = fullfile(PathIn,DirectoryOut);
        % Return the output path, so that we can keep track of it
        output = LocationOut;
        
        % Load image
        % C = flip(imread(fullfile(PathIn)));%fullfile(files(n).folder,files(n).name)));
        %addpath(PathIn)
        str1 = append(PathIn,File);
        A = imread(fullfile(str1));
        fullfile(files(n).folder,files(n).name)
        C = flip(A);
        % Check for alpha channel
        if size(C,3)>3
            C = C(:,:,1:3);
        end
        
        % Process
        [CF,warningsTemp,tolerances,proportions,error,selectedTolerance,criticalLevel,criticalIndex] = colimg(C,Config);
        
        for j=1:length(warningsTemp)
            
            warnings = [warnings;{name sample time warningsTemp{j}}];
        
        end
                        
        % Plot intensity with error
        % Plot NOT SUPPORTED by Web App
%         if SaveError
%             
%             mx = 1.1;
%             figure('Visible','Off')
%      % **   plot(tolerances,proportions,selectedTolerance*ones(1,100),linspace(0,mx),'k--',criticalLevel*ones(1,100),linspace(0,mx),'k--',tolerances(2:criticalIndex-1),error(2:criticalIndex-1))
%             axis tight
%             ylim([0 mx])
%             xlabel('$\tau$')
%             ylabel('$\chi, \delta$')
%             hf = gcf;
%             hh = get(hf,'Children');
%             set(gca,'FontSize',12)
%             set(findall(hf,'Type','Text'),'FontSize',12,'FontWeight','Normal','Interpreter','LaTeX')
%             set(findall(hh,'Type','Axes'),'FontSize',12,'FontWeight','Normal','TickLabelInterpreter','LaTeX')
%             set(findall(hf,'Type','line'),'Linewidth',1.5)
%             OutName = strcat(filename, ImageSeparator, 'error');
%             saveplot(fullfile(LocationOut,OutName),[],'Simple');
%             close gcf
%             
%         end
        
        % Save binary image
        if SaveBinary

            FileOut = flip(1-CF);
            OutName = strcat(filename, '-', ImageSuffix, '.', ImageExtensionOut);
            imwrite(FileOut, fullfile(LocationOut,OutName));
            %Controls.file = imwrite(flip(1-CF),fullfile(LocationOut,[filename ImageSeparator ImageSuffix '.' ImageExtensionOut]));
            
        end
        
        % Save comparisons
        % Figure NOT SUPPORTED by Web App
%         if SaveComparison
%             
%         %    figure('Visible','Off');
%             imshow(C)
%             hold on
%             green = cat(3,zeros(size(CF)),ones(size(CF)),zeros(size(CF)));
%             h = imshow(green);
%             set(h,'AlphaData',CF*0.3)
%             set(gca,'YDir','Normal')
%             OutName = strcat(filename, ImageSeparator, 'compare');
%             saveplot(fullfile(LocationOut,OutName),[],'SimpleOGL',1)
%             close gcf
% 
%         end
        
        % Save intensity
         % Plot NOT SUPPORTED by Web App
%         if SaveIntensity
%             
%             mx = 1.1;
%        %**  figure('Visible','Off');
%             plot(tolerances,proportions,selectedTolerance*ones(1,100),linspace(0,mx),'k--',criticalLevel*ones(1,100),linspace(0,mx),'k--')
%             xlabel('$\tau$')
%             ylabel('$\chi$')
%             axis tight
%             ylim([0 mx])
%             hf = gcf;
%             hh = get(hf,'Children');
%             set(gca,'FontSize',12)
%             set(findall(hf,'Type','Text'),'FontSize',12,'FontWeight','Normal','Interpreter','LaTeX')
%             set(findall(hh,'Type','Axes'),'FontSize',12,'FontWeight','Normal','TickLabelInterpreter','LaTeX')
%             set(findall(hf,'Type','line'),'Linewidth',1.5)
%             OutName = strcat(filename, ImageSeparator, 'intensity');
%             saveplot(fullfile(LocationOut,OutName),[],'Simple')
%             close gcf
%             
%         end
        
        % Save data as MAT file
        if SaveBinaryMAT
            OutName = strcat(filename, ImageSeparator, 'binary');
            save(fullfile(LocationOut,OutName),'CF');
        end
        
        % Save data as CSV
        if SaveBinaryCSV
            OutName = strcat(filename, ImageSeparator, 'binary.csv');
            csvwrite(fullfile(LocationOut,OutName),CF);
        end
        
        % Progress
        % Not yet implemented
%         if ShowProgress
%             
%             % Check to update or replace waitbar
%             if exist('hw','Var')&&ishandle(hw)
%                 waitbar(n/nFiles,hw,sprintf('Image analysis: %.2f %%',100*n/nFiles));
%             else
%                 hw = waitbar(n/nFiles,sprintf('Image analysis: %.2f %%',100*n/nFiles));
%             end
%             
%         end
        
    end
    
    % Close progress bar
    if ShowProgress
        close(hw)
    end

    % Save warnings
    if ~isempty(warnings)

        warningsTable = cell2table(warnings);
        warningsTable.Properties.VariableNames = {'Dataset','Sample','Time','Warning'};
        OutName = strcat(filename, ImageSeparator, 'Warnings');
        writetable(warningsTable,fullfile(LocationOut,OutName))
        

    end

end

%%%%%%%%%%%%%%%%%%
%%% Statistics %%%
%%%%%%%%%%%%%%%%%%

if ComputeStatistics
    
    % Find all files in subdirectories
    if ComputeImage
                
        % Find unique holders
        Holders = unique(Holders);
        
        % Loop over all holders
        files = [];
        for j=1:numel(Holders)
            files = [files,dir(fullfile(PathIn,File))];
        end
        
    else
        files = dir(fullfile(PathIn,File));
    end
    
    nFiles = numel(files);
    
    % Stop if no files found
    if nFiles==0
        return
    end
    
    % Initialise statistics table
    dataTable = table(cell(nFiles,1),zeros(nFiles,1),zeros(nFiles,1),zeros(nFiles,1),...
        zeros(nFiles,1),zeros(nFiles,1),zeros(nFiles,1),zeros(nFiles,1),...
        zeros(nFiles,1),zeros(nFiles,1),zeros(nFiles,1));
    dataTable.Properties.VariableNames = {'Dataset','Sample','Time','Magnification','Ir','Itheta','ITheta','Icsr','Rmin','Rmax','Area'};
    
    % Pair correlation Fourier transform
    fourierTable = array2table(zeros(nFiles,2+Options.nBins(3)));
    fourierTable.Properties.VariableNames = ['Sample'; 'Time'; strcat('F',split(num2str(1:Options.nBins(3))))];
    
    % Wavenumbers
    waveTable = array2table(zeros(nFiles,2+Options.nBins(3)/2+1));
    waveTable.Properties.VariableNames = ['Sample'; 'Time'; strcat('Wavenumber ',split(num2str(0:Options.nBins(3)/2)))];
    
    % Radial metric
    frTable = array2table(zeros(nFiles,2+Options.nBins(1)));
    frTable.Properties.VariableNames = ['Sample'; 'Time'; strcat('Bin ',split(num2str(1:Options.nBins(1))))];
    
    % Angular metric
    fthetaTable = array2table(zeros(nFiles,2+Options.nBins(2)));
    fthetaTable.Properties.VariableNames = ['Sample'; 'Time'; strcat('Bin ',split(num2str(1:Options.nBins(2))))];
    
    % Pair metric
    fThetaTable = array2table(zeros(nFiles,2+Options.nBins(3)));
    fThetaTable.Properties.VariableNames = ['Sample'; 'Time'; strcat('Bin ',split(num2str(1:Options.nBins(3))))];
    
    % Progress
    if ShowProgress
        hw = waitbar(0,sprintf('Computing statistics: %.2f %%',0));
    end
    
    % Loop over files
    for n=1:nFiles
        
        % Get metadata
        [~,filename,~] = fileparts(files(n).name);
        [name,sample,time,magnification] = colmeta(filename,ImageSuffix);
        names{n} = name;
        
        % Load binary image
        CF = flip(1 - imread(fullfile(files(n).folder,files(n).name)));
        
        % Compute statistics
        [Ir,~,Itheta,ITheta,Icsr,~,~,k,Rmin,Rmax,Area,ffTheta,fr,ftheta,fTheta] = statcalc(CF,Options);
                
        % Add statistics to table
        dataTable(n,1:11) = {name,sample,time,magnification,...
            Ir,Itheta,ITheta,Icsr,Rmin,Rmax,Area};
        
        % Add Fourier transform
        fourierTable(n,1:2) = {sample time};
        fourierTable(n,3:end) = num2cell(ffTheta);
        
        % Add wavenumbers
        waveTable(n,1:2) = {sample time};
        waveTable(n,3:end) = num2cell(k);
        
        % Add radial metric
        frTable(n,1:2) = {sample time};
        frTable(n,3:end) = num2cell(fr);
        
        % Add angular metric
        fthetaTable(n,1:2) = {sample time};
        fthetaTable(n,3:end) = num2cell(ftheta);
        
        % Add pair metric
        fThetaTable(n,1:2) = {sample time};
        fThetaTable(n,3:end) = num2cell(fTheta);
        
        % Progress
        if ShowProgress
            
            % Check to update or replace waitbar
            if exist('hw','Var')&&ishandle(hw)
                waitbar(n/nFiles,hw,sprintf('Computing statistics: %.2f %%',100*n/nFiles));
            else
                hw = waitbar(n/nFiles,sprintf('Computing statistics: %.2f %%',100*n/nFiles));
            end
            
        end
        
                
    end
    
    % Close progress bar
    if ShowProgress
        close(hw)
    end
        
    % Sort table by times for output
    dataTable = sortrows(dataTable,[3 2]);
    fourierTable = sortrows(fourierTable,[2 1]);
    waveTable = sortrows(waveTable,[2 1]);
    frTable = sortrows(frTable,[2 1]);
    fthetaTable = sortrows(fthetaTable,[2 1]);
    fThetaTable = sortrows(fThetaTable,[2 1]);

    % Set save name
    if numel(unique(names))~=1
        saveName = ['Multiple Datasets ' datestr(now,'YYYYMMDDhhmm')];
    else
        saveName = name;
    end
    
    % Save CSV
    if SaveStatsCSV
        OutName = strcat(saveName, ImageSeparator, 'Statistics');
        writetable(dataTable,fullfile(LocationOut,OutName))
        
    end
    
    % Save Fourier Coefficients
    if SaveFourier
        OutName = strcat(saveName, ImageSeparator, 'Fourier Coefficients');
        writetable(fourierTable,fullfile(LocationOut,OutName))

    end
    
    % Save wave numbers
    if SaveWave
        OutName = strcat(saveName, ImageSeparator, 'Wavenumbers');
        writetable(waveTable,fullfile(LocationOut,OutName))

    end
    
    % Save radial metric
    if SaveFR
        OutName = strcat(saveName, ImageSeparator, 'Radial Metric');
        writetable(frTable,fullfile(LocationOut,OutName))

    end
    
    % Save angular metric
    if SaveFA
        OutName = strcat(saveName, ImageSeparator, 'Angular Metric');
        writetable(fthetaTable,fullfile(LocationOut,OutName))

    end
    
    % Save pair metric
    if SaveFP
        OutName = strcat(saveName, ImageSeparator, 'Pair Metric');
        writetable(fThetaTable,fullfile(LocationOut,OutName))

    end
    
    % Extract times and samples
    times = unique(dataTable.Time);
    samples = unique(dataTable.Sample);
    nTimes = numel(times);
    nSamples = numel(samples);
    
    % Initialise arrays
    Ir = zeros(nTimes,nSamples);
    Itheta = zeros(nTimes,nSamples);
    ITheta = zeros(nTimes,nSamples);
    Icsr = zeros(nTimes,nSamples);
    Area = zeros(nTimes,nSamples);
    Rmin = zeros(nTimes,nSamples);
    k = zeros(nTimes,nSamples,Options.nBins(3)/2+1);
    ffTheta = zeros(nTimes,nSamples,Options.nBins(3));
    fr = zeros(nTimes,nSamples,Options.nBins(1));
    ftheta = zeros(nTimes,nSamples,Options.nBins(2));
    fTheta = zeros(nTimes,nSamples,Options.nBins(3));
    
    % Sort into arrays
    for t=1:nTimes
        
        for s=1:nSamples
            
            % Data table
            rows = dataTable.Time==times(t)&dataTable.Sample==samples(s);
            TableTemp = dataTable(rows,:);
            Ir(t,s) = TableTemp{1,5};
            Itheta(t,s) = TableTemp{1,6};
            ITheta(t,s) = TableTemp{1,7};
            Icsr(t,s) = TableTemp{1,8};
            Rmin(t,s) = TableTemp{1,9};
            Rmax(t,s) = TableTemp{1,10};
            Area(t,s) = TableTemp{1,11};
            
            % Fourier table
            rows = fourierTable.Time==times(t)&fourierTable.Sample==samples(s);
            TableTemp = fourierTable(rows,:);
            ffTheta(t,s,:) = TableTemp{1,3:end};
            
            % Wave table
            rows = waveTable.Time==times(t)&waveTable.Sample==samples(s);
            TableTemp = waveTable(rows,:);
            k(t,s,:) = TableTemp{1,3:end};
            
            % Radial metric table
            rows = frTable.Time==times(t)&frTable.Sample==samples(s);
            TableTemp = frTable(rows,:);
            fr(t,s,:) = TableTemp{1,3:end};
            
            % Angular metric table
            rows = fthetaTable.Time==times(t)&fthetaTable.Sample==samples(s);
            TableTemp = fthetaTable(rows,:);
            ftheta(t,s,:) = TableTemp{1,3:end};
            
            % Pair metric table
            rows = fThetaTable.Time==times(t)&fThetaTable.Sample==samples(s);
            TableTemp = fThetaTable(rows,:);
            fTheta(t,s,:) = TableTemp{1,3:end};
            
        end
        
    end
    
    % Save data as MAT file
    if SaveStatsMAT
        OutName = strcat(saveName, ImageSeparator, 'Statistics');
        save(fullfile(LocationOut,OutName),'Ir','Itheta','ITheta','Icsr','Area','Rmin','Rmax','ffTheta','k','fr','ftheta','fTheta')
        
    end
    
end

% Save settings
% S = [fieldnames(Settings) struct2cell(Settings)];
% O = [fieldnames(Options) struct2cell(Options)];
% C = [fieldnames(Controls) struct2cell(Controls)];
% settingsTable = cell2table([S;O;C]);
% settingsTable.Properties.VariableNames = {'Option','Value'};
% writetable(settingsTable,fullfile(PathOut,[saveName ImageSeparator 'Settings']));
