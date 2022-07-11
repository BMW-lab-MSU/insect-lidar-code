%% Insect_Lidar_Combine_Vectors | Martin Tauc | 2017-02-01

function [vector_data]=Insect_Lidar_Combine_Vectors(date)
% base directory
stored_data='/Volumes/Insect Lidar/Data_2020/';
%%
% ATTENTION ATTENTION ATTENTION:
% ATTENTION: tilt_vec and pan_vec may need to be adjusted based on settings
% set in 'Insect_Lidar_Run_Experiment.m'
% create appropriate vectors for tilt and pan locations
tilt_vec=[];
for n=20:.5:22
    tilt_vec=[tilt_vec repmat(n,[1,8])];
end
pan_vec=[];
vv=-9:.5:-7;
for n=1:size(tilt_vec,2)/8/2; 
    pan_vec=[pan_vec vv flip(vv)];
end
% date directory
date_dir=[stored_data, date];
% create processed_data folder if it does not yet exist
if exist(fullfile(date_dir,'processed_data_red'),'dir')==0
    mkdir(fullfile(date_dir,'processed_data_red'))
end
%% 
% scans within date directory
runs=dir([date_dir,'/RedLight*']); % use \ for non-Mac
rn_vec=1:size(runs,1);
% clump data based on pan and tilt location
for pn=1:size(tilt_vec,2)
    clear vector_data nf
    int=1;
    % pan and tilt values were stored in filenames, extract here
    nf = ['T',sprintf('%3.2f',...
        tilt_vec(pn)),...
        'P',sprintf('%3.2f',...
        pan_vec(pn))];
    % filenames used _ instead of .
    nf(nf=='.')='_'; 
    nf(nf=='-')='_' %gets rid of negative signs that ruin field name assignment
    % save it in cell
    name_file{pn}=nf;
    % loop through each run to find match with tilt_vec and pan_vec
    for rn = rn_vec
        clear adjusted_data_decembercal pm
        % load the adjusted data
        load(fullfile(date_dir,runs(rn).name,'adjusted_data_decembercal.mat'))
        % find matches within 0.245 degress
        pm=find(abs([adjusted_data_decembercal.tilt]-tilt_vec(pn))<0.245 & abs([adjusted_data_decembercal.pan]-pan_vec(pn))<0.245);
        if exist('pm','var')
            % save the vector as the pan and tilt location
            for spm=1:size(pm,2)
                vector_data.(name_file{pn})(int)=adjusted_data_decembercal(pm(spm));
                int=int+1;
            end
        end
        fprintf('%03.0f - %03.0f\n',pn,rn)
    end
    if exist('vector_data','var')
        % save in 'processed_data' folder
        save(fullfile(date_dir,'processed_data_red',sprintf('%03.0f-%s.mat',pn,name_file{pn})),'-struct','vector_data');
    end
end
