%% QPT130_connect | Martin Tauc | 2016_01_28
% This script is used to establish communication with the MoogS3 QPT-130
% pan/tilt mount.
clear
% define the device through the serial port
QPT130=serial('com3');
% open communication and check some properties
fopen(QPT130);
get(QPT130,{'BaudRate','DataBits','Parity','StopBits','Terminator','Status'});

[Tx_dec,Tx_str]=add_H;

for n=1:size(Tx_str,2);
    fwrite(QPT130,char(Tx_dec{n}));
    pause(0.1);
end
% 
jog=char(Tx_dec{1});
% fwrite(QPT130,char(02,54,54,03));
% pause(0.25)
% if QPT130.BytesAvailable > 0
% out=fread(QPT130,QPT130.BytesAvailable);
% disp(out)
% end
fwrite(QPT130,jog);
pause(0.25);
if QPT130.BytesAvailable > 0;
out=fread(QPT130,QPT130.BytesAvailable);
% disp(out');
end
% 
% 
% for n=1:size(Tx_str,2)
%     fwrite(QPT130,char(Tx_dec{n}));
%     pause(0.25)
% end
% fwrite(QPT130,char(02,54,54,03))
% [out,count,message]=query(QPT130,char(Tx_dec{1}))
% fwrite(QPT130,char(02,54,54,03))
% en=0;
% while en<120;
%     fwrite(QPT130,char(Tx_dec{end-4}));
%     sprintf('%x',fgets(QPT130))
%     fwrite(QPT130,char(Tx_dec{1}))
%     sprintf('%x',fgets(QPT130))
%     en=en+1;
%     pause(.35)
% end
% disp(QPT130.BytesAvailable);
% fclose(QPT130)
% delete(QPT130)