function exampleQC(filename)

% This is just a quick example script that shows off some of the utility of
% the CTD QC software package. This example script generates output that is
% useful for instu quality checks and also organizes the data in a 
% a matfile structure which allows for the creation of more complicated 
% plots, also shown.

% For the Palmer Long-Term Ecological Reseach Program, I use a similar 
% version that is good enough for identifying most standard CTD issues.
% This example is written for the SBE 9, but many of the functions have 
% been tested on both the SBE 9 and SBE 19. While untested, this package 
% will still likely be useful for other Seabird CTDs as their file format 
% is highly standardized.

% For this example script, the argument should be the file name as a char 
% or string, without any extensions (i.e. exampleQC('LMG1701_004') which is
% the provided example data).

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% Setup the filenames. 
% This assumes that a bottle was fired (generating a .ROS file) and that 
% the .CNV file was split into a upcast and downcast. We append a 'u' or a 
% 'd' when doing this in the Palmer LTER program.
cnvFile = ['processed/' filename '.cnv'];
rosFile = ['processed/' filename '.ros'];
uFile = ['processed/' 'u' filename '.cnv'];
dFile = ['processed/' 'd' filename '.cnv'];

% Check if a bottle was fired (generating a .ROS file).
if exist(rosFile,'file')
    bottlecheck = 1;
else
    bottlecheck = 0;
end

%% Setup the output directories.

% These must already exist.
fdir = './figures';
ddir = './data';
sdir = './sensor';

%% Extract the sensor information 

% Pulls sensor info and saves to a table. This can be quite useful for
% identifying when a sensor was swapped.
[sensorName,serialNum,calDate] = getSensorData(cnvFile);
sensorTableNames = {'Sensor Channel','Serial Number','Calibration Date'};
sensorTable = table(sensorName,serialNum,calDate,'VariableNames',sensorTableNames);
writetable(sensorTable,[sdir '/' filename '_sensorInfo.csv'])

clear sensorName serialNum calDate sensorTable*

%% Extract the NMEA metadata

% This function gets the latitude, longitude, and time, from the file and
% converts to decimal and matlab format respectively.
[lat,lon,dat] = getNMEA(cnvFile);

%% Extract the downcast data

% This extracts the data and variable name strings from the file. This data
% can be assigned to a variable by searching for specific variable names, 
% as the Seabird "shortName" is always unique and standardized. If you 
% would rather do this manually, variables can be assigned directly using 
% the function getVariableColumn.
[data,name] = ctd2mat(dFile);    
namelist = string(name);
downcast.pres = data(:,(contains(namelist(:),'prDM')));
downcast.depth = data(:,(contains(namelist(:),'depSM')));
downcast.time = data(:,(contains(namelist(:),'timeS')));
downcast.temp_01 = data(:,(contains(namelist(:),'t090C')));
downcast.temp_02 = data(:,(contains(namelist(:),'t190C')));
downcast.cond_01 = data(:,(contains(namelist(:),'c0mS/cm')));
downcast.cond_02 = data(:,(contains(namelist(:),'c1mS/cm')));
downcast.salt_01 = data(:,(contains(namelist(:),'sal00')));
downcast.salt_02 = data(:,(contains(namelist(:),'sal11')));
downcast.doxy_01 = data(:,(contains(namelist(:),'sbeox0ML/L: Oxygen')));
downcast.doxy_02 = data(:,(contains(namelist(:),'sbeox1ML/L: Oxygen')));
downcast.dens_01 = data(:,(contains(namelist(:),'density00')));
downcast.dens_02 = data(:,(contains(namelist(:),'density11')));
downcast.fluorescence = data(:,(contains(namelist(:),'flECO-AFL')));
downcast.transmission = data(:,(contains(namelist(:),'CStarTr0')));
downcast.par = data(:,(contains(namelist(:),'PAR/Irradiance')));
downcast.name = namelist;

clear data name namelist

%% Extract upcast data
[data,name] = ctd2mat(uFile);    
namelist = string(name);
upcast.pres = data(:,(contains(namelist(:),'prDM')));
upcast.depth = data(:,(contains(namelist(:),'depSM')));
upcast.time = data(:,(contains(namelist(:),'timeS')));
upcast.temp_01 = data(:,(contains(namelist(:),'t090C')));
upcast.temp_02 = data(:,(contains(namelist(:),'t190C')));
upcast.cond_01 = data(:,(contains(namelist(:),'c0mS/cm')));
upcast.cond_02 = data(:,(contains(namelist(:),'c1mS/cm')));
upcast.salt_01 = data(:,(contains(namelist(:),'sal00')));
upcast.salt_02 = data(:,(contains(namelist(:),'sal11')));
upcast.doxy_01 = data(:,(contains(namelist(:),'sbeox0ML/L: Oxygen')));
upcast.doxy_02 = data(:,(contains(namelist(:),'sbeox1ML/L: Oxygen')));
upcast.dens_01 = data(:,(contains(namelist(:),'density00')));
upcast.dens_02 = data(:,(contains(namelist(:),'density11')));
upcast.fluorescence = data(:,(contains(namelist(:),'flECO-AFL')));
upcast.transmission = data(:,(contains(namelist(:),'CStarTr0')));
upcast.par = data(:,(contains(namelist(:),'PAR/Irradiance')));
upcast.name = namelist;

