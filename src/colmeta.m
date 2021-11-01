function [name,sample,time,magnification] = colmeta(Img,ImgNo)
%COLMETA Get metadata from image
%
%   COLMETA extracts information from a given filename with a suffix.
%
%   Created by Hayden Tronnolone
%   Date created: 22/12/2017

% Sample number
sample = ImgNo;

% Magnification
magnification = Img.zoom;

% Time
if(Img.time == "Days")
    time = 24 * Img.timeDays;
elseif (Img.time == "Hours")
    time = Img.timeHrs;
end

% Remove suffix
if nargin==2
    name = strrep(name,suffix,'');
end
    