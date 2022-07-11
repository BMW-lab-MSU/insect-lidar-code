%% Insect_Lidar_LRC_in | Martin Tauc | 2016_03_07
% This program looks at the incoming bytes from the mount and checks the
% Logarithmic Redundancy Check (LRC).
function [check]=Insect_Lidar_LRC_in(in_from_QPT)
% remove esc characters
input=Insect_Lidar_Remove_ESC_Char(in_from_QPT);
% identify the final character
lrc_final=uint8(input(end-1));
% identify middle commands
com_int=uint8(input(2:end-2));
% determine number of commands
[x,y]=size(com_int);
% set first lrc value
lrc=com_int(1);
% perform exclusive or on each byte
for m=2:y
    lrc=bitxor(lrc,com_int(m));
end
% output whether the lrc matched or not
if lrc_final==lrc
    check=true;
else
    check=false;
end