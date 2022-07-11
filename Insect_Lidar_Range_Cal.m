%% Insect_Lidar_Run_Experiment | Martin Tauc | 2016_02_18

 location='Range_cal';
%%
% This function runs the entire lidar experiment. Once the Setup.m file has
% been modified along with the paramaters above to what the user needs, and
% all equipment is hooked up,this script will run autonomously.
Insect_Lidar_GAGE_CS14200_connect;  

pause_time=0.12;
date_dir=fullfile('E:\Data',datestr(now,'yyyy-mm-dd'));
% define the time directory
% location='Unit21-';
time_dir=[date_dir,'\',location,datestr(now,'HHMMSS')];

% create a directory if it does not yet exist
if exist(date_dir,'dir') ~= 7
    mkdir(date_dir);
end
% create the time directory to hold all the run files
mkdir(time_dir);
% preallocate raw data array and time stamp vector

tsdata=zeros(1,(1024*10));
full_data.data = zeros(200,(1024*10));

panloc = 0;
tiltloc = 0;

rangev = 0;
while rangev ~= 9999
    rangev = input('enter range in meters ');
        Insect_Lidar_GageContinuousRecord;    
        temp_thing = sprintf('range_%05.2f',rangev);
        temp_thing(temp_thing=='.')='_';
        
    save(fullfile(time_dir,temp_thing),'full_data');
end
% clear and release the mount and ADC card and waitbar
ret = CsMl_FreeSystem(handle);
