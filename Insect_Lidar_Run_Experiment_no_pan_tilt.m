%% Insect_Lidar_Run_Experiment | Martin Tauc | 2016_02_18

clear
% close all


%% user must define:
t_start = tic;
nImages = 256;

% tilt (in degrees)
starting_tilt=0;
final_tilt=0;
d_tilt=.5; %default value = 0;5
% pan (in degrees)
starting_pan=-1;
final_pan=-1;
d_pan=.5;%default value = 0;5
% define string for saving files (ex., 'AMK_Ranch-')
 location='MSU-horticulture-farm-bees-';
%%
% This function runs the entire lidar experiment. Once the Setup.m file has
% been modified along with the paramaters above to what the user needs, and
% all equipment is hooked up,this script will run autonomously.
 addpath('E:\scripts\mount\QPT130\');


[QPT130, jog]=Insect_Lidar_QPT130_connect;
% fclose(ans)
% delete(ans)
% load('D:\scripts\mount\QPT130\InsectLidarVariables');
%      fopen(QPT130)
Insect_Lidar_GAGE_CS14200_connect;  

pause_time=0.12;
% setup wait bar
wb=waitbar(0,'please wait...');

    
% define the date directory
date_dir=fullfile('E:\Data_2022',datestr(now,'yyyy-mm-dd'));
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

tsdata=zeros(1,(1024*1));
full_data.data = zeros(200,(1024*1));

%% begin scan
% define variable for waitbar
tl=starting_tilt*100; %100*degrees
% define temproary variable and tilt start
tld=tl;
% define pan start
start_pan=starting_pan*100; % 100*degrees
% define pan end
end_pan=final_pan*100;   % 100*degrees
% create pan vector
pan_s_e=[start_pan end_pan];
% define change in pan
delta_pan=d_pan*100; % 100*degrees
% define change in tilt
delta_tilt=d_tilt*100; % 100*degrees
% set tilt end
tilt_final=final_tilt*100; % 100*degrees
% define number of runs for waitbar
nor=((-start_pan+end_pan)./delta_pan)*((-tld+tilt_final+1)./delta_tilt);
% set counter variables
q=0;
n=0;
nn=1;
% run while tilt location is less than the final tilt

%% move to absolute coordinate
% increase n counter
n=n+1;
% begin timer
tic;
% set counter variable
oc=0;
% set check status to trigger first loop iteration
check=false;
% set to trigger first loop eteration
out(1)=uint8(15);
% check for the redudancy check and that the the transmission is
% acknowledged (indicated by a '06')
while check~=true || out(1)~=uint8(06)
    % send the absolute coordinates ('33') to the mount in two
    % bytes and do a lrc
    fwrite(QPT130,char(Insect_Lidar_LRC_out([uint8(hex2dec('33')),Insect_Lidar_QPT_int2hex(pan_s_e(nn)),Insect_Lidar_QPT_int2hex(tl)])));
    % pause is required by the mount
    pause(pause_time)
    % if the command was recieved, the mount sends back the
    % original command for check
    if QPT130.BytesAvailable > 0
        % confirm proper bytes were sent
        out=fread(QPT130,QPT130.BytesAvailable);
        % determine if lrc matched
        check=Insect_Lidar_LRC_in(out');
        % increase count
        oc=oc+1;
        % store output at cell
        raw_output{n,oc}=out';
        % if lrc was true
        if check==true
            % save output as cell
            output{n,oc}=Insect_Lidar_Remove_ESC_Char(out');
            pause(pause_time)
        end
    end
end
% set to trigger
check=false;
out(1)=uint8(15);
% send "jog" command
while check~=true || out(1)~=uint8(06)
    fwrite(QPT130,jog);
    pause(pause_time)
    if QPT130.BytesAvailable > 0
        out=fread(QPT130,QPT130.BytesAvailable);
        check=Insect_Lidar_LRC_in(out');
        oc=oc+1;
        raw_output{n,oc}=out';
        if check == true
            output{n,oc}=Insect_Lidar_Remove_ESC_Char(out');
            pause(pause_time)
        end
    end
end
% set to trigger
check=false;
out(1)=uint8(15);
k=1;
% wait for mount to reach destination
while isequal(output{n,k},output{n,k+1})==0 || check~=true || out(1)~=uint8(06)
    fwrite(QPT130,jog);
    pause(pause_time)
    if QPT130.BytesAvailable > 0
        out=fread(QPT130,QPT130.BytesAvailable);
        check=Insect_Lidar_LRC_in(out');
        raw_output{n,k+2}=out';
        if check==true
            k=k+1;
            output{n,k+1}=Insect_Lidar_Remove_ESC_Char(out');
            pause(pause_time)
        end
    end
end
% increase count
oc=k+1;
% store current location
cur_loc=output{n,oc};
% store current location as hex files
[pld,pli]=Insect_Lidar_QPT_hex2int(cur_loc(3),cur_loc(4));
[tld,tli]=Insect_Lidar_QPT_hex2int(cur_loc(5),cur_loc(6));
panloc=pld/100;
tiltloc=tld/100;
% display current location of mount in degrees
disp(['Pan location is ', sprintf('%4.2f',panloc), ' degrees'])
disp(['Tilt location is ', sprintf('%4.2f',tiltloc),' degrees'])
fdm=0;
%     disp(q)

%     disp(q)

for imageNum = 1:nImages
    q=q+1;
    % record data using the modified SDK
    Insect_Lidar_GageContinuousRecord;
    % save timer
    tt=toc;
    % used to move pan right or left depending on orientation to save
    % time
    %     disp(nn)
    %     nn=nn+(-1)^(n+1);


    %%
    save(fullfile(time_dir,[sprintf('%05.0f',q),'_','P',sprintf('%04.0f',pli),'T',sprintf('%04.0f',tli)]),'full_data');

end

t_stop = toc

%% clear and release the mount and ADC card and waitbar
ret = CsMl_FreeSystem(handle);
fclose(QPT130);
delete(QPT130);
delete(wb);