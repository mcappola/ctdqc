function [summary,stats,n] = getBottleSummary(cnvFile)

% getBottleSummary calculates the bottle summary values (mean, standard 
% deviation, and n) from the bottle data (.ROS file). This is just a matlab 
% implementation of what the bottle summary psa file does.

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Output:   
%   summary:        mean value of every sensor scan associated with each
%                   bottle firing
%
%   stats:        	std value of every sensor scan associated with each
%                   bottle firing
%   
%   n:              number of sensor scans associated with each bottle 
%                   firing

% This function has been tested on data files from the SBE 9.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Extract the data and name fields from the CNV file.
[data,name] = ctd2mat(cnvFile);

% Convert char matrix to string matrix.
namelist = string(name);

% We need the bottle variable which will serve as a grouping variable for
% averaging scans.
bottle = data(:,(contains(namelist(:),'Bottles Fired')));

% Calculate the mean, standard deviation, and number of scans for each
% variable. We do this for every variable, not just the "science" variables
% for coding simplicity.
for ii = 1:max(unique(bottle))
    for jj = 1:length(namelist)
        summary(ii,jj) = mean(data(bottle==ii,jj),'omitnan');
        stats(ii,jj) = std(data(bottle==ii,jj),'omitnan');
        n(ii,jj) = length(~isnan(data(bottle==ii,jj)));
    end
end

