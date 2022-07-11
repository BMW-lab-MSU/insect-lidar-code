%% LRC_out | Martin Tauc | 2016_02_18
% This program adds the Logarithmic Redundancy Check (LRC)
% and the start command (02) and the end command (03)
% user must imput everything inbetween in hex form.
function [output]=LRC_out(input)
[x,y]=size(input);
lrc=input(1);

for m=2:y
    lrc=bitxor(lrc,input(m));
end

code=[input,lrc];

control_char=uint8([02, 03, 06, 15]);
k=0;
for n=1:length(control_char);
    k=k+any(code==control_char(n));
end

if k~=0
    code_N=Insert_ESC_Char(code);
else
    code_N=code;
end

output=[uint8(02), code_N, uint8(03)];