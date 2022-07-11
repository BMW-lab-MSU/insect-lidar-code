%% Remove_ESC_Char Martin Tauc | 2016-03-07
% This function removes esc characters so bytes coming from the pan tilt
% mount are readable

function code_out=Remove_ESC_Char(code)

control_char=uint8(27);
index=find(code==control_char);

n=1;
while n<=length(index)
    index_new{n}=index(n);
    code(index(n)+1)=code(index(n)+1)-128;
    if n~=length(index)
        if index(n+1)==index(n)+1;
            n=n+2;
        else
            n=n+1;
        end
    else
        n=n+1;
    end
end

if exist('index_new') == 1
index_n=cell2mat(index_new);
for n=length(index_n):-1:1
    code(index_n(n))=[];
end
end
code_out=code;


%
%
% ind_t=sort(cell2mat(index));
% k=2;
% ind(1)=0;
% ind(k:length(ind_t)+(k-1))=ind_t;
% if ind_t(end)~=length(code)
%     ind(length(ind_t)+k)=length(code);
%     l=0;
% end
%
% for n = 1:length(ind)-1
%     if n==length(ind)-1 && l==0;
%         cn{n}=[code(ind(n)+1:ind(n+1)-1) code(ind(n+1))];
%     else
%         cn{n}=[code(ind(n)+1:ind(n+1)-1) uint8(hex2dec('1B')) code(ind(n+1))+128];
% %         cn{n}=[code(ind(n)+1:ind(n+1)-1) uint8(hex2dec('1B')) code(ind(n+1))];
%     end
% end
% esc_corrected_data=cell2mat(cn);
%
%
