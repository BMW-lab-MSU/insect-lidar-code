%% Insert_ESC_Char Martin Tauc | 2016-03-07
% This function enters esc characters so that a byte doesn't place a
% command character in the wrong place.

function esc_corrected_data=Insert_ESC_Char(code)

control_char=uint8([02, 03, 06, 15, 27]);

for h=1:length(control_char)
    if isempty(find(code==control_char(h)))~=1
        index{h}=find(code==control_char(h));
    end
end

ind_t=sort(cell2mat(index));
k=2;
ind(1)=0;
ind(k:length(ind_t)+(k-1))=ind_t;
if ind_t(end)~=length(code)
    ind(length(ind_t)+k)=length(code);
    l=0;
else
    l=1;
end

for h = 1:length(ind)-1
    if h==length(ind)-1 && l==0;
        cn{h}=[code(ind(h)+1:ind(h+1)-1) code(ind(h+1))];
    else
        cn{h}=[code(ind(h)+1:ind(h+1)-1) uint8(hex2dec('1B')) code(ind(h+1))+128];
%         cn{n}=[code(ind(n)+1:ind(n+1)-1) uint8(hex2dec('1B')) code(ind(n+1))];
    end
end
esc_corrected_data=cell2mat(cn);


