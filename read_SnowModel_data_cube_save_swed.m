% Simple script to save SnowModel .gdat data as .txt files for a specified
% varable of intrest.
%
% Adapted from readSnowModel.m
% Adapted from Ryan Crumley's plot_SWED_video.m script mainly
%
% The script needs read_grads.m in the same folder to work
%
% See also a second function readXY below that outputs a vector of Z values for 
% a particular coordinate pair (useful for comparing to met data or depth obs!)
%
% Every .txt saved corosponds to the model time step 

% Select the start date of the model run
startdate=[2015,10,1];

% Select the .ctl file and variable
ctl_file='swed.ctl'; % The ctl file you're interested in
var_name='swed'; % The variable you're interested in

% Select other parameters
timesteps = 366; %See ZDEF in .ctl file
xll=489747;  %This is the bottom left corner of the SnowModel domain
yll=4853924; %This is the bottom left corner of the SnowModel domain
nx=1121; %See XDEF in .ctl file 
ny=759;  %See YDEF in .ctl file
cell=100; %This is the size of the cell in meters

[X,Y,Z,timevec,xmax,ymax] = readGDAT(startdate,timesteps,ctl_file,var_name,xll,yll,nx,ny,cell);

% Mikey's code to save the data to .txt files
%
% Script to save each timestep adapted from readSnowModel.m
% 
% For this to work you will need the following files in a folder
% - snowmodel .dat file
% - snowmodel .ctl file
% - read_grads.m
%

% Make a new folder to save the data
folder_name = strcat(var_name,' Data Cube Files')
mkdir(folder_name)

% Save data into the new folder
for i = 1:timesteps
file_name = strcat(folder_name,'/',var_name,'_',num2str(i),'.txt')
Time_Slice = Z(:,:,i);
save(file_name, 'Time_Slice', '-ascii', '-double', '-tabs')
end
% End Mikey's Code


% A simple function to read from a SnowModel daily.gdat file using a ctl 
% file, returning a Z is a 'cube' of wanted values, with the third dimension
% being time
%
% [X,Y,Z,timevec,xmax,ymax] returns the size of the data cube, a vector holding
% the timesteps associated with the Z dimension, and the max x and y
% coordinates for use in readXY for example
%
% 'startdate' is a date vector in form of [Y,M,D] e.g. [2002,1,1]
% 'timesteps' is the number of timesteps of the DAILY model run
% 'ctl_file' is the ctl file you want to point at
% 'var_name' is the variable of interest held in the ctl file
% 'xll' is the bottom left x coord of the SnowModel domain
% 'yll' is the bottom left y coord of the SnowModel domain
% 'nx' is the number of cells in the x direction
% 'yx' is the number of cells in the y direction
% 'cell' is the size of each cell in meters
% 'time_offset' [OPTIONAL] is if you want to read the data from later in
% the model run

function [X,Y,Z,timevec,xmax,ymax] = readGDAT(startdate,timesteps,ctl_file,var_name,xll,yll,nx,ny,cell,time_offset)
    if ~exist('time_offset','var') %this checks if the optional 'time_offset' argument exists
        time_offset = 1; % and sets it to 1 is not
    end
    time_offset = time_offset - 1; % this takes a day away from the offset to account for day 1
    startdate=datenum(startdate); % converts date vector to matlab format datenumber
    timevec=startdate:1:startdate+(timesteps-1); % creates a vector of datenumbers the length of the model run
    xmin=xll;
    ymin=yll;
    xmax=xmin+nx*cell; % finds the maximum x coord
    ymax=ymin+ny*cell; % finds the maximum y coord
    [X,Y]=meshgrid(xmin:cell:xmax-cell,ymin:cell:ymax-cell); % Create a mesh grid of the model domain space with the right coordinates
    for j=1:length(timevec); % Loop to create the Z cube
        nt=(j+time_offset); % Starts the loop at the appropriate timestep
        [var,h]=read_grads(ctl_file,var_name,'x',[1 nx],'y',[1 ny],'z',[1 1],'t',[nt nt]); 
        Z(:,:,j)=(var'); % So now, Z is a 'cube' of values of the chosen variable, with the third dimension being time.
    end
end

% A simple function to find the grid cell value related to a certain set of
% xy coordinates e.g. a SNOTEL station.
function [values] = readXY(pointx,pointy,timevec,xmax,ymax,cell,Z);
    values = zeros(1,length(timevec)); % creates vector of length of time steps
    for j=1:length(values); % iterates for the length of the timevector
        timestep = j; % the timestep
        cellx = floor((xmax - pointx)/cell); % finds the correct integer x cell value for the Z array
        celly = floor((ymax - pointy)/cell); % finds the correct integer y cell value for the Z array

        values(1,j) = Z(cellx,celly,timestep);
        values(2,j) = timevec(j);
    end
end
