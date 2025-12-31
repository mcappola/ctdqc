function plotProfile(cnvFile,varargin)

% plotProfileData generates profile plots of the data in the CNV file. 
% Output can be tailored using variable inputs. This function is provided 
% as a quick and dirty way to view the data, and not intended for 
% publication quality figures, so only essential arguments are included.

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Optional Arguments:
%   'idx'           index value of the desired data, supplied as a scalar
%                   for a single plot, or a vector (e.g. [6 15 19]) for
%                   multiple plots. If no value is supplied, the function
%                   will produce a plot for each data field (including
%                   non-scientific ones like longitude).

%   'dep'           maximum y axis (pressure) value for the plot. If not
%                   supplied, the function will use the maximum pressure
%                   value.

%   'pfx'           file prefix. This is a character string to help make
%                   the output file unique. It will accept a file path to
%                   save the plots in another location, but the path must
%                   exist already (this function will not make folders on
%                   your system).

% Output:   
%                   plots of the data fields in a profile. Default filetype
%                   is jpeg, but this can easily be modifed below.

% This function has been tested on data files from the SBE 9 and SBE 19.

% NOTE: This function must be able to identify the pressure variable. This
% operation uses the SBE "short name" pattern for the pressure sensor,
% which varies by sensor used. This file written to expect a SBE 9 CTD that
% uses the Digiquartz pressure sensor, which is a standard setup for most 
% institutions. If your SBE CTD uses another pressure variable, update
% the variable 'pShortName' (below) to use your pressure sensor's unique 
% short name from this manual: manual-Seassoft_DataProcessing_7268.pdf. 

% SBE 9: prDM
% SBE 19: prdM
pShortName = 'prDM';

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Get the data and variable names
[data,name] = ctd2mat(cnvFile);

% Get the size of the data
[~,yy] = size(data);

% Convert to string vector. Easier to deal with.
namelist = string(name);

% Extract the pressure profile
pres = data(:,(contains(namelist(:),pShortName)));

% Setup input parser and assign required variables.
p = inputParser;
addRequired(p,'cnvFile');

% Add optional input and assign default values.
addParameter(p,'idx',1:yy);         % Plots every variable
addParameter(p,'dep',max(pres))     % Plots entire profile
addParameter(p,'pfx','profile_')    % Basic file prefix

% Parse the input and extract variables
parse(p,cnvFile,varargin{:});
idx = p.Results.idx;
dep = p.Results.dep;
pfx = p.Results.pfx;

% We want the index of the pressure variable so we don't waste time
% plotting pressure with respect to pressure.
pidx = find(contains(namelist(:),pShortName));
idx(idx==pidx) = [];

% Create plot and save labels from the char matrix names.
plotLabels = getPlotLabels(name);
saveLabels = getSaveLabels(name);

for ii = 1:length(idx)
    var = idx(ii);    
    
    f = figure('Position',[490 98 574 813]);
    hold on
    scatter(data(:,var),pres,'k.')
    ylabel(plotLabels(pidx))
    xlabel(plotLabels(var))
    ylim([0 dep])
    axis ij
    grid on
    box on
    set(gca,'fontsize',14)
    hold off
    
    % Save the file. Default is just a jpeg, but this line can be
    % manipulted if pdfs, or different resolutions are desired.
    exportgraphics(f,[pfx char(saveLabels(var)) '_' num2str(dep) '.jpg'])    
end




