%% Insect_Lidar_Adjusted_Data | Martin Tauc | 2017-02-01
% First script of the processing routines. This will take the raw data and
% minimally process so that it can be interepreted. 

function []=Insect_Lidar_Adjust_Data(date)
%% Folders in a date folder
% define directory based on input date
stored_data= 'D:\Data\';
whos stored_data
date_dir=fullfile(stored_data, date);
whos date_dir
% scan folders: create vector of all folders with desired title [NOTE THAT TITLE IS
% DEFINED IN 'Insect_Lidar_Run_Experiment.m']
% runs=dir([date_dir,'\AMK_Ranch*']);
runs=dir(fullfile(date_dir,'\Unit21-*'));
whos runs
rn_vec=1:size(runs,1);
%% Files in a run folder
for rn = rn_vec
    clear vecs adjusted_data
    %scan folder: create vector of all files within folder
    vecs=dir(fullfile(date_dir,runs(rn).name,'0*.mat'));
    vecs=vecs(~ismember({vecs.name},{'.','..','processed_data.mat','adjusted_data.mat','stats.mat'}));
    % preallocate adjusted_data structure
    adjusted_data(size(vecs,1))=struct('tilt',[],'pan',[],'data',[],'time',[],'range',[],'filename',[]);
    % parallel for loop
    parfor vn = 1:size(vecs,1)
        % load each run within scan folder
        rd=load([date_dir,'\',runs(rn).name,'\',vecs(vn).name]);
        % line up data, time, and range
      %[adjusteddata,tcdata,range]=Insect_Lidar_fix_cell_struct();
  
      
%%%%%%------------------------from_fix_cell_struct---------------%%%%%%
   % remove the final 10 range bins (start address vary between 3 and 13)
adjusted_data=adjusted_data(1:end-10,:);
% number of points
nop=size(adjusted_data,2);
% convert from microseconds to seconds
tcdata=(tsdata-tsdata(1))./1e6;
% create a uniform time vector
dt=diff(tcdata);
tcdata_es=mean(dt)*(0:nop-1);
% sinc interpolate for a uniform time spacing
for n = 1:size(adjusted_data,1)
    adjusted_data(n,:) = interpsinc(tcdata,adjusted_data(n,:),mean(dt),1);
end
% remove the first 8 points (they correspond to negative range values)
adjusted_data=adjusted_data(8:end,:);
range=rangefind(8:size(adjusted_data,1)+7);
%%%%%%------------------------------------------------------------------%%%%%%%%%%
       



    % store important variables in structure
        adjusted_data(vn).tilt=rd.tiltloc;
        adjusted_data(vn).pan=rd.panloc;
        adjusted_data(vn).data=adjusteddata;
        adjusted_data(vn).time=tcdata;
        adjusted_data(vn).range=range;
        adjusted_data(vn).filename=[runs(rn).name,'\',vecs(vn).name];
    end
    save(fullfile(date_dir,runs(rn).name,['adjusted_data','.mat']),'adjusted_data','-v7.3');
end
end