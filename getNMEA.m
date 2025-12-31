function [lat,lon,dat] = getNMEA(cnvFile)

% getNMEA extracts the latitude, longitude, and datetime, from SeaBird .CNV 
% and .ROS files using NMEA integration. Latitude and longitude are
% converted to decimal format. Date is converted to matlab datetime
% format and is in UTC (though this could depend on the ship specific
% configuration).

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Output:   
%   lat:            latitude in decimal format (positive north)
%
%   lon:            longitude in decimal format (positive east)
%   
%   dat:            date in matlab datetime format

% NMEA is a standarized format, so this *should* always work. If this
% function fails, check the NMEA lines in your cnv file. This function
% expects the NMEA lines to be in the format below.

% * NMEA Latitude = 64 55.95 S
% * NMEA Longitude = 064 35.76 W
% * NMEA UTC (Time) = Jan 08 2017  08:18:12

% Adapted from code written by Rich Signell, Derek Fong, Peter Brickley,
% and Carlos Moffat.

% This function has been tested on data files from the SBE 9 with NMEA
% integration.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Open file
fid=fopen(cnvFile,'rt');

% Read the header to extract NMEA data
str='*START*';
while (~strncmp(str,'*END*',5))
    str=fgetl(fid);
    
    % Extract the latitude string and convert to decimal.
    if (strncmp(str,'* NMEA Lat',10))
        is=findstr(str,'=');
        isub=is+1:length(str);
        dm=sscanf(str(isub),'%f',2);
        if(findstr(str(isub),'N'))
            lat=dm(1)+dm(2)/60;
        else
            lat=-(dm(1)+dm(2)/60);
        end
        
    % Extract the longitude string and convert to decimal.
    elseif (strncmp(str,'* NMEA Lon',10))
        is=findstr(str,'=');
        isub=is+1:length(str);
        dm=sscanf(str(isub),'%f',2);
        if(findstr(str(isub),'E'))
            lon=dm(1)+dm(2)/60;
        else
            lon=-(dm(1)+dm(2)/60);
        end
        
    % Extract the UTC string and convert to matlab datetime.
    elseif (strncmp(str,'* NMEA UTC',10))
        is = findstr(str,'=');
        dat = datetime(datevec(datenum(str(is+1:end),'mmm dd yyyy HH:MM:SS')));
    end
end

% Close the file
fclose(fid);


