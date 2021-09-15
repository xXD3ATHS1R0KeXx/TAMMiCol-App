function [name,sample,time,magnification] = colmeta(fileName,suffix)
%COLMETA Get metadata from image
%
%   COLMETA extracts information from a given filename with a suffix.
%
%   Created by Hayden Tronnolone
%   Date created: 22/12/2017

% Initialise name
name = fileName;

% Sample number
[is,ie] = regexp(fileName,'[s][0-9]+');
sample = str2double(fileName(is+1:ie));
if isempty(sample)
    sample = nan;
else
    name = strrep(name,fileName(is:ie),'');
end

% Magnification
[is,ie] = regexp(fileName,'[0-9]+X');
magnification = str2double(fileName(is:ie-1));
if isempty(magnification)
    magnification = nan;
else
    name = strrep(name,fileName(is:ie),'');
end

% Time
[is,ie] = regexp(fileName,'[0-9]+h');
time = str2double(fileName(is:ie-1));
if isnan(time)
    
    % Check for time in days
    [is,ie] = regexp(fileName,'d[0-9]+');
    time = 24*str2double(fileName(is+1:ie));
    
    % Set as empty if no value found
    if isempty(time)
        time = nan;
    else
        name = strrep(name,fileName(is:ie),'');
    end
    
else
    name = strrep(name,fileName(is:ie),'');
end

% Remove suffix
if nargin==2
    name = strrep(name,suffix,'');
end

% Trim spaces
name = strtrim(name);
    