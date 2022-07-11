%% Insect_Lidar_QPT_int2hex_Martin Tauc | 2016-03-04
% QPT_integer2hex
% The QPT 130 mount requires that integer values get passed as two's compliment
% little endian. This program takes an integer between -32768 and 32767 and
% converts it into a 2 byte integer value

%%
function unsigned8=Insect_Lidar_QPT_int2hex(int_val)

% set value to unsigned 8 integer
unsigned8=typecast(int16(int_val),'uint8');
% turn it into a hex value seperated by commas
hex_val=[num2str(unsigned8(1)),',',num2str(unsigned8(2)),','];