%% Insect_Lidar_Insert_ESC_Char Martin Tauc | 2016-03-07
% This function enters esc characters so that a byte doesn't place a
% command character in the wrong place.

function esc_corrected_data=Insect_Lidar_Insert_ESC_Char(code)
% set control characters
control_char=uint8([02, 03, 06, 15, 27]);

% save the index where a control character was found
for h=1:length(control_char)
    if isempty(find(code==control_char(h)))~=1
        index{h}=find(code==control_char(h));
    end
end
% put the index vector in order
ind_t=sort(cell2mat(index));
% set counters
k=2;
ind(1)=0;
% create vector of all indexes starting with 0
ind(k:length(ind_t)+(k-1))=ind_t;
% if the final value is a control character, set l=1,else l=0;
if ind_t(end)~=length(code)
    ind(length(ind_t)+k)=length(code);
    l=0;
else
    l=1;
end
% insert the escape character
for h = 1:length(ind)-1
    % if there are no more control characters, print the rest of the
    % vector, otherwise add in the esc character
    if h==length(ind)-1 && l==0
        cn{h}=[code(ind(h)+1:ind(h+1)-1) code(ind(h+1))];
    else
        % esc character is 27 and it is followed by the value + 128
        cn{h}=[code(ind(h)+1:ind(h+1)-1) uint8(hex2dec('1B')) code(ind(h+1))+128];
    end
end
% convert from cell to integers
esc_corrected_data=cell2mat(cn);


