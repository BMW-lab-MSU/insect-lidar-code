%% Insect_Lidar_Combine_Vectors | Martin Tauc | 2017-02-01

function [vector_data]=Insect_Lidar_Combine_Vectors(date)
% base directory
stored_data='D:\insect_lidar\stored_data\';
%%
% ATTENTION ATTENTION ATTENTION:
% ATTENTION: tilt_vec and pan_vec may need to be adjusted based on settings
% set in 'Insect_Lidar_Run_Experiment.m'
% create appropriate vectors for tilt and pan locations
tilt_vec=[];for n=1.5:.5:15;tilt_vec=[tilt_vec repmat(n,[1,8])];end
pan_vec=[];vv=39:.5:42.5;for n=1:size(tilt_vec,2)/8/2; pan_vec=[pan_vec vv flip(vv)];end
% date directory
date_dir=[stored_data, date];
% create processed_data folder if it does not yet exist
if exist(fullfile(date_dir,'processed_data'),'dir')==0
    mkdir(fullfile(date_dir,'processed_data'))
end
%% 
% scans within date directory
runs=dir([date_dir,'\AMK_Ranch*']);
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
    % save it in cell
    name_file{pn}=nf;
    % loop through each run to find match with tilt_vec and pan_vec
    for rn = rn_vec
        clear adjusted_data pm
        % load the adjusted data
        load(fullfile(date_dir,runs(rn).name,'adjusted_data.mat'))
        % find matches within 0.245 degress
        pm=find(abs([adjusted_data.tilt]-tilt_vec(pn))<0.245 & abs([adjusted_data.pan]-pan_vec(pn))<0.245);
        if exist('pm','var')
            % save the vector as the pan and tilt location
            for spm=1:size(pm,2)
                vector_data.(name_file{pn})(int)=adjusted_data(pm(spm));
                int=int+1;
            end
        end
        fprintf('%03.0f - %03.0f\n',pn,rn)
    end
    if exist('vector_data','var')
        % save in 'processed_data' folder
        save(fullfile(date_dir,'processed_data',sprintf('%03.0f-%s.mat',pn,name_file{pn})),'-struct','vector_data');
    end
end