clear data name namelist

%% Extract bottle data
if bottlecheck == 1    
    [data,name] = ctd2mat(rosFile);
    namelist = string(name);
    rosette.pres = data(:,(contains(namelist(:),'prDM')));
    rosette.depth = data(:,(contains(namelist(:),'depSM')));
    rosette.temp_01 = data(:,(contains(namelist(:),'t090C')));
    rosette.temp_02 = data(:,(contains(namelist(:),'t190C')));
    rosette.cond_01 = data(:,(contains(namelist(:),'c0mS/cm')));
    rosette.cond_02 = data(:,(contains(namelist(:),'c1mS/cm')));
    rosette.doxy_01 = data(:,(contains(namelist(:),'sbeox0ML/L')));
    rosette.doxy_02 = data(:,(contains(namelist(:),'sbeox1ML/L')));
    rosette.fluorescence = data(:,(contains(namelist(:),'flECO-AFL')));
    rosette.transmission = data(:,(contains(namelist(:),'CStarTr0')));
    rosette.par = data(:,(contains(namelist(:),'PAR/Irradiance')));
    rosette.bottle = data(:,(contains(namelist(:),'Bottles Fired')));
    rosette.name = namelist;
    
    % getBottleSummary generates the mean, standard deviation, and count,
    % of scans that occur during each bottle fireing event. This a matlab 
    % implementation of what the rossum PSA file does.
    [summary,stats,n] = getBottleSummary(rosFile);  
    bottle.summary = summary;
    bottle.stats = stats;
    bottle.n = n;
    bottle.pres = summary(:,(contains(namelist(:),'prDM')));
    bottle.depth = summary(:,(contains(namelist(:),'depSM')));
    bottle.temp_01 = summary(:,(contains(namelist(:),'t090C')));
    bottle.temp_02 = summary(:,(contains(namelist(:),'t190C')));
    bottle.cond_01 = summary(:,(contains(namelist(:),'c0mS/cm')));
    bottle.cond_02 = summary(:,(contains(namelist(:),'c1mS/cm')));
    bottle.doxy_01 = summary(:,(contains(namelist(:),'sbeox0ML/L')));
    bottle.doxy_02 = summary(:,(contains(namelist(:),'sbeox1ML/L')));
    bottle.fluorescence = summary(:,(contains(namelist(:),'flECO-AFL')));
    bottle.transmission = summary(:,(contains(namelist(:),'CStarTr0')));
    bottle.par = summary(:,(contains(namelist(:),'PAR/Irradiance')));
    bottle.name = namelist;
    
    clear data name namelist summary stats n
end

%% Save output
save([ddir '/' filename '.mat'],...
    'downcast',...
    'upcast',...
    'rosette',...
    'bottle',...
    'filename',...
    'lat',...
    'lon',...
    'dat');

%% Basic Science Plots

% Basic profile plots. This can easily be done with plotProfile.m. This 
% function simply plots each desired variable in the supplied file, and you
% can specify which variables you want using the idx argument.

% Index of the scientific variables from the downcast data
idx = [3 4 5 6 7 8 9 10 11 25 26 27 28];
plotProfile(dFile,'idx',idx,'pfx',[fdir '/' filename '_downcast_']);
plotProfile(dFile,'idx',idx,'pfx',[fdir '/' filename '_downcast_'],'dep',200);

