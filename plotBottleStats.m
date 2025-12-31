function plotBottleStats(rosFile,varargin)

% plotBottleStats plots statistics for the bottle summary data. Plots are 
% scattered scans and a box plot for each bottle number. Results are 
% plotted as anomalies. Output can be tailored using variable inputs. This 
% function is provided as a quick and dirty way to view the data, and not 
% intended for publication quality figures, so only essential arguments are
% included.

% Input:    
%   rosFile:        name of .ROS file  (e.g. 'cast002.ros'). Input 
%                   can be a path to the file.

% Optional Arguments:
%   'idx'           index value of the desired data, supplied as a scalar
%                   for a single plot, or a vector (e.g. [6 15 19]) for
%                   multiple plots. If no value is supplied, the function
%                   will produce a plot for each data field (including
%                   non-scientific ones like longitude)

%   'pfx'           file prefix. This is a character string to help make
%                   the output file unique. It will accept a file path to
%                   save the plots in another location, but the path must
%                   exist already (this function will not make folders on
%                   your system).

% Output:   
%                   saved plot(s) of the data field(s). Default filetype
%                   is jpeg, but this can easily be modifed below.

% This function has been tested on data files from the SBE 9.

% Note: the plotted box plots are centered around the mean instead of the 
% median which is more typical. This is because the mean value is what is 
% used in the standard output bottle data.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Get the data and variable names
[data,name] = ctd2mat(rosFile);
plotLabels = getPlotLabels(name);
saveLabels = getSaveLabels(name);
namelist = string(name);

% Get the size of the data
[~,yy] = size(data);

% Setup input parser and assign required variables.
p = inputParser;
addRequired(p,'rosFile');

% Add optional input and assign default values.
addParameter(p,'idx',1:yy);                 % Plots every variable
addParameter(p,'pfx','bottleStats_')        % Basic file prefix

% Parse the input and extract variables
parse(p,rosFile,varargin{:});
idx = p.Results.idx;
pfx = p.Results.pfx;

% We need the bottle variable which will serve as a grouping variable for
% averaging scans.
bottle = data(:,(contains(namelist(:),'Bottles Fired')));

% How many bottles were fired?
nbot = max(bottle);

% Loop through each supplied index value and generate the plot.
for ii = 1:length(idx)
    var = idx(ii);
    
    f = figure('Position',[199 176 1191 601]);
    hold on
    mx = nan(size(idx));
    for xx = 1:nbot
        yy = data(bottle==xx,var);
        yy = yy - mean(yy);
        mx(xx) = max(abs(yy));
        
        plot(xx,yy,'k.')
        myboxplot(xx,yy,0.3,'r',0.3)
    end
    xticks(1:nbot)
    xlim([0 nbot+1]) % Box plot is on the tick so the edges need to be wider.
    ylim([-max(mx)*1.1 max(mx)*1.1])
    xlabel('Bottle Number')
    ylabel([plotLabels(var) "Anomaly"])
    set(gca,'fontsize',14)
    grid on
    hold off
    
    % Save the file. Default is just a jpeg, but this line can be
    % manipulted if pdfs, or different resolutions are desired.
    exportgraphics(f,[pfx char(saveLabels(var)) '.jpg'])
end

end % terminates the first function so the box plot function is distinct.

%% Box plot function

% Note that this box plot is centered around the mean instead of the median
% which is more standard.

function myboxplot(x,y,boxWidth,boxColor,boxAlpha)

if isempty(y)
    return
end

% Calculate the summary statistics
MAX = max(y);
MIN = min(y);
MEA = mean(y,'omitnan');
Q = quantile(y,[0.25 0.75]);
QLW = Q(1);
QUP = Q(2);

% Now we want to plot the values.
plot([x-boxWidth x+boxWidth],[MAX MAX],'k-')
plot([x-boxWidth x+boxWidth],[MIN MIN],'k-')
plot([x x],[QUP MAX],'k:')
plot([x x],[MIN QLW],'k:')
patch([x-boxWidth x-boxWidth x+boxWidth x+boxWidth],[QLW QUP QUP QLW],boxColor,'edgecolor','k','facealpha',boxAlpha)
plot([x-boxWidth x+boxWidth],[MEA MEA],'k-','LineWidth',1.5)

end













