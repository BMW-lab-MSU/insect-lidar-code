%% Martin Tauc | 2016-03-04
% QPT_integer2hex
% The QPT 130 mount requires that integer values get passed as two's compliment
% little endian. This program takes an integer between -32768 and 32767 and
% converts it into a 2 byte integer value

%%
function unsigned8=QPT_int2hex(int_val)

unsigned8=typecast(int16(int_val),'uint8');
hex_val=[num2str(unsigned8(1)),',',num2str(unsigned8(2)),','];