% Basic TS, TO, and SO, diagrams using the plotScatter.m function. Desired
% variables are chosen using the idx argument. Here, we use the built in
% functionality to color the data by a third variable, pressure.
pres = getVariableColumn(dFile,1);
plotScatter(dFile,[25 3],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_TS_'])
plotScatter(dFile,[26 5],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_TS_'])
plotScatter(dFile,[7 3],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_TO_'])
plotScatter(dFile,[8 5],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_TO_'])
plotScatter(dFile,[25 7],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_SO_'])
plotScatter(dFile,[26 8],'grp',pres,'lab','Pressure [dbar]','pfx',[fdir '/' filename '_SO_'])

%% Basic Diagnostic Plots

% The function plotScatter can also be used for diagnostic plots loike dual
% sensor analysis. Here we use the built in functionality to add a
% reference line with a slope of one.
plotScatter(dFile,[3 5],'sty',1,'pfx',[fdir '/' filename '_dualsensor_'])
plotScatter(dFile,[4 6],'sty',1,'pfx',[fdir '/' filename '_dualsensor_'])
plotScatter(dFile,[7 8],'sty',1,'pfx',[fdir '/' filename '_dualsensor_'])

% Bottle Statistics
idx = [3 4 5 6 7 8 9 10 11];
plotBottleStats(rosFile,'idx',idx,'pfx',[fdir '/' filename '_bottlestats_'])

% Sensor Bias
plotSensorBias(dFile,[3 5],'dep',200,'rng',15,'pfx',[fdir '/' filename '_sensorbias_'])
plotSensorBias(dFile,[4 6],'dep',200,'rng',15,'pfx',[fdir '/' filename '_sensorbias_'])
plotSensorBias(dFile,[7 8],'dep',200,'rng',15,'pfx',[fdir '/' filename '_sensorbias_'])

% Downcast Upcast Comparison using plotProfileCompare
cnvList = string([dFile;uFile]);
clr = ['r';'b'];
lab = ['DW';'UP'];
idx = [3 4 5 6 7 8 9 10 11 25 26 27 28];
plotProfileCompare(cnvList,idx,'clr',clr,'lab',lab,'pfx',[fdir '/' filename '_updowncompare_']);
plotProfileCompare(cnvList,idx,'clr',clr,'lab',lab,'pfx',[fdir '/' filename '_updowncompare_'],'dep',200);


%% Diagnostic Plots; Downcast vs Bottle
if bottlecheck == 1
    f = figure('Position',[263 79 1078 813]);
    tl = tiledlayout(1,2,'TileSpacing','tight');
    xlabel(tl,'Temperature [C]','fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.temp_01,downcast.pres,'r')
    plot(bottle.temp_01,bottle.pres,'ro')
    plot(downcast.temp_02,downcast.pres,'b--')
    plot(bottle.temp_02,bottle.pres,'b+')
    axis ij
    ylabel('Pressure [dbar]')
    hold off
    set(gca,'fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.temp_01,downcast.pres,'r')
    plot(bottle.temp_01,bottle.pres,'ro')
    plot(downcast.temp_02,downcast.pres,'b--')
    plot(bottle.temp_02,bottle.pres,'b+')
    axis ij
    ylim([0 200])
    legend('01 Down','01 Bottle','02 Down','02 Bottle','Location','southeast')
    hold off
    set(gca,'fontsize',14)
    
    exportgraphics(f,[fdir '/' filename '_bottlecheck_temp.jpg'],'Resolution',500);
    
    f = figure('Position',[263 79 1078 813]);
    tl = tiledlayout(1,2,'TileSpacing','tight');
    xlabel(tl,'Conductivity [mS/cm]','fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.cond_01,downcast.pres,'r')
    plot(bottle.cond_01,bottle.pres,'ro')
    plot(downcast.cond_02,downcast.pres,'b--')
    plot(bottle.cond_02,bottle.pres,'b+')
    axis ij
    ylabel('Pressure [dbar]')
    hold off
    set(gca,'fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.cond_01,downcast.pres,'r')
    plot(bottle.cond_01,bottle.pres,'ro')
    plot(downcast.cond_02,downcast.pres,'b--')
    plot(bottle.cond_02,bottle.pres,'b+')
    axis ij
    ylim([0 200])
    legend('01 Down','01 Bottle','02 Down','02 Bottle','Location','southeast')
    hold off
    set(gca,'fontsize',14)
    
    exportgraphics(f,[fdir '/' filename '_bottlecheck_cond.jpg'],'Resolution',500);
    
    f = figure('Position',[263 79 1078 813]);
    tl = tiledlayout(1,2,'TileSpacing','tight');
    xlabel(tl,'Dissolved Oxygen [ml/l]','fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.doxy_01,downcast.pres,'r')
    plot(bottle.doxy_01,bottle.pres,'ro')
    plot(downcast.doxy_02,downcast.pres,'b--')
    plot(bottle.doxy_02,bottle.pres,'b+')
    axis ij
    ylabel('Pressure [dbar]')
    hold off
    set(gca,'fontsize',14)
    
    nexttile
    hold on
    grid on
    plot(downcast.doxy_01,downcast.pres,'r')
    plot(bottle.doxy_01,bottle.pres,'ro')
    plot(downcast.doxy_02,downcast.pres,'b--')
    plot(bottle.doxy_02,bottle.pres,'b+')
    axis ij
    ylim([0 200])
    legend('01 Down','01 Bottle','02 Down','02 Bottle','Location','southeast')
    hold off
    set(gca,'fontsize',14)
    
    exportgraphics(f,[fdir '/' filename '_bottlecheck_doxy.jpg'],'Resolution',500);
end

