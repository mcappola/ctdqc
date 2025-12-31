# ctdqc
Collection of MATLAB functions for handling and conducting insitu quality checks of Seabird CTD ASCII files (CNV and ROS).

## Design Philosophy

CTD processing should be quick, easy, and reproducible. The enemy of this is a highly tailored processing script specific to a single oceanographic cruise. This package strives for ease-of-use and reproducibility by taking a functional programming approach, reducing each data handling operation to its essential minimum. This is possible because of Seabird's rigid and well planned file formatting standards. This collection of functions can be combined in a single script which allows for more complex workflows (see example directory). This package also supports insitu data visualization for quality checking efforts. 

To reduce complexity, data visualization functions and most data extraction functions use the CNV/ROS filename as the primary argument. Future additions will also adhere to this for ease of use. Collaborators are welcome as this package is far from complete. Available functions have been tested on output from the SBE9 and SBE19, but many of the data extraction functions will likely work on most SBE CTDs as the CNV file format is highly standardized. If you want to help extend this package to other SBE sensors or add additional data visualization functions, feel free to reach out!

An essential resource for planning this collection of functions: 
https://www.seabird.com/asset-get.download.jsa?id=69833854944

## Function Descriptions

More detailed descritions on arguments and output can be found in the header of each function.

- ctd2mat extracts the data and variable names from SeaBird .CNV and .ROS file formats.

- getBottleSummary calculates the bottle summary values (mean, standard deviation, and n) from the bottle data (.ROS file). This is just a matlab implementation of what the bottle summary psa file does.

- getNMEA extracts the latitude, longitude, and datetime, from SeaBird .CNV and .ROS files using NMEA integration. Latitude and longitude are converted to decimal format. Date is converted to matlab datetime format and is in UTC (though this could depend on the ship specific configuration).

- makePlotLabels takes in the char matrix of variable names (output of ctd2mat) and returns the relevant portions as strings to make plot labels. Essential information retained is the variable name and unit.

- makeSaveLabels takes in the char matrix of variable names (output of ctd2mat) and returns the relevant portions as strings to make unique file identifiers for saving figures. 

- getSensorData extracts sensor information from SeaBird .CNV and .ROS file formats. 

- getUserInput extracts user input data from SeaBird .CNV and .ROS files. This input is typically added from the logging computer or the deckbox and is usually program/cruise specific. This is left unformatted as data in this field varies widely, or might not exist. 

- getVariable assigns the data column requested via the index argument to the output. This function requires inspection of the CNV files as the index associated with the desired data must be known.

- getVariableMatrix returns a matrix of a single variable from multiple CNV or ROS files. Queried files must have consistent variable structure (processed from the same PSA files). This is the multifile version of getVariableColumn.

- plotBottleStats plots statistics for the bottle summary data. Plots are scattered scans and a box plot for each bottle number. Results are plotted as anomalies. Output can be tailored using variable inputs. This function is provided as a quick and dirty way to view the data, and not intended for publication quality figures, so only essential arguments are included.

- plotProfileData generates profile plots of the data in the CNV file. Output can be tailored using variable inputs. This function is provided as a quick and dirty way to view the data, and not intended for publication quality figures, so only essential arguments are included.

- plotProfileCompare plots a single variable from a list of CNV or ROS files. The list of CNV files can be from the same cast (e.g. upcast vs downcast, downcast vs bottle) or from an entire directory. Since this function searches for the plotted variable based on a user defined index, the CNV files (or ROS files) supplied must be consistent in their variable order (processed from the same PSA files). This function is provided as a quick and dirty way to view the data, and not intended for publication quality figures, so only essential arguments are included.

- plotScatter makes a general purpose scatter plot from the data contained within one CNV or ROS file. This can be used for quick TS or TO diagrams, as well as dual sensor behavior analysis. Output can be tailored using variable inputs. This function is provided as a quick and dirty way to view the data, and not intended for publication quality figures, so only essential arguments are included. 

- plotSensorBias plots the difference between two dual sensors as a timeseries and can be used for inspecting sensor bias and drift. Output can be tailored using variable inputs. This function is provided as a quick and dirty way to view the data, and not intended for publication quality figures, so only essential arguments are included.
