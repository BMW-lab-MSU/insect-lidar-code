function []=Insect_Lidar_Adjust_Data_ForCluster(date)
%% Folders in a date folder
% parpool
stored_data='/mnt/lustrefs/store/martin.tauc/MS_Research/Insect_Lidar/stored_data/';
% stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\';
% stored_data='C:\Martin_Tauc\Research\Stored_data\';
store_dir=[stored_data, date];
disp(stored_data)
date_dir=['/local/',date];
disp(date_dir)
tic
copyfile(store_dir,date_dir)
tocsq
disp('file was copied.')

runs=dir([date_dir,'/AMK_Ranch*']);
rn_vec=1:size(runs,1);
disp(rn_vec);
%%% 
% rn_v
%% Files in a run folder
for rn = rn_vec
    clear vecs adjusted_data
    vecs=dir([date_dir,'/',runs(rn).name,'/0*']);
    disp(length(vecs))
    vecs=vecs(~ismember({vecs.name},{'.','..','processed_data.mat','adjusted_data.mat'}));
    adjusted_data(size(vecs,1))=struct('tilt',[],'pan',[],'data',[],'time',[],'range',[],'filename',[]);
    parfor vn = 1:size(vecs,1)
        rd=load([date_dir,'/',runs(rn).name,'/',vecs(vn).name]);
        [adjusteddata,tcdata,range]=fix_cell_struct(rd.full_data,rd.start_address,rd.tsdata);
        
        adjusted_data(vn).tilt=rd.tiltloc;
        adjusted_data(vn).pan=rd.panloc;
        adjusted_data(vn).data=adjusteddata;
        adjusted_data(vn).time=tcdata;
        adjusted_data(vn).range=range;
        adjusted_data(vn).filename=[runs(rn).name,'\',vecs(vn).name];
%         t_data{rn,vn}=rd.tiltloc;
%         p_data{rn,vn}=rd.panloc;
%         d_data{rn,vn}=adjusteddata;
%         i_data{rn,vn}=tcdata;
%         r_data{rn,vn}=range;
%         f_data{rn,vn}=[runs(rn).name,'\',vecs(vn).name];
%         
    end
        save(fullfile(store_dir,runs(rn).name,['adjusted_data','.mat']),'adjusted_data','-v7.3');

end

% for fn=1:size(t_data,1)
%     clear adjusted_data
%     gn=1;
%     while ~isempty(t_data{fn,gn})
%         
% %     for gn=1:size(t_data,2)
%     adjusted_data(gn).tilt=t_data{fn,gn};
%     adjusted_data(gn).pan=p_data{fn,gn};
%     adjusted_data(gn).data=d_data{fn,gn};
%     adjusted_data(gn).time=i_data{fn,gn};
%     adjusted_data(gn).range=r_data{fn,gn};
%     adjusted_data(gn).filename=f_data{fn,gn};
%     gn=gn+1;
%     end
    
    
    
%     save(fullfile(date_dir,runs(fn).name,['adjusted_data','.mat']),'adjusted_data','-v7.3');
% end
    
    
end
