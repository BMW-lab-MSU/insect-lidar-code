%sample
%% Connect to the mount
[QPT130,jog]=Insect_Lidar_QPT130_connect;
%% Send mount to absolute coordinates (in degrees)
% go to 10.20 in pan and 3.43 in tilt
[pan_loc,tilt_loc]=QPT_mount_control(10,0,QPT130,jog);
tod=sprintf('pan: %2.2f%c | tilt: %2.2f%c',pan_loc,char(176),tilt_loc,char(176));
disp(tod)
% %go to -2.02 in pan and 15 in tilt)
% [pan_loc,tilt_loc]=QPT_mount_control(-2.02,15,QPT130,jog);
% tod=sprintf('pan: %2.2f%c | tilt: %2.2f%c',pan_loc,char(176),tilt_loc,char(176));
% disp(tod)
%% release mount and exit
fclose(QPT130);
delete(QPT130);



% 
% %sample
% %% Connect to the mount
% [QPT130,jog]=Insect_Lidar_QPT130_connect;
% %right after intialization set speed limits to max of 255
% %% Send mount to absolute coordinates (in degrees)
% % go to 10.20 in pan and 3.43 in tilt
% panvec=[0 1 3 8 20 33];
% tiltvec=[-90 -88 -86 -84 -82 -80];
% for n=1:length(panvec)
%     [pan_loc,tilt_loc]=QPT_mount_control(panvec(n),tiltvec(n),QPT130,jog);
%     tod=sprintf('pan: %2.2f%c | tilt: %2.2f%c',pan_loc,char(176),tilt_loc,char(176));
%     disp(tod)
% end
% % %go to -2.02 in pan and 15 in tilt)
% % [pan_loc,tilt_loc]=QPT_mount_control(-2.02,15,QPT130,jog);
% % tod=sprintf('pan: %2.2f%c | tilt: %2.2f%c',pan_loc,char(176),tilt_loc,char(176));
% % disp(tod)
% %% release mount and exit
% fclose(QPT130);
% delete(QPT130);
% 
% 
