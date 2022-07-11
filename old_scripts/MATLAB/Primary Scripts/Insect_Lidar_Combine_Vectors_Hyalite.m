function [vector_data]=Insect_Lidar_Combine_Vectors(date)
stored_data='/mnt/lustrefs/store/martin.tauc/MS_Research/Insect_Lidar/stored_data/';
% stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\';
tilt_vec=[];for n=1.5:.5:16;tilt_vec=[tilt_vec repmat(n,[1,8])];end
pan_vec=[];vv=39:.5:42.5;for n=1:size(tilt_vec,2)/8/2; pan_vec=[pan_vec vv flip(vv)];end

tilt_vec(end-7:end)=[];
pan_vec(end-7:end)=[];
% stored_data='C:\Martin_Tauc\Research\Stored_data\';
date_dir=[stored_data, date];
runs=dir([date_dir,'/AMK_Ranch*']);
rn_vec=1:size(runs,1);
% round_val=0.5;
% load(fullfile(date_dir,runs(1).name,'processed_data.mat'));
% tilt_vec=round([processed_data.tilt].*2)./2;
% pan_vec=round([processed_data.pan].*2)./2;


for pn=233:size(tilt_vec,2)
    clear vector_data nf
    int=1;
    nf = ['T',sprintf('%3.2f',...
        tilt_vec(pn)),...
        'P',sprintf('%3.2f',...
        pan_vec(pn))];
    nf(nf=='.')='_';
    name_file{pn}=nf;
    for rn = rn_vec
        clear adjusted_data pm
        load([date_dir,'/',runs(rn).name,'/adjusted_data.mat'])
        pm=find(abs([adjusted_data.tilt]-tilt_vec(pn))<0.245 & abs([adjusted_data.pan]-pan_vec(pn))<0.245);
        if exist('pm','var')
        for spm=1:size(pm,2)
            vector_data.(name_file{pn})(int)=adjusted_data(pm(spm));
            int=int+1;
        end
        end
        %             vector_data.(name_file{pn})(int)=processed_data(pm);
        
        
        
        disp(sprintf('%03.0f - %03.0f',pn,rn))
        
    end
    if exist('vector_data','var')
    save([date_dir,'/processed_data',sprintf('/%03.0f-%s.mat',pn,name_file{pn})],'-struct','vector_data');
    end
end
% vector_data=struct(nf,processed_data(pn));
