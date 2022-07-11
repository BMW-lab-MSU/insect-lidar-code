%% Insect_Lidar_Adjusted_Data | Martin Tauc | 2017-02-01
% First script of the processing routines. This will take the raw data and
% minimally process so that it can be interepreted.

function []=Insect_Lidar_Adjust_Data(date)
%% Folders in a date folder
% define directory based on input date
computer = getenv('computername');
switch computer
    case 'ORSL-TESLA'
        stored_data = 'H:\Data\';
    case 'ORSL-FOURIER'
        stored_data = 'D:\Data\';
    case 'FISH-LIDAR'
        stored_data = 'E:\Data\';
    case 'ORSL-BOHR'
                stored_data = 'E:\Data\';
        %stored_data = 'D:\insect_lidar\';
    case 'LAPTOP-T6CGQ5B3'
        stored_data = 'D:\Data\';
end

date_dir=fullfile(stored_data, date);

% scan folders: create vector of all folders with desired title [NOTE THAT TITLE IS
% DEFINED IN 'Insect_Lidar_Run_Experiment.m']
% runs=dir([date_dir,'\AMK_Ranch*']);
runs=dir(fullfile(date_dir,'\AMK_*'));
count = 1;
for n = 1:size(runs,1)
    if exist(fullfile(date_dir,runs(n).name,'adjusted_data.mat'),'file')
        remove(count) = n;
        count=count+1;
    end
end
if exist('remove','var')
runs(remove) = [];
end

rn_vec=1:size(runs,1);
%% Files in a run folder
for rn = rn_vec
    clear vecs adjusted_data
    %scan folder: create vector of all files within folder
    vecs=dir(fullfile(date_dir,runs(rn).name,'0*.mat'));
    vecs=vecs(~ismember({vecs.name},['.','..','processed_data.mat','adjusted_data.mat','stats.mat']));
    % preallocate adjusted_data structure
    adjusted_data(size(vecs,1))=struct('tilt',[],'pan',[],'data',[],'time',[],'range',[],'filename',[]);
    disp(['currently on file ', runs(rn).name])
    
    
    %full_data.data = zeros(200,1024);
    
    % parallel for loop
    parfor vn = 1:size(vecs,1)
        % load each run within scan folder
        rd = load(fullfile(date_dir,runs(rn).name,vecs(vn).name));
        disp(vecs(vn).name)
        %full_data = temp_data_fix(rd); %Call this function for data
        %collected before 2018-06-28
        
        % line up data, time, and range
        [adjusteddata,tcdata,range]=Insect_Lidar_fix_cell_struct(rd.full_data.data,rd.full_data.info.Start,rd.full_data.info.TimeStamp);
        
        %[adjusteddata,tcdata,range]=Insect_Lidar_fix_cell_struct(full_data.data,full_data.info.Start,full_data.info.TimeStamp);
        
        % store important variables in structure
        adjusted_data(vn).tilt = rd.full_data.info.Tilt(1);% full_data.info.Tilt;
        adjusted_data(vn).pan = rd.full_data.info.Pan(1); %full_data.info.Pan;
        adjusted_data(vn).data = adjusteddata;
        adjusted_data(vn).time = tcdata;
        adjusted_data(vn).range = range;
        adjusted_data(vn).filename = [runs(rn).name,'\',vecs(vn).name];
        
    end
    med_val = median(median([adjusted_data.data]));
    for vn = 1:size(adjusted_data,2)
        adjusted_data(vn).normalized_data = -1*(adjusted_data(vn).data-med_val);%-med_val;
    end
    
    save(fullfile(date_dir,runs(rn).name,['adjusted_data','.mat']),'adjusted_data','-v7.3');
    
end
end

