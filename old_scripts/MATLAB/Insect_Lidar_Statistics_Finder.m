function full_stats=Insect_Lidar_Statistics_Finder(date,sf)
stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\'; %Rack Directory
tilt_vec=[];for n=1.5:.5:16;tilt_vec=[tilt_vec repmat(n,[1,8])];end
pan_vec=[];vv=39:.5:42.5;for n=1:size(tilt_vec,2)/8/2; pan_vec=[pan_vec vv flip(vv)];end

tilt_vec(end-7:end)=[];
pan_vec(end-7:end)=[];
% sf=3;
% stored_data='C:\Martin_Tauc\Research\Stored_data\'; %Office Directory
tic
% low_freq=50;
% high_freq=1500;

% step_1_th=400;
% step_2_th=5;
% step_3_th=3;

dateinfo_dir=[stored_data,date];
dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
for n=1:size(dateinfo,1);run_time(n,:)=datenum(dateinfo(n).name(11:end),'HHMMSS');end
mode_run_time=mode(diff(run_time));
load(fullfile(dateinfo_dir,'full_stats.mat'));
statfield=fieldnames(full_stats);
date_dir=[stored_data, date,'\processed_data'];
runs=dir(date_dir);
runs=runs(~ismember({runs.name},{'.','..','events'}));
% rn_vec=1:size(runs,1);
% rn_vec=14;


full_stats_curlength=0;
for fni=1:size(full_stats.(statfield{sf}),2)
    fn{fni,1}=full_stats.(statfield{sf})(fni).filename;
end
fnu=unique(fn);

for pt=1:size(fnu,1)
    clear name t_temp p_temp
    name=fnu{pt};
    t_temp=name(end-7:end-4);
    p_temp=name(end-12:end-9);
    fnu{pt,3}=str2double(t_temp)/100;
    fnu{pt,2}=str2double(p_temp)/100;
    %     fnu{pt,3}=sprintf('%02.2f',str2double(t_temp)/100);
    %     fnu{pt,2}=sprintf('%02.2f',str2double(p_temp)/100);
    %
end
for m=1:size(fnu,1);
    try
        pm(m)=find(abs(fnu{m,3}-tilt_vec(:))<0.245 & abs(fnu{m,2}-pan_vec(:))<0.245);
    catch
        %         pm(m)=[];
        disp(m)
    end
end
% pm(pm==0)=[];
rn_vec=pm;
c=0;
ccc=0;
for rn = rn_vec
    c=c+1;
    clear field_name processed fn_loc events
    fn_abs=strmatch(fnu{c,1},fn);
    fn_loc=[full_stats.(statfield{sf})(fn_abs).location]';
    
    processed=load(fullfile(date_dir,runs(rn).name));
    field_name=fieldnames(processed);
    
    
    for n=1:size(processed.(field_name{:}),2)
        events.temp.all_data(n,:,:)=processed.(field_name{:})(n).normalized_data;
    end
    for fni=1:size(processed.(field_name{:}),2)
        pd_filename{fni,1}=processed.(field_name{:})(fni).filename;
    end
    pd_loc=strmatch(fnu{c},pd_filename);
    events.temp.data=mean(events.temp.all_data,1);
    events.temp.mean(:,:)=events.temp.data(1,:,:);
    events.temp.md=median(events.temp.mean,2);
    events.temp.to_loc=find(events.temp.md>.98);
    clear cc
    
    
    events.temp.loc=intersect(fn_loc,events.temp.to_loc);
    
    
    %     if size(events.temp.to_loc,1)<=size(fn_loc,1)
    %         events.temp.loc=ismember(fn_loc,events.temp.to_loc);
    %     else
    %         events.temp.loc=ismember(events.temp.to_loc,fn_loc);
    %     end
    %     events.temp.loc(end+1:end+200)=zeros(200,1);
    temp_location_var=[events.temp.loc];
    cc=0;
    if ~isempty(pd_loc)
        for n=pd_loc
            cc=cc+1;
            events.temp.(field_name{:})(cc).ratio=(processed.(field_name{:})(n).normalized_data)./(events.temp.mean);
            for m=temp_location_var'
                ccc=ccc+1;
%                 if events.temp.loc(m)==1;
                    full_stats.(statfield{sf})(full_stats_curlength+m).ratio=events.temp.(field_name{:})(cc).ratio(m,:);
                    full_stats.(statfield{sf})(full_stats_curlength+m).max_ratio=min(events.temp.(field_name{:})(cc).ratio(m,:));
