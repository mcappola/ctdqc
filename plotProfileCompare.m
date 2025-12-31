function plotProfileCompare(cnvList,idx,varargin)

% plotProfileCompare plots a single variable from a list of CNV or ROS 
% files. The list of CNV files can be from the same cast (e.g. upcast vs 
% downcast, downcast vs bottle) or from an entire directory. Since this 
% function searches for the plotted variable based on a user defined index,
% the CNV files (or ROS files) supplied must be consistent in their 
% variable order (processed from the same PSA files). This function is 
% provided as a quick and dirty way to view the data, and not intended for 
% publication quality figures, so only essential arguments are included.

% Input:    
%   cnvList:        list of .CNV or .ROS files (e.g. 'cast002.cnv') given
%                   in a string matrix (n,1) or (1,n) where n is the number
%                   of files. This can be a file path.

%   idx:            index value of the desired data, supplied as a scalar.
%                   This index is the column of the data matrix (output 
%                   from ctd2mat).

% Optional Arguments:
%   'dep'           maximum y axis (pressure) value for the plot. If not
%                   supplied, the function will use the maximum pressure
%                   value.

%   'clr'           color data where a single color is defined for each
%                   file in the supplied cnvList. This can be a char matrix
%                   of matlab colors (e.g. ['r';'b'] or {'r','b'}) or a 3
%                   element nuumerical color matrix (e.g. [0 0 0]). In both
%                   cases, the length of the color data must match the
%                   length of the cnvList (number of files). If this is not
%                   supplied, the plot uses matlab's default color order.

%   'lab'           label for an optional legend, supplied as a string
%                   matrix with the same number of elements as the cnvList.
%                   Not recommened for a large filelist. Default location
%                   is the southeast.

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

% Extract the name data from the first file.
[~,name] = ctd2mat(cnvList(1));

% Convert the name char matrix to a string vector.
namelist = string(name);

% Create plot and save labels from the char matrix names.
plotLabels = getPlotLabels(name);
saveLabels = getSaveLabels(name);

% Get the index of the pressure variable so we can use its name.
pidx = find(contains(namelist(:),pShortName));

% Extract data
pres = getVariableMatrix(cnvList,pidx);
prof = getVariableMatrix(cnvList,idx);

% Get the deepest pressure.
[mxp,~] = size(pres);

% Setup input parser and assign required variables.
p = inputParser;
addRequired(p,'cnvList');
addRequired(p,'idx');

% Add optional input and assign default values.
addParameter(p,'dep',mxp);                          % Plots entire profile
addParameter(p,'clr',repelem("k",numel(cnvList)));  % Default is black
addParameter(p,'lab',0);                            % Default does nothing
addParameter(p,'pfx','profileCompare_');            % Basic file prefix

% Parse the input and extract variables
parse(p,cnvList,idx,varargin{:});
dep = p.Results.dep;
clr = p.Results.clr;
lab = p.Results.lab;
pfx = p.Results.pfx;
    
% Begin plot
if length(idx)==1
    f = figure('Position',[490 98 574 813]);
    hold on
    scatter(prof,pres,'Marker','.')
    colororder(clr)
    if ~isnumeric(lab)
        legend(lab,'Location','southeast')
    end
    ylabel(plotLabels(pidx))
    xlabel(plotLabels(idx))
    ylim([0 dep])
    axis ij
    grid on
    box on
    set(gca,'fontsize',14)
    hold off
    
    
% Save the file. Default is just a jpeg, but this line can be
% manipulted if pdfs, or different resolutions are desired. I add the max
% plot depth to ensure that multiple versions of the same cast (shallow and
% deep) are unique.
exportgraphics(f,[pfx char(saveLabels(idx)) '_' num2str(dep) '.jpg'])


else
    for jj = 1:length(idx)
        f = figure('Position',[490 98 574 813]);
        hold on
        scatter(prof(:,:,jj),pres,'Marker','.')
        colororder(clr)
        if ~isnumeric(lab)
            legend(lab,'Location','southeast')
        end
        ylabel(plotLabels(pidx))
        xlabel(plotLabels(idx(jj)))
        ylim([0 dep])
        axis ij
        grid on
        box on
        set(gca,'fontsize',14)
        hold off
        
        
        % Save the file. Default is just a jpeg, but this line can be
        % manipulted if pdfs, or different resolutions are desired. I add the max
        % plot depth to ensure that multiple versions of the same cast (shallow and
        % deep) are unique.
        exportgraphics(f,[pfx char(saveLabels(idx(jj))) '_' num2str(dep) '.jpg'])    
        
    end
end




