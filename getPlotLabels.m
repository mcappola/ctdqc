function plotLabels = getPlotLabels(name)

% makePlotLabels takes in the char matrix of variable names (output of 
% ctd2mat) and returns the relevant portions as strings to make plot 
% labels. Essential information retained is the variable name and unit.

% Input:    
%   name:           char matrix of data variable names [n,:] where n is the
%                   number of variables in the file.

% Output:   
%   plotLabels:     string vector of plot label names [n] where n is the
%                   number of variables in the file.


% This function has been tested on data files from the SBE 9 and SBE 19
% successfully.

% This function has been tested with the variables I have deployed, but
% there are many sensors available for CTD integration that I have not
% deployed. This *should* always work as Seabird is typically very
% consistent with their variable naming structure, but results *could*
% vary. List of variable names can be found in this reference: 
% manual-Seassoft_DataProcessing_7268.pdf

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

aa = string(name);
bb = extractAfter(aa,': ');
plotLabels = erase(bb,'  ');
