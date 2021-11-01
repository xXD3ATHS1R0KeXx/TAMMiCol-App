function [sample,time,magnification,extn] = colmeta(Img,ImgNo)
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

% Get the extension
[is,ie] = regexp(Img.fileName,'\.[0-9a-z]+$');
extn = Img.fileName(is:ie);
    