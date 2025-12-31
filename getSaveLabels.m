function saveLabels = getSaveLabels(name)

% makeSaveLabels takes in the char matrix of variable names (output of 
% ctd2mat) and returns the relevant portions as strings to make unique file
% identifiers for saving figures. 

% Input:    
%   name:           char matrix of data variable names [n,:] where n is the
%                   number of variables in the file.

% Output:   
%   saveLabels:     string vector of unique file system safe names [n] 
%                   where n is the number of variables in the file.

% This function has been tested on data files from the SBE 9 and SBE 19
% successfully.

% This function is just extracting Seabird's unique shortName used for each
% variable and removing any slashes so that it can safely be used as a file
% name. List of short names can be found in this reference: 
% manual-Seassoft_DataProcessing_7268.pdf

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

aa = string(name);
bb = extractAfter(aa,'= ');
cc = extractBefore(bb,':');
saveLabels = erase(cc,'/');     % can't use a slash in a filename
