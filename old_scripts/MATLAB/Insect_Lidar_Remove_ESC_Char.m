%% Remove_ESC_Char Martin Tauc | 2016-03-07
% This function removes esc characters so bytes coming from the pan tilt
% mount are readable

function code_out=Insect_Lidar_Remove_ESC_Char(code)
% define esc character and locate it
control_char=uint8(27);
index=find(code==control_char);
% set counter
n=1;
while n<=length(index)
    % write into cell
    index_new{n}=index(n);
    % subtract 128 from value after esc character
    code(index(n)+1)=code(index(n)+1)-128;
    % if not the last value
    if n~=length(index)
        % if the next index value is also an esc, skip it
        if index(n+1)==index(n)+1
            % skip it
            n=n+2;
        else
            % otherwise don't
            n=n+1;
        end
    else
        % if this is the last value, move to end
        n=n+1;
    end
end

if exist('index_new') == 1
    % convert from cell to integer
    index_n=cell2mat(index_new);
    % remove the esc characters
    for n=length(index_n):-1:1
        code(index_n(n))=[];
    end
end
code_out=code;