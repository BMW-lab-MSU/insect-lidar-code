%% LRC
% Martin Tauc | 2016_02_18
% This program adds the Logarithmic Redundancy Check (LRC)
% and the start command (02) and the end command (03)
% user must imput everything inbetween in decimal form.
function [output]=LRC(input)

com=input;

[x,y]=size(com);
com_int=uint8(com);

lrc=com_int(1);

for m=2:y
    lrc=bitxor(lrc,com_int(m));
end

output=[uint8(02), com_int, lrc, uint8(03)];