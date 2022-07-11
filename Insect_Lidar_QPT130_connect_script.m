%% QPT130_connect | Martin Tauc | 2016_01_28
% This script is used to establish communication with the MoogS3 QPT-130
% pan/tilt mount.
%%
clear
% define the device through the serial port
QPT130=serial('com1');
% open communication and check some properties
fopen(QPT130);
get(QPT130,{'BaudRate','DataBits','Parity','StopBits','Terminator','Status'});

% import starting protocol and convert from hex to dec
[Tx_dec,Tx_str]=Insect_Lidar_add_H;

% send starting protocol to mount
for n=1:size(Tx_str,2)
    fwrite(QPT130,char(Tx_dec{n}));
    pause(0.1);
end
% set "jog" command
jog=char(Tx_dec{1});
% send "jog" command to mount
fwrite(QPT130,jog);
% pause is required by mount
pause(0.25);
% the mount has recieved and proccessed the command
if QPT130.BytesAvailable > 0
    out=fread(QPT130,QPT130.BytesAvailable);
end
