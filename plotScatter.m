function plotScatter(cnvFile,idx,varargin)

% plotScatter makes a general purpose scatter plot from the data contained
% within one CNV or ROS file. This can be used for quick TS or TO diagrams,
% as well as dual sensor behavior analysis. Output can be tailored using 
% variable inputs. This function is provided as a quick and dirty way to
% view the data, and not intended for publication quality figures, so
% only essential arguments are included. 

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

%   idx:            index values of the desired data, supplied as a two 
%                   element vector (e.g. [1 2]), where the first element is
%                   the x variable and the second element is the y
%                   variable. These are the columns of the data matrix
%                   (output from ctd2mat).

% Optional Arguments:
%   'sty'           plot style argument. Default is 0 which does nothing.
%                   Setting sty to 1 will include a diagonal reference line
%                   with a slope of 1, intended for dual sensor analysis.

%   'clr'           color of the scattered data. Default is black. This
%                   argument can be a matlab color (e.g. 'r') or a 3
%                   element color vector (e.g. [0 0 0] for black).

%   'grp'           color grouping variable for optional dynamic control of
%                   the scattered data. This vector must be the same size 
%                   as data columns x and y. This can be used for coloring 
%                   the data by pressure, or for grouping the data by 
%                   a catagory (surface, mid-water, deep, etc). Default
%                   color map is parula.

%   'lab'           colorbar label. This argument must be a string or char
%                   vector with the desired label of the colorbar. This
%                   argument does nothing if the 'grp' variable is not
%                   assigned.

%   'pfx'           file prefix. This is a character string to help make
%                   the output file unique. It will accept a file path to
%                   save the plots in another location, but the path must
%                   exist already (this function will not make folders on
%                   your system).

% Output:   
%                   plots of the data fields in a profile. Default filetype
%                   is jpeg, but this can easily be modifed below.

% This function has been tested on data files from the SBE 9 and SBE 19.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Setup input parser and assign required variables.
p = inputParser;
addRequired(p,'cnvFile');
addRequired(p,'idx');

% Add optional input and assign default values.
addParameter(p,'sty',0);                % default is no one2one line
addParameter(p,'pfx','scatterPlot_')    % default file prefix
addParameter(p,'clr','k')               % default is black
addParameter(p,'grp',0)                 % default is no grouped color
addParameter(p,'lab',' ')               % default is no colorbar label

% Parse the input and extract variables
parse(p,cnvFile,idx,varargin{:});
sty = p.Results.sty;
pfx = p.Results.pfx;
clr = p.Results.clr;
grp = p.Results.grp;
lab = p.Results.lab;

% Generate labels
[~,name] = ctd2mat(cnvFile);
plotLabels = getPlotLabels(name);
saveLabels = getSaveLabels(name);

% Check that index is the correct size
if length(idx)~=2
    disp('THIS FUNCTION REQUIRES TWO INDEX VALUES!')
    return
end

% Assign variables
xx = getVariableColumn(cnvFile,idx(1));
yy = getVariableColumn(cnvFile,idx(2));

% Begin scatter plot
f = figure('Position',[441 189 683 651]);
hold on
if grp==0
    scatter(xx,yy,'Marker','.','MarkerEdgeColor',clr);
else
    scatter(xx,yy,15,grp,'filled')
    c = colorbar;
    c.Label.String = lab;
    c.Label.FontSize = 14;
    % Could change the colormap here if desired.
end
xlabel(plotLabels(idx(1)))
ylabel(plotLabels(idx(2)))
if sty==1   % Optional one 2 one line.
    aa = min([xx yy]);
    bb = max([xx yy]);
    plot([aa bb],[aa bb],'k');  % Makes a line with a slope of 1
end
xlim('padded')
ylim('padded')
grid on
axis square
set(gca,'fontsize',14)
hold off

% Save the file. Default is just a jpeg, but this line can be
% manipulted if pdfs, or different resolutions are desired.
exportgraphics(f,[pfx char(saveLabels(idx(1))) '_' char(saveLabels(idx(2))) '.jpg'])