%                 else
%                     full_stats.(statfield{sf})(ccc).ratio=[];
%                     full_stats.(statfield{sf})(ccc).max_ratio=[];
%                 end
                disp(ccc)
            end
        end
    end
    full_stats_curlength=full_stats_curlength+length(fn_loc);

end
save(fullfile(dateinfo_dir,'full_stats.mat'),'full_stats','-v7.3');
end
% function full_stats=Insect_Lidar_Statistics_Finder(date)
% stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\'; %Rack Directory
% tilt_vec=[];for n=1.5:.5:15;tilt_vec=[tilt_vec repmat(n,[1,8])];end
% pan_vec=[];vv=39:.5:42.5;for n=1:size(tilt_vec,2)/8/2; pan_vec=[pan_vec vv flip(vv)];end
%
% % stored_data='C:\Martin_Tauc\Research\Stored_data\'; %Office Directory
% tic
% % low_freq=50;
% % high_freq=1500;
%
% % step_1_th=400;
% % step_2_th=5;
% % step_3_th=3;
%
% dateinfo_dir=[stored_data,date];
% dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
% for n=1:size(dateinfo,1);run_time(n,:)=datenum(dateinfo(n).name(11:end),'HHMMSS');end
% mode_run_time=mode(diff(run_time));
% load(fullfile(dateinfo_dir,'full_stats.mat'));
% date_dir=[stored_data, date,'\processed_data'];
% runs=dir(date_dir);
% runs=runs(~ismember({runs.name},{'.','..','events'}));
% % rn_vec=1:size(runs,1);
% % rn_vec=14;
%
% for fni=1:size(full_stats.noninsect,2)
%     fn{fni,1}=full_stats.noninsect(fni).filename;
% end
% fnu=unique(fn);
%
% for pt=1:size(fnu,1)
%     clear name t_temp p_temp
%     name=fnu{pt};
%     t_temp=name(end-7:end-4);
%     p_temp=name(end-12:end-9);
%     fnu{pt,3}=str2double(t_temp)/100;
%     fnu{pt,2}=str2double(p_temp)/100;
%     %     fnu{pt,3}=sprintf('%02.2f',str2double(t_temp)/100);
%     %     fnu{pt,2}=sprintf('%02.2f',str2double(p_temp)/100);
%     %
% end
% for m=1:size(fnu,1);
%     pm(m)=find(abs(fnu{m,3}-tilt_vec(:))<0.245 & abs(fnu{m,2}-pan_vec(:))<0.245);
% end
% rn_vec=pm;
% c=0;
% ccc=0;
% for rn = rn_vec
%     c=c+1;
%     clear field_name processed fn_loc events
%     fn_abs=strmatch(fnu{c,1},fn);
%     fn_loc=[full_stats.noninsect(fn_abs).location]';
%
%     processed=load(fullfile(date_dir,runs(rn).name));
%     field_name=fieldnames(processed);
%
%
%     for n=1:size(processed.(field_name{:}),2)
%         events.temp.all_data(n,:,:)=processed.(field_name{:})(n).normalized_data;
%     end
%     for fni=1:size(processed.(field_name{:}),2)
%         pd_filename{fni,1}=processed.(field_name{:})(fni).filename;
%     end
%     pd_loc=strmatch(fnu{c},pd_filename);
%     events.temp.data=mean(events.temp.all_data,1);
%     events.temp.mean(:,:)=events.temp.data(1,:,:);
%     events.temp.md=median(events.temp.mean,2);
%     events.temp.to_loc=find(events.temp.md>.98);
%     clear cc
%
%     if size(events.temp.to_loc,1)<=size(fn_loc,1)
%         events.temp.loc=ismember(fn_loc,events.temp.to_loc);
%     else
%         events.temp.loc=ismember(events.temp.to_loc,fn_loc);
%     end
%     %     events.temp.loc(end+1:end+200)=zeros(200,1);
%
%     cc=0;
%     if ~isempty(pd_loc)
%         for n=pd_loc
%             cc=cc+1;
%             events.temp.(field_name{:})(cc).ratio=(processed.(field_name{:})(n).normalized_data)./(events.temp.mean);
%             for m=1:size(fn_loc,1);
%                 ccc=ccc+1;
%                 if events.temp.loc(m)==1;
%                     full_stats.noninsect(ccc).ratio=events.temp.(field_name{:})(cc).ratio(m,:);
%                 else
%                     full_stats.noninsect(ccc).ratio=[];
%                 end
%                 disp(ccc)
%             end
%         end
%     end
% end

