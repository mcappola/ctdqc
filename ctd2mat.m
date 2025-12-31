function [data,name] = ctd2mat(cnvFile)

% ctd2mat extracts the data and variable names from SeaBird .CNV and 
% .ROS file formats.

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Output:   
%   data:           matrix of file data in columns [:,n] where n is the
%                   number of variables in the file.
%
%   name:           char matrix of data variable names [n,:] where n is the
%                   number of variables in the file.

%                   Example of a name output row:
%                   '# name 2 = t090C: Temperature [ITS-90, deg C]    '

% Adapted from code written by Rich Signell, Derek Fong, Peter Brickley,
% and Carlos Moffat.

% This function has been tested on data files from the SBE 9 and SBE 19
% successfully.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Open file
fid=fopen(cnvFile,'rt');

% Read the header to extract the variable name information and get the
% number of variables. This operation also gets the "bad flag" value.
str='*START*';
while (~strncmp(str,'*END*',5))
    str=fgetl(fid);
    
    % Extract lines that contain name data. Store in a cell array.
    if (strncmp(str,'# name',6))
        var=sscanf(str(7:10),'%d',1);
        var=var+1;  % Count the variables
        names{var}=str;       

    % Get the bad flag value.    
    elseif (strncmp(str,'# bad_flag',10))
        isub=13:length(str);
        bad_flag=sscanf(str(isub),'%g',1);
    end
end

% Extract the data matrix
data=fscanf(fid,'%f',[var inf]);

% Close the file
fclose(fid);

% Replace flagged values with NaN.
idx=find(data==bad_flag);
data(idx)=data(idx)*nan;

% Transpose data into columns
data=data.';

% Convert cell arrays of names to a char matrix. These are easier to deal
% with.
name=char(names);
