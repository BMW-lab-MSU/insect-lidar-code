function []=ADC_TESTS_AdjustData(di)
%%
%if arguement is empty, prompt user for date
if nargin==0
    % dates are located in C:\Users\user\Documents\Research\Insect
    % Lidar\Field Tests\Stored Data\ and have the form YYYY-MM-DD
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end


%set directory using date from above
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date);
%find all file names from directory
files = dir(fullfile(fulldir,'*.mat'));
%pull all files from directory
pullamt = length(files);
for n=1:pullamt
    fulldirfile = strcat(fulldir,'\',files(n).name);
    data(n).data = load(fulldirfile);
    nameoffile = strsplit(files(n).name,'.');
    data(n).name = nameoffile(1);
end
%%
%set depth parameter from data
depth=zeros(length(data),1);
%preallocae padded_pulse and padded_depth vector
padded_pulse=zeros(1,length(data));
padded_depth=zeros(1,length(data));
%set padding
padding=200;
clear m
%define structure
adjusted_data=struct('run',num2cell(zeros(length(data),1)),...
    'name',num2cell(zeros(length(data),1)),...
    'data_info',num2cell(zeros(length(data),1)),...
    'search_run',num2cell(zeros(length(data),1)),...
    'raw_run',num2cell(zeros(length(data),1)));
for m=1:length(data)
    %input values with padding (zerios on either end)
    [padded_depth(1,m),padded_pulse(1,m)]=size(data(m).data.data);
    adjusted_data(m).search_run=zeros(padded_depth(1,m),padded_pulse(1,m)+padding);
    adjusted_data(m).run=zeros(padded_depth(1,m),padded_pulse(1,m));
end
%determine offset
offset=zeros(length(data),max(padded_pulse));

%create lowpass butterworth filter


%%
ripple=1.5;
attenuation=20;
wp=400/(3e3);
ws=800/(3e3);
[n,wn]=buttord(wp,ws,ripple,attenuation);
[b,a]=butter(n,wn,'low');
%%
h=zeros(length(data),max(padded_pulse));
clear m
for m=1:length(data)
    [xdat,ydat]=size(data(m).data.data);
    for n=1:ydat
        offset(m,n) = cell2mat(data(m).data.datainfo(1,3+n));
        depth(m)=cell2mat(data(m).data.datainfo(2,3+n));
        h = data(m).data.data(abs(offset(m,n))+1:depth(m),n);
        adjusted_data(m).search_run(1:length(h),n+(padding/2))=h;
        adjusted_data(m).raw_run(1:length(h),n)=h;
        adjusted_data(m).name=data(m).name;
        adjusted_data(m).data_info=data(m).data.datainfo;
    end
    clear a_d
    a_d=mean(adjusted_data(m).raw_run,2);
    f_a_d=zeros(size(adjusted_data(m).raw_run));
    n_a_d=zeros(size(adjusted_data(m).raw_run));
    for o=1:length(a_d)
        x=1:length(adjusted_data(m).raw_run);
        
        f_a_d(o,:)=filter(b,a,(adjusted_data(m).raw_run(o,:)-a_d(o)));
        n_a_d(o,:)=(((f_a_d(o,:)/max(f_a_d(o,:)))).^2);
    end
    adjusted_data(m).run=n_a_d;
end





if exist(fullfile(fulldir,'AdjustedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
else
    mkdir(fullfile(fulldir),'AdjustedData');
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
end
end

