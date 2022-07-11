function [event]=Insect_Lidar_Avg_vs_ScanAvg(date);
stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\';

% stored_data='C:\Martin_Tauc\Research\Stored_data\';
dateinfo_dir=[stored_data,date];
dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
for n=1:size(dateinfo,1);run_time(n,:)=datenum(dateinfo(n).name(11:end),'HHMMSS');end
mode_run_time=mode(diff(run_time));

date_dir=[stored_data, date,'\processed_data'];
runs=dir(date_dir);
runs=runs(~ismember({runs.name},{'.','..','events.mat'}));
rn_vec=1:size(runs,1);
for rn = rn_vec
%     rn=91;
    clear field_name processed
    processed=load(fullfile(date_dir,runs(rn).name));
    field_name=fieldnames(processed);
    %     add_data=processed.(field_name{:})(1).data;
    %     for an=1:size(processed.(field_name{:}),2)-1
    %         add_data=add_data+processed.(field_name{:})(an).data;
    %         mean_data(:,an)=mean(processed.(field_name{:})(an).data,2);
    %     end
    %     mean_add_data=mean(add_data,2);
    %     mad=0;
    %     for an=1:size(processed.(field_name{:}),2)
    %         mean_data(:,an)=mean(processed.(field_name{:})(an).data,2);
    %         mad=mad+mean_data(:,an);
    % %         rat(:,an)=mean_data(:,an)./mean_add_data;
    %     end
    % % end
    
    
    for n=1:size(processed.(field_name{:}),2)
        events.temp.all_data(n,:,:)=processed.(field_name{:})(n).data;
    end
    events.temp.data=mean(events.temp.all_data,1);
    events.temp.mean(:,:)=events.temp.data(1,:,:);
    events.temp.md=mean(events.temp.mean,2);
    events.temp.to_loc=find(events.temp.md>400);
    
    for n=1:size(processed.(field_name{:}),2)
        events.temp.(field_name{:})(n).ratio=(processed.(field_name{:})(n).data)./(events.temp.mean);
        [events.temp.(field_name{:})(n).x, events.temp.(field_name{:})(n).y]=find(events.temp.(field_name{:})(n).ratio>5);
        events.(field_name{:})(n).location=unique(events.temp.(field_name{:})(n).x);
        clear to_log
        to_log=find(ismember(events.(field_name{:})(n).location,events.temp.to_loc)==1);
        events.(field_name{:})(n).location(to_log)=[];
        if ~isempty(events.(field_name{:})(n).location)
            for m=1:size(events.(field_name{:})(n).location,1)
                events.(field_name{:})(n).range_bin(m).location=events.(field_name{:})(n).location(m);
                events.(field_name{:})(n).range_bin(m).data=processed.(field_name{:})(n).data(events.(field_name{:})(n).location(m),:);
                events.(field_name{:})(n).range_bin(m).time=processed.(field_name{:})(n).time;
                events.(field_name{:})(n).range_bin(m).range=processed.(field_name{:})(n).range;
                events.(field_name{:})(n).range_bin(m).pan=processed.(field_name{:})(n).pan;
                events.(field_name{:})(n).range_bin(m).tilt=processed.(field_name{:})(n).tilt;
                events.temp.d_num=datenum([date,'-',num2str(str2num(processed.(field_name{:})(n).filename(11:16))+...
                    str2num(datestr(mode_run_time*(str2num(processed.(field_name{:})(n).filename(18:22))/240),'HHMMSS')))],'yyyy-mm-dd-HHMMSS');
                events.(field_name{:})(n).range_bin(m).datenum=events.temp.d_num;
                events.(field_name{:})(n).range_bin(m).filename=processed.(field_name{:})(n).filename;
            end
        end
    end
    
    
    
%     (['rb_',num2str(events.(field_name{:})(n).location(m))])
    
    events=rmfield(events,'temp');
    int=0;
    for n=1:size(events.(field_name{:}),2)
        if ~isempty(events.(field_name{:})(n).location)
            int=int+1;
            event.(field_name{:})(int).info=events.(field_name{:})(n).range_bin;
        end
    end
    
    
end


% stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\';
% date_dir=[stored_data, date];
% runs=dir(date_dir);
% is_saved=dir(fullfile(date_dir,'save_point.mat'));
% is_insect=dir(fullfile(date_dir,'insect.mat'));
% runs=runs(~ismember({runs.name},{'.','..','processed_data.mat','hits.txt'}));
%
%
% %% Standard method to create proper vector to load data
% if isempty(is_saved)
%     %     runs=runs(~ismember({runs.name},{'.','..','processed_data.mat'}));
%     rn_vec=1:size(runs,1);
%     int=0;
% else
%     disp('save point found, loading data')
%     save_point=load(fullfile(date_dir,'save_point.mat'));
%     for n=1:size(runs,1)
%     location(n)=strcmp(runs(n).name,save_point.sp);
%     end
%     start_point=find(location==1)+1;
%     rn_vec=start_point:size(runs,1);
%     if ~isempty(is_insect);
%         insect=load(fullfile(date_dir,'insect.mat'));
%         int=size(insect,1);
%     else
%         int=0;
%     end
%
% end
% %% known insects here on 2016-06-07
% load(fullfile(date_dir,'insect_firstrun.mat'));
% clear rn_vec
% for n=1:size(insect,2)
%     ins(n).name=insect(n).filename(1:end-21);
%     idx=~cellfun('isempty',strfind({runs.name},ins(n).name));
%     rn_vec(n)=find(idx~=0);
% end
% rn_vec=unique(rn_vec);
% clear insect
%
% for rn=rn_vec%1:1%size(runs,1)
%     clear vecs vn
%     vecs=dir([date_dir,'\',runs(rn).name]);
%     vecs=vecs(~ismember({vecs.name},{'.','..','processed_data.mat'}));
%     sp=runs(rn).name;
%     for vn=1:size(vecs,1)
%         tic
%
%         clear tsdata full_data adjusted_data panloc tiltloc tsdata start_address ...
%             tcdata nop n dt bpfilter delta_t max_freq filt_data delta_f fqdata freq_data
%         load([date_dir,'\',runs(rn).name,'\',vecs(vn).name])
%         [adjusted_data,tcdata,range]=fix_cell_struct(full_data,start_address,tsdata);
%         %%
%         nop=size(adjusted_data,2);
%         delta_t=mean(diff(tcdata));
%         max_freq=1./(2*delta_t);
%         %%
%         bpfilter = designfilt('bandpassfir','FilterOrder',filt_order,'CutoffFrequency1',filt_LO_cutoff,'CutoffFrequency2',1500,'SampleRate',max_freq*2);
%         filt_data = filter(bpfilter,adjusted_data')';
%         delta_f=1/tcdata(end);
%         fqdata=(-nop/2:nop/2-1).*delta_f;
%         freq_data=fftshift(fft(filt_data,nop,2),2);
%         %         plot(fqdata,(abs(freq_data(37,:))/(nop)).^1)
%
%         %         subplot(1,2,1)
%         %         imagesc(tcdata,range,filt_data)
%         %         title([date,'-',runs(rn+2).name,'-',vecs(vn+2).name],'interpreter','none')
%         %         xlabel('time (\mus)')
%         %         ylabel('range (m)')
%         %         subplot(1,2,2)
%         %         imagesc(fqdata,range,abs(freq_data/nop).^2)
%         %         xlabel('frequency (Hz)')
%         %         ylabel('range (m)')
%         %         xlim([0 1200])
%         %         disp([date,'-',runs(rn+2).name,'-',vecs(vn+2).name]);
%         %         pause
%         %
%
%         gz_index=find(fqdata>=0);
%         fqi_d=fqdata(gz_index);
%         freqi_d=abs((freq_data(:,gz_index)/nop).^2);
%         [ii, jj] = sort(freqi_d,2,'descend');
%         [pxx,f]=pwelch(filt_data',500,300,1024,max_freq*2);
%
%
%         if sum(fqi_d(jj(:,1)))>0;
%             int=int+1;
%
%             insect(int).wing_frequency=fqi_d(jj(:,1));
%             insect(int).pan_location=panloc;
%             insect(int).tilt_location=tiltloc;
%             insect(int).time=tcdata;
%             insect(int).td_data=adjusted_data;
%             insect(int).fl_data=filt_data;
%             insect(int).frequency=fqi_d;
%             insect(int).fd_data=freqi_d;
%             insect(int).welch_d=pxx';
%             insect(int).welch_f=f;
%             insect(int).filename=[runs(rn).name,'\',vecs(vn).name];
%
%         end
%         disp([runs(rn).name,'\',vecs(vn).name])
%         toc
%         %         sp=[runs(rn).name,'\',vecs(vn).name];
%     end
% %     save(fullfile(date_dir,'save_point'),'sp');
%     if exist('insect','var');
%         clear fo
%         fo=sprintf('%3.2f',filt_order);
%         lco=sprintf('%3.2f',filt_LO_cutoff);
%         lco(lco=='.')='_';
%         fo(fo=='.')='_';
%         save(fullfile(date_dir,['insect_FO_',fo,'_LCO_',lco,'.mat']),'insect','-v7.3');
%     end
%
% end
% % if exist('insect','var');
% %     save(fullfile(date_dir,'insect'),'insect');
% % end
% end