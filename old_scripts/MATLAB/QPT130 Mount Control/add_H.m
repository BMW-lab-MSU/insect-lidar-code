function [Tx_dec, Tx_str]=add_H

[Rx,Tx]=import_starting_protocol;

for n=1:size(Tx,1)
    in_hex=Tx{n};
    sp=strsplit(in_hex);
    in_dec=hex2dec(sp);
    Tx_dec{n}=in_dec';
    clear in_hex
    clear sp
    clear in_dec
end
for n=1:size(Tx_dec,2)
    Tx_str{n}=sprintf('%1.0f ',Tx_dec{n});
end
end
