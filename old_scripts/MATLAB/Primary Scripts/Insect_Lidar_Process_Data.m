function []=Insect_Lidar_Process_Data(date)
%% Folders in a date folder
% stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data';
stored_data='C:\Martin_Tauc\Research\Stored_data\';
date_dir=fullfile(stored_data, date);
runs=dir(fullfile(date_dir,'AMK_Ranch*'));
rn_vec=1:size(runs,1);
% rn_vec=1;
% int=0;
% count=0;
% wb=waitbar(0,'please wait...');
%% Files in a run folder
parfor rn = rn_vec
    % clear processed_data int
    int=0;
    dummy_data=struct('tilt',[],'pan',[],'data',[],'time',[],'range',[],'filename',[]);
    %     dummy_data=[];
    % clear vecs vn
    vecs=dir([date_dir,'\',runs(rn).name]);
    vecs=vecs(~ismember({vecs.name},{'.','..','processed_data.mat'}));
    for vn = 1:size(vecs,1)
        
        tic
        int=int+1;
        %     clear tsdata full_data adjusted_data panloc tiltloc tsdata start_address ...
        %         tcdata nop n dt bpfilter delta_t max_freq filt_data delta_f fqdata freq_data
        %         try
        raw_data=load(fullfile(date_dir,runs(rn).name,vecs(vn).name));
        %         catch
        %             count=count+1;
        %             %         stri=fullfile(date_dir,runs(rn).name,vecs(vn).name);
        %             %         save(fullfile(date_dir,[num2str(count),'error here.mat']),'stri')
        %             vn=vn+1;
        %             raw_data=load(fullfile(date_dir,runs(rn).name,vecs(vn).name))
        %         end
        [adjusted_data,tcdata,range]=fix_cell_struct(raw_data.full_data,raw_data.start_address,raw_data.tsdata);
        
        dummy_data(int)=struct('tilt',raw_data.tiltloc,'pan',raw_data.panloc,'data',adjusted_data,'time',tcdata,'range',range,'filename',fullfile(runs(rn).name,vecs(vn).name));
        %         dummy_data(int)=struct('pan',raw_data.panloc);
        %         dummy_data(int)=struct('data',adjusted_data);
        %         dummy_data(int)=struct('time',tcdata);
        %         dummy_data(int)=struct('range',range);
        %         dummy_data(int)=struct('filename',fullfile(runs(rn).name,vecs(vn).name));
        %         tt=toc;
        %         disp(sprintf('%2.1f-%2.1f-%2.1f-%s',tt,rn,vn,dummy_data(int).filename));
        %         waitbar((rn*vn)/(max(rn_vec)*max(size(vecs,1))),wb,['estimated time remaining is ',...
        %             sprintf('%4.1f',tt*((max(rn_vec)*max(size(vecs,1)))-(rn*vn))/60),' minutes'])
        
    end
    processed_data(rn)=dummy_data;
    %     save(fullfile(date_dir,runs(rn).name,['processed_data','.mat']),'processed_data','-v7.3');
end



for h=1:length(processed_data)
    clear temp
    temp=processed_data(rn);
    save(fullfile(date_dir,runs(rn).name,['processed_data','.mat']),'temp','-v7.3');
end
end

% delete(wb)
% end