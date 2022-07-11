%% LRC
% Martin Tauc | 2016_03_07
% This program looks at the incoming bytes from the mount and checks the
% Logarithmic Redundancy Check (LRC).
function [check]=LRC_in(in_from_QPT)
            
input=Remove_ESC_Char(in_from_QPT);

lrc_final=uint8(input(end-1));
com_int=uint8(input(2:end-2));



[x,y]=size(com_int);
lrc=com_int(1);

for m=2:y
    lrc=bitxor(lrc,com_int(m));
end

if lrc_final==lrc
    check=true;
else
    check=false;
end