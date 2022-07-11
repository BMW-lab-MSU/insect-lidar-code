%% LRC_out | Martin Tauc | 2016_02_18
% This program adds the Logarithmic Redundancy Check (LRC)
% and the start command (02) and the end command (03)
% user must imput everything inbetween in hex form.
function [output]=Insect_Lidar_LRC_out(input)
% input a vector of numbers in hex
[x,y]=size(input);
% set the first value for the lrc
lrc=input(1);
% exclusive or with the other values for the lrc
for m=2:y
    lrc=bitxor(lrc,input(m));
end
% add lrc into original vector
code=[input,lrc];
% define the control characters including the escape character
control_char=uint8([02, 03, 06, 15, 27]);
% set counter
k=0;
% check for control characters and add in an escape character if found
for n=1:length(control_char)
    % check if any control characters exist in the vector
    k=k+any(code==control_char(n));
end
% if at least one control character was found, add in escape character
if k~=0
    code_N=Insect_Lidar_Insert_ESC_Char(code);
else
    code_N=code;
end

output=[uint8(02), code_N, uint8(03)];