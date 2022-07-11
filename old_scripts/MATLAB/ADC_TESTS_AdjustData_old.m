function []=ADC_TESTS_AdjustData(di)
%%
if nargin==0
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end

fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date);
files = dir(fullfile(fulldir,'*.mat'));
pullamt = length(files);

for n=1:pullamt
    fulldirfile = strcat(fulldir,'\',files(n).name);
    data(n).data = load(fulldirfile);
    nameoffile = strsplit(files(n).name,'.');
    data(n).name = nameoffile(1);
end
%%
%depth=200;

depth=zeros(length(data),1);
padded_pulse=zeros(1,length(data));
padded_depth=zeros(1,length(data));
padding=200;
clear m
adjusted_data=struct('run',num2cell(zeros(length(data),1)),'name',num2cell(zeros(length(data),1)),'data_info',num2cell(zeros(length(data),1)),'search_run',num2cell(zeros(length(data),1)));
for m=1:length(data)
    [padded_depth(1,m),padded_pulse(1,m)]=size(data(m).data.data);
    adjusted_data(m).search_run=zeros(padded_depth(1,m),padded_pulse(1,m)+padding);
    adjusted_data(m).run=zeros(padded_depth(1,m),padded_pulse(1,m));
end
offset=zeros(length(data),max(padded_pulse));

h=zeros(length(data),max(padded_pulse));
clear m
for m=1:length(data)
    [xdat,ydat]=size(data(m).data.data);
    for n=1:ydat
        offset(m,n) = cell2mat(data(m).data.datainfo(1,3+n));
        depth(m)=cell2mat(data(m).data.datainfo(2,3+n));
        h = data(m).data.data(abs(offset(m,n))+1:depth(m),n);
        adjusted_data(m).search_run(1:length(h),n+(padding/2))=h;
        adjusted_data(m).run(1:length(h),n)=h;
        adjusted_data(m).name=data(m).name;
        adjusted_data(m).data_info=data(m).data.datainfo;
    end
end


if exist(fullfile(fulldir,'AdjustedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
else
    mkdir(fullfile(fulldir),'AdjustedData');
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
end
end

