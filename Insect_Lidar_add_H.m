%% Insect_Lidar_add_H | Martin Tauc | 2017-01-30
% this script converts the hexadecimal string into a decimal string

function [Tx_dec, Tx_str]=Insect_Lidar_add_H
% shake hands with mount. The sequence was borrowed from the accompanying
% software
[Rx,Tx]=Insect_Lidar_import_starting_protocol;

%% convert from a hex string to decimal string
for n=1:size(Tx,1)
    in_hex=Tx{n};
    % split string into row vector
    sp=strsplit(in_hex);
    % convert from hex to dec
    in_dec=hex2dec(sp);
    % convert dec to cell and row to column vector
    Tx_dec{n}=in_dec';
    % clear
    clear in_hex
    clear sp
    clear in_dec
end

for n=1:size(Tx_dec,2)
    Tx_str{n}=sprintf('%1.0f ',Tx_dec{n});
end
end
