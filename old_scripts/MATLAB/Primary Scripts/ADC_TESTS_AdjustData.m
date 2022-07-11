function []=ADC_TESTS_AdjustData(di)
%% Martin Tauc | 2016_02_17
%if arguement is empty, prompt user for date
if nargin==0
    % dates are located in C:\Users\user\Documents\Research\Insect
    % Lidar\Field Tests\Stored Data\ and have the form YYYYMMDD
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end


%set directory using date from above
fulldir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\Temp Gage Storage\';
%find all file names from directory
files = dir(fullfile(fulldir,['Insect_Lidar_',date,'*']));
%pull all files from directory
pullamt = length(files);
for n=1:pullamt
    fulldirfile = strcat(fulldir,files(n).name);
    load(fulldirfile,'data');
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
    %input values with padding (zeros on either end)
    [padded_depth(1,m),padded_pulse(1,m)]=size(data(m).data.data);
    adjusted_data(m).search_run=zeros(padded_depth(1,m),padded_pulse(1,m)+padding);
    adjusted_data(m).run=zeros(padded_depth(1,m),padded_pulse(1,m));
end
%determine offset
offset=zeros(length(data),max(padded_pulse));

% %% create lowpass butterworth filter for each data set
% % find the normalized nyquest
% for m=1:length(data)
%     time_diff(m)=mean(diff(cell2mat(data(m).data.datainfo(10,4:length(data(m).data.datainfo))))).*10^-6; % microseconds
%     pulse_rep_rate(m)=1./time_diff(m);
%     nyquest(m)=pulse_rep_rate(m)./2;
% 
% ripple=1;
% attenuation=40;
% % normalzed passband (wp) and stopband (ws)
% wp=[150 250]/nyquest(m);
% ws=[100 300]/nyquest(m);
% [n,wn]=buttord(wp,ws,ripple,attenuation);
% [b{m},a{m}]=butter(n,wn,'bandpass');
% end
%%
% preallocate h
h=zeros(length(data),max(padded_pulse));
clear m
for m=1:length(data)
    % find size of data matrix
    [xdat,ydat]=size(data(m).data.data);
    for n=1:ydat
        % offset determines actual start of data acquisition
        offset(m,n) = cell2mat(data(m).data.datainfo(1,3+n));
        depth(m)=cell2mat(data(m).data.datainfo(2,3+n));
        % build data with offset included
        h = data(m).data.data(abs(offset(m,n))+1:depth(m),n);
        % create padded vector
        adjusted_data(m).search_run(1:length(h),n+(padding/2))=h;
        % create raw data vector with offset included
        adjusted_data(m).raw_run(1:length(h),n)=h;
        % include name of run
        adjusted_data(m).name=data(m).name;
        % create vector with data information
        adjusted_data(m).data_info=data(m).data.datainfo;
    end
    
    clear a_d
    % find average value for each range bin
    minimum_data=min(abs(adjusted_data(m).raw_run),[],2);
    % preallocate
    pedestal_deleted_data=zeros(size(adjusted_data(m).raw_run));
    normalized_data=zeros(size(adjusted_data(m).raw_run));
    for o=1:length(minimum_data)
        x=1:length(adjusted_data(m).raw_run);
        
        pedestal_deleted_data(o,:)=(abs(adjusted_data(m).raw_run(o,:))-minimum_data(o));
        normalized_data(o,:)=(pedestal_deleted_data(o,:))./(max(pedestal_deleted_data(o,:)));
    end
    adjusted_data(m).run=normalized_data;
end





if exist(fullfile(fulldir,'AdjustedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
else
    mkdir(fullfile(fulldir),'AdjustedData');
    save(fullfile(strcat(fulldir,'\AdjustedData'),'adjusted_data'),'adjusted_data')
end
end

