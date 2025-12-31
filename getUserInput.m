function userinput = getUserInput(cnvFile)

% getUserInput extracts user input data from SeaBird .CNV and .ROS files.
% This input is typically added from the logging computer or the deckbox 
% and is usually program/cruise specific. This is left unformatted as data 
% in this field varies widely, or might not exist. 

% Input:    
%   cnvFile:        name of .CNV or .ROS file  (e.g. 'cast002.cnv'). Input 
%                   can be a path to the file.

% Output:   
%   userinput:      char matrix of the user input lines. Typical user input
%                   example from our program below.

% ** Event: 22
% ** Station: B
% ** Latitude: -64.7795
% ** Longitude: -64.04167
% ** Local Time of Cast: 10:36

% This function has been tested on data files from the SBE 9 and SBE 19
% successfully.

% Created on: 20251229
% Last edit: 20251229
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Open the .cnv file as read-only text
fid=fopen(cnvFile,'rt');

% Put into a try catch incase the user data lines don't exist.
try
    str='*START*';
    n = 1;
    while (~strncmp(str,'*END*',5))
        str=fgetl(fid);
        
        if strncmp(str,'**',2)
            input{n} = str;
            n = n+1;
        end
    end
    
    userinput = char(input);
catch
    disp('NO USER INPUT');
    userinput = nan;
end

% Close the file.
fclose(fid)



