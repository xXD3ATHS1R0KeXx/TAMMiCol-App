function [ir,ia,itheta,iTheta,icsr,iagg,iw,k,Rmin,Rmax,Area,ffp,fr,fa,fp,centresR,centresA,centresP]=statcalc(C,Options,Rmin)

%STATCALC Disk statistics
%
%   STATCALC provides statistics for a given binary image C. The statistics
%   used by TAMMiCol are described in the user guide.
%
%   Created by Hayden Tronnolone
%   Date created: 23/06/2017

% Create empty structure if no options specified
if nargin<2
    Options = struct('a',[]);
end

% Default bin numbers
if isfield(Options,'nBins')
    nBinsR = Options.nBins(1);
    nBinsA = Options.nBins(2);
    nBinsP = Options.nBins(3);
else
    nBinsR=50; nBinsA=50; nBinsP=50;
end

% Default to CSR radius
if isfield(Options,'RadiusMethod')
    RadiusMethod = Options.RadiusMethod;
else
    RadiusMethod = 'CSR';
end

if isfield(Options,'RadiusProportion')
    RadiusProportion = Options.RadiusProportion;
else
    RadiusProportion = 1;
end

% Default to centred data
if isfield(Options,'CentreData')
    CentreData = Options.CentreData;
else
    CentreData = 1; 
end

% Default to annulus
if isfield(Options,'Annulus')
    Annulus = Options.Annulus;
else
    Annulus = 1;
end

% Check if radius method is defined
if ~isempty('Rmin','var')
    calcRadius = true;
elseif isempty(Rmin)
    calcRadius = true;
else
    calcRadius = false;
end

% Maximum number of cells for pair correlation
if isfield(Options,'MaxCells')
    MaxCells = Options.MaxCells;
else
    MaxCells = 1e3;
end

% Number of samples for pair correlation
if isfield(Options,'PairSamples')
    PairSamples = Options.PairSamples;
else
    PairSamples = 1;
end

% Get cell co-ordinates
if  size(C,1)>1&&size(C,2)>1% Lattice data
    
    % Ensure binary
    if ~all(ismember(C(:),[0,1]))
        C = C/max(C(:));
    end
    
    % Use only one dimension
    if size(C,3)>1
        C = C(:,:,1);
    end
    
    [y,x] = find(C);
    z = complex(x,y);
    nPoints = sum(C(:));
    
else % Complex data
    z = C(:);
    nPoints = numel(C);
end

zm = mean(z);

% Substract centroid
if CentreData
    z = z - zm;
end

% Create components and find lengths
zLengths = abs(z);
Rmax = max(zLengths);
rho = nPoints/(pi*Rmax^2);

% Area
Area = bwarea(C);

% Area index
ia = 1 - rho;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Radial statistics %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Radial count (evenly-spaced bins)
% deltaR = radius/nBinsR;
% edgesR = deltaR*(0:nBinsR);
% centresR = deltaR/2:deltaR:radius;
% cr = histcounts(abs(z),edgesR);
% fr = cr./(pi*rho*deltaR^2*(2*(1:nBinsR)-1));

% Radial count (equal-area bins)
areaBin = pi*Rmax^2/nBinsR;
edgesR = sqrt((0:nBinsR)*areaBin/pi);
centresR = (edgesR(2:end)+edgesR(1:end-1))/2;
cr = histcounts(abs(z),edgesR);
fr = cr/(rho*areaBin);

% Radius of interest
if calcRadius
    
    if strcmpi(RadiusMethod,'Punch') % Punch radius
        
        [yy,xx] = find(C==0);
        zz = complex(xx,yy);
        d = min(abs(zz-zm));
        Rmin = max(abs(z(abs(z)<d)));
        
    elseif strcmpi(RadiusMethod,'CSR')
        
        % CSR radius
        jcsr = find(fr>=1,1,'last');
        Rmin = centresR(jcsr);
        
    end
    
end

% Radial index
ir = 1 - Rmin/Rmax;

%%%%%%%%%%%%%%%%%%%%%%
%%% Area statistic %%%
%%%%%%%%%%%%%%%%%%%%%%

[yy,xx] = find(C==0);
zz = complex(xx,yy);
d = min(abs(zz-zm));

% Compute minimum radius
if sum(C(:))==numel(C)
    RminP = inf;
elseif sum(C(:))==0
    RminP = 0;
else
    RminP = max(abs(z(abs(z)<d)));
end

% Scale and ensure Rmin is no larger than the entire colony
Rmin = min([RadiusProportion*Rmin,Rmax]);

% Only use cells at or above the inner radius
if Annulus
    z = z(abs(z)>=Rmin);
    nPoints = numel(z);
end

% Compute angles
angles = angle(z);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Angular statistics %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Angular histogram
deltaA = 2*pi/nBinsA;
edgesA = linspace(-pi,pi,nBinsA+1);
centresA = (-pi+deltaA/2):deltaA:pi-deltaA/2;
ca = histcounts(angles,edgesA);
fa = nBinsA*ca/(nPoints);

% Angular index
itheta = sqrt(var(fa,1)/(nBinsA - 1));

%%%%%%%%%%%%%%%%%%%%%%%
%%% Pair statistics %%%
%%%%%%%%%%%%%%%%%%%%%%%

fpSamples = zeros(nBinsP,PairSamples);

% Repeat samples
for j=1:PairSamples
    % Pair angle differences
    zp = z(randsample(length(z),min([length(z),MaxCells])));
    nCellsSample = length(zp);
    angles = angle(zp);
    angleDiffs = pdist(angles);
    angleDiffs = min([angleDiffs; 2*pi-angleDiffs]);

    % Warn if negative angle differences are found
    if any(angleDiffs<0)
        %warning('Negative angle differences found')
    end

    % Warn if angles above pi are found
    if any(angleDiffs>pi)
        %warning('Angle differences greater than pi found')
    end

    % Count and scale
    deltaP = pi/nBinsP;
    edgesP = deltaP*(0:nBinsP);
    centresP = deltaP/2:deltaP:pi;
    cp = histcounts(angleDiffs,edgesP);
    fpSamples(:,j) = 2*nBinsP*cp./(nCellsSample*(nCellsSample-1));

end

fp = mean(fpSamples,2).';

% Fourier transform
ffp = fft(fp);

% Pair index
iTheta = fp(1)/nBinsP;

% CSR index
icsr = sqrt(var(fp,1)/(nBinsP - 1));

% Sum of terms up to fp = 1
jUnity = find(fp<1,1,'first');
iagg = sum(fp(1:jUnity))/nBinsP;
iw = centresP(jUnity)/pi;
if isempty(iw)
    iw = 0;
end

% Spectrum and wavenumbers
psf = abs(ffp(1:nBinsP/2+1)).^2/nBinsP; psf(2:end-1) = 2*psf(2:end-1);
[~,k] = sort(psf,'descend'); k = k - 1;