function plotSensorBias(cnvList,idx,varargin)

% plotSensorBias plots the difference between two dual sensors as a
% timeseries and can be used for inpecting sensor bias and drift. Output 
% can be tailored using variable inputs. This function is provided as a 
% quick and dirty way to view the data, and not intended for publication 
% quality figures, so only essential arguments are included.

% Input:    
%   cnvList:        list of .CNV or .ROS files (e.g. 'cast002.cnv') given
%                   in a string matrix (n,1) or (1,n) where n is the number
%                   of files. This can be a file path.

%   idx:            index values of the desired data, supplied as a two 
%                   element vector (e.g. [1 2]), where the first element is
%                   the primary sensor and the second element is the
%                   secondary sensor. These are the columns of the data 
%                   matrix (output from ctd2mat).

% Optional Arguments:
%   'dep'           minimum depth (dbar) to be included on the plot. This 
%                   is used for excluding shallow data, which is often 
%                   noisy. Default is 0, which includes all data. Setting 
%                   to 200 would reduce the analysis to data deeper than 
%                   200 dbar.

%   'rng'           data y axis range, supplied as a standard deviation 
%                   multiplier. Default displays all data. Setting this to 
%                   3 includes most of the data but excludes extreme 
%                   outliers.

%   'pfx'           file prefix. This is a character string to help make
%                   the output file unique. It will accept a file path to
%                   save the plots in another location, but the path must
%                   exist already (this function will not make folders on
%                   your system).

% Output:   
%                   plot of the data sensor difference timeseries. Default 
%                   filetype is jpeg, but this can easily be modifed below.

% This function has been tested on data files from the SBE 9

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

% Setup input parser and assign required variables.
p = inputParser;
addRequired(p,'cnvList');
addRequired(p,'idx');

% Add optional input and assign default values.
addParameter(p,'pfx','sensorBias_');    % default file prefix
addParameter(p,'dep',0);                % default does nothing
addParameter(p,'rng',0);                % default includes all data

% Parse the input and extract variables
parse(p,cnvList,idx,varargin{:});
pfx = p.Results.pfx;
dep = p.Results.dep;
rng = p.Results.rng;

% Ensure that it is a string.
cnvList = string(cnvList);

% Use the first file to get the save and plot labels.
[~,name] = ctd2mat(cnvList(1));
saveLabels = getSaveLabels(name);
plotLabels = getPlotLabels(name);

% Find the pressure index incase filtering by pressure is required.
pidx = find(saveLabels==pShortName);

% Check that index is the correct size
if length(idx)~=2
    disp('THIS FUNCTION REQUIRES TWO INDEX VALUES!')
    return
end

% Extract the queried variables and the pressure variable.
out = getVariableMatrix(cnvList,[idx(1) idx(2) pidx]);
var1 = out(:,:,1);
var2 = out(:,:,2);
pres = out(:,:,3);

% Filter out the shallow data using the supplied depth minimum.
if dep~=0
    kill = pres<dep;
    var1(kill) = nan;
    var2(kill) = nan;
end

% Get the size of the data and make a "cast" matrix so that each cast is
% uniquely identifiable.
[xx,yy] = size(var1);
cast = repmat(1:yy,xx,1);

% Vectorize.
var1 = var1(:);
var2 = var2(:);
cast = cast(:);

% Remove NaNs.
kill = isnan(var1) | isnan(var2);
var1(kill) = [];
var2(kill) = [];
cast(kill) = [];

% We try to sort by time just incase. This can fail if the timeJ variable
% isn't assigned by the xmlcon file, so this is in a try/catch. If the user
% has the cnv files organized properly, this operation is unneccesary.
try
    tidx = find(saveLabels=="timeJ");
    time = getVariableMatrix(cnvList,tidx);
    time = time(:);
    time(kill) = [];
    [~,sidx] = sort(time);
    var1 = var1(sidx);
    var2 = var2(sidx);
    cast = cast(sidx);
catch
end

% Calculate the difference between variables.
vardif = var1 - var2;

% Begin plot
f = figure('Position',[27 188 1477 657]);
hold on
gscatter(1:length(vardif),vardif,cast,rand(yy,3),'+',3,'off')
ylabel({plotLabels(idx(1)) + " minus"; plotLabels(idx(2))})
xlabel('Count [n]')
if rng==0
    ylim([-max(abs(vardif))*1.1 max(abs(vardif))*1.1])
else
    ylim([-std(vardif)*rng std(vardif)*rng])
end
xlim([-50 length(vardif)+50])
yline(0,'LineWidth',1.5)
text(0.5,0.95,['Mean = ' num2str(mean(vardif,'omitnan'),'%0.2e') ' +/- ' num2str(std(vardif,'omitnan'),'%0.2e') '  n = ' num2str(length(vardif))],...
    'Units','normalized','HorizontalAlignment','center','Fontsize',14,'fontweight','bold')
set(gca,'fontsize',14)
grid on
box on
hold off

% Save the file. Default is just a jpeg, but this line can be manipulted if
% pdfs, or different resolutions are desired. We include dep and rng to
% ensure that multiple plots of the same cast are unique.
exportgraphics(f,[pfx char(saveLabels(idx(1))) '_' num2str(dep) '_' num2str(rng) '.jpg'])





