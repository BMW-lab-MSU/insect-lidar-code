%% Insect_Lidar_Adjusted_Data | Martin Tauc | 2017-02-01
% First script of the processing routines. This will take the raw data and
% minimally process so that it can be interepreted.

function []=Insect_Lidar_Adjust_Data_volts(data_dir, date, scan_folder_prefix)
%% Folders in a date folder
% define directory based on input date
%stored_data = '/Users/elizabethrehbein/Documents_HD/Insect Lidar/data';
date_dir=fullfile(data_dir, date);

% scan folders: create vector of all folders with desired title [NOTE THAT TITLE IS
% DEFINED IN 'Insect_Lidar_Run_Experiment.m']
% runs=dir([date_dir,'\AMK_Ranch*']);
runs=dir(fullfile(date_dir, [scan_folder_prefix '*'])); %modify depending on data to adjust
count = 1;
for n = 1:size(runs,1)
    if exist(fullfile(date_dir,runs(n).name,'adjusted_data_junecal_volts.mat'),'file')
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
    clear vecs adjusted_data_junecal
    %scan folder: create vector of all files within folder
    vecs=dir(fullfile(date_dir,runs(rn).name,'*.mat'));
    %THIS BELOW SHOULD BE UNCOMMENTED FOR NEW PROCESSING
    vecs=vecs(~ismember({vecs.name},{'.','..','processed_data_junecal.mat','adjusted_data_decembercal.mat','adjusted_data_junecal.mat','stats_junecal.mat'}));
    % preallocate adjusted_data structure
    adjusted_data_junecal(size(vecs,1))=struct('tilt',[],'pan',[],'data',[],'time',[],'range',[],'filename',[],'normalized_data',[]);
    disp(['currently on file ', runs(rn).name])
    
    
    %full_data.data = zeros(200,1024);
    
    % parallel for loop
    parfor(vn = 1:size(vecs,1), min(size(vecs,1), feature('NumCores')))
    %for vn = 1:size(vecs,1)
        % load each run within scan folder
        rd = load(fullfile(date_dir,runs(rn).name,vecs(vn).name));
        disp(vecs(vn).name)
        %full_data = temp_data_fix(rd); %Call this function for data collected before 2018-06-28
        
        % line up data, time, and range
        [adjusteddata_junecal,tcdata,range]=Insect_Lidar_fix_cell_struct(rd.full_data.data,rd.full_data.info.Start,rd.full_data.info.TimeStamp);
        
        %[adjusteddata,tcdata,range]=Insect_Lidar_fix_cell_struct(full_data.data,full_data.info.Start,full_data.info.TimeStamp);
        
        % store important variables in structure
        adjusted_data_junecal(vn).tilt = rd.full_data.info.Tilt(1);% full_data.info.Tilt;
        adjusted_data_junecal(vn).pan = rd.full_data.info.Pan(1); %full_data.info.Pan;
        adjusted_data_junecal(vn).raw_data = adjusteddata_junecal;
        adjusted_data_junecal(vn).data = convertAdcCountsToVolts(adjusteddata_junecal, rd.full_data.info);
        adjusted_data_junecal(vn).time = tcdata;
        adjusted_data_junecal(vn).range = range;
        adjusted_data_junecal(vn).filename = [runs(rn).name,'/',vecs(vn).name];
        
    end
  
    
    save(fullfile(date_dir,runs(rn).name,['adjusted_data_junecal_volts','.mat']),'adjusted_data_junecal','-v7.3');
    
end
end

