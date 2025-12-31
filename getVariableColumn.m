function out = getVariableColumn(cnvFile,idx)

% getVariable assigns the data column requested via the index argument to 
% the output. This function requires inspection of the CNV files as the
% index associated with the desired data must be known.

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

%   idx:            index of desired data. This is the column number of the
%                   data matrix (output of ctd2mat).

% Output:
%   out:            the queried data column as a vector.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Extract the data matrix
[data,~] = ctd2mat(cnvFile);

% Use input to assign the data to the output.
out = data(:,idx);