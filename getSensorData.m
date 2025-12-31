function [sensorName,serialNum,calDate] = getSensorData(cnvFile)

% getSensorData extracts sensor information from SeaBird .CNV and 
% .ROS file formats. 

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Output:   
%   sensorName:     string vector of sensor names. This is a direct
%                   extraction from the header file, so your output will be
%                   dependent on how the field is typed in the config file.
%
%   serialNum:      string vector of serial numbers. This is a direct
%                   extraction from the header file, so your output will be
%                   dependent on how the field is typed in the config file.
%
%   calDate:        string vector of calibration data. This is a direct
%                   extraction from the header file, so your output will be
%                   dependent on how the field is typed in the config file.
%

% This function has been tested on data files from the SBE 9 and SBE 19
% successfully.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Open file
fid=fopen(cnvFile,'rt');

% Start reading the header. This extracts each line containing sensor
% information and stores it in a cell array.
str='*START*';
n=1;
a=0;
while (~strncmp(str,'# </Sensors>',12))
    str=fgetl(fid);
    
    % Start extracting lines once the sensor info block is reached.
    if (strncmp(str,'# <Sensors',10))
        a = 1;
    end
    if a==1
        inputs{n}=str;
        n = n+1;
    end
end

% Parse the data. This extraction pattern has proven consistent with the
% CNV files that I've tried it on, but take care. Empty strings *could* be
% the cause of your file format not being the same.
NM = inputs(contains(inputs,'#     <!--'));
NM(contains(NM,'Free')) = [];
NM = string(NM)';
sensorName = extractBetween(NM,'--','--');

SN = inputs(contains(inputs,'SerialNumber'));
SN = string(SN)';
serialNum = extractBetween(SN,'>','<');

DT = inputs(contains(inputs,'CalibrationDate'));
DT = string(DT)';
calDate = extractBetween(DT,'>','<');

% Close the file
fclose(fid);

