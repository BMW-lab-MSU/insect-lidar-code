%% Insect_Lidar_QPT_hex2int | Martin Tauc | 2016-03-04
% The QPT 130 mount sends back 16-bit two's compliment little endian
% integers split between two bytes. First byte is LSB second is MSB.

%%
function [dub_val,int_val]=QPT_hex2int(hex_2,hex_1)
% convert hex values to integers
hex_2_ui=uint8(hex_2);
hex_1_ui=uint8(hex_1);
% convert from 8-bit to 16-bit
int_val=typecast([hex_2_ui,hex_1_ui],'int16');
dub_val=double(int_val);
end
