function event=Insect_Lidar_Event_Search(date,step_1_th,step_2_th,step_3_th_a,step_3_th_b)
stored_data='D:\Data-Test\';
%stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\'; %Rack Directory
% stored_data='C:\Martin_Tauc\Research\Stored_data\'; %Office Directory
tic
low_freq=50;
high_freq=1500;

% step_1_th=400;
% step_2_th=5;
% step_3_th=3;

dateinfo_dir=[stored_data,date];
dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
for n=1:size(dateinfo,1);run_time(n,:)=datenum(dateinfo(n).name(11:end),'HHMMSS');end
mode_run_time=mode(diff(run_time));

date_dir=[stored_data, date,'\processed_data'];
runs=dir(date_dir);
runs=runs(~ismember({runs.name},{'.','..','events'}));
rn_vec=1:size(runs,1);
% rn_vec=14;
for rn = rn_vec
    clear field_name processed
    processed=load(fullfile(date_dir,runs(rn).name));
    field_name=fieldnames(processed);
    
    %     events.temp.all_data(:,:,:)=zeros(size(processed.(field_name{:}),2),size(processed.(field_name{:})(n).data,1),size(processed.(field_name{:})(n).data,2));
    
    for n=1:size(processed.(field_name{:}),2)
        events.temp.all_data(n,:,:)=processed.(field_name{:})(n).normalized_data;
    end
    
    events.temp.data=mean(events.temp.all_data,1);
    events.temp.mean(:,:)=events.temp.data(1,:,:);
    events.temp.md=median(events.temp.mean,2);
    events.temp.to_loc=find(events.temp.md<step_1_th);
    
    
    
    for n=1:size(processed.(field_name{:}),2)
        events.temp.(field_name{:})(n).ratio=(processed.(field_name{:})(n).normalized_data(:,:))./(events.temp.mean(:,:));
        [events.temp.(field_name{:})(n).x, events.temp.(field_name{:})(n).y]=find(events.temp.(field_name{:})(n).ratio<step_2_th);
        events.(field_name{:})(n).location=unique(events.temp.(field_name{:})(n).x);
        %         clear to_log
        to_log=find(ismember(events.(field_name{:})(n).location,events.temp.to_loc)==1);
        events.(field_name{:})(n).location(to_log)=[];
        if ~isempty(events.(field_name{:})(n).location)
            for m=1:size(events.(field_name{:})(n).location,1)
                events.(field_name{:})(n).range_bin(m).location=events.(field_name{:})(n).location(m);
                events.(field_name{:})(n).range_bin(m).vecmean=events.temp.mean;
                events.(field_name{:})(n).range_bin(m).data=processed.(field_name{:})(n).normalized_data(events.(field_name{:})(n).location(m),:);
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
    
    events=rmfield(events,'temp');
    int=0;
    for n=1:size(events.(field_name{:}),2)
        if ~isempty(events.(field_name{:})(n).location)
            int=int+1;
            event.(field_name{:})(int).info=events.(field_name{:})(n).range_bin;
        end
    end
    
    
end
clearvars -except event date_dir step_1_th step_2_th step_3_th_a step_3_th_b low_freq high_freq
int=0;
field_name=fieldnames(event);
for l=1:size(field_name,1)
    for n=1:size(event.(field_name{l}),2)
        for m=1:size(event.(field_name{l})(n).info,2)
            
            %             disp(sprintf('l = %2.2f n = %2.2f m = %2.2f',l,n,m));
            clear nop delta_t max_freq delta_f fqdata freq_data a b c loc_a loc_b loc_c pos_data loc g gauss_data
            loc=find(event.(field_name{l})(n).info(m).data./event.(field_name{l})(n).info(m).vecmean(event.(field_name{l})(n).info(m).location,:)<step_2_th);
            
            try
                g=gaussmf(1:size(event.(field_name{l})(n).info(m).data,2),[(max(loc)-min(loc))/2,mean(loc)]);
            catch
                g=gaussmf(1:size(event.(field_name{l})(n).info(m).data,2),[1,mean(loc)]);
            end
            
            pos_data=abs(event.(field_name{l})(n).info(m).data-max(event.(field_name{l})(n).info(m).data));
            gauss_data=g.*pos_data;
            %             nop=size(event.(field_name{l})(n).info(m).data,2);
%             nop=size(gauss_data,2);
            nop=size(pos_data,2);
            delta_t=mean(diff(event.(field_name{l})(n).info(m).time));
            max_freq=1./(2*delta_t);
            delta_f=1/event.(field_name{l})(n).info(m).time(end);
            fft_frequency=(-nop/2:nop/2-1).*delta_f;
%             fft_data=fftshift(fft(gauss_data,nop,2),2);
            fft_data=fftshift(fft(pos_data,nop,2),2);
%             [pw_data,pw_frequency]=pwelch(gauss_data,500,[],1024,max_freq*2);
            [pw_data,pw_frequency]=pwelch(pos_data,500,[],1024,max_freq*2);

            
            %             fft_data=fftshift(fft(event.(field_name{l})(n).info(m).data,nop,2),2);
            %             [pw_data,pw_frequency]=pwelch(event.(field_name{l})(n).info(m).data,800,600,1024,max_freq*2);
            
            [a loc_a]=max(abs(fft_data(find(fft_frequency<=low_freq,1,'last'):find(fft_frequency<=high_freq,1,'last'))));
            [b loc_b]=min(abs(fft_data(find(fft_frequency<=low_freq,1,'last'):find(fft_frequency<=low_freq,1,'last')+loc_a)));
            [c loc_c]=min(abs(fft_data(find(fft_frequency<=low_freq,1,'last')+loc_a:find(fft_frequency<=high_freq,1,'last'))));
            
            try
                ratio_1=a/b;
            catch
                ratio_1=1;
            end
            try
                ratio_2=a/c;
            catch
                ratio_2=1;
            end
            %%
            [maxv,maxi]=findpeaks(abs(fft_data(512:end)).^2);
            [minv,mini]=findpeaks(1.01*max(abs(fft_data(512:end)).^2)-abs(fft_data(512:end)).^2);
            minv=abs(fft_data(511+mini)).^2;
            std_th=0;
            wl_var=500;
            while wl_var>20 && std_th<max(abs(fft_data(512:end)).^2)
                std_th=std_th+0.001;
                new_maxi=maxi(find(maxv>std_th));
                dm=diff(fft_frequency(511+new_maxi));
                wl_var=std(dm);
%                 disp([wl_var, std_th])
                %         pause(0.01)
            end
            
            clear lower_min upper_min upper_ratio lower_ratio
            if size(new_maxi,2)>1
                
                for l=2:size(new_maxi,2)
                    lower_min(l-1)=minv(find(fft_frequency(511+mini)<fft_frequency(511+new_maxi(l)),1,'last'));
                    try
                        upper_min(l-1)=minv(find(fft_frequency(511+mini)>fft_frequency(511+new_maxi(l)),1,'first'));
                    catch
                        upper_min(l-1)=fft_frequency(end);
                    end
                    lower_ratio(l-1)=lower_min(l-1)/new_maxi(l-1);
                    upper_ratio(l-1)=upper_min(l-1)/new_maxi(l-1);
                end
            else
                lower_min=0;
                upper_min=0;
                lower_ratio=0;
                upper_ratio=0;
            end
            
            
                        %%
            event.(field_name{l})(n).info(m).positive_data=pos_data;
            event.(field_name{l})(n).info(m).gauss_data=gauss_data;
            event.(field_name{l})(n).info(m).fft_frequency=fft_frequency;
            event.(field_name{l})(n).info(m).fft_data=fft_data;
            event.(field_name{l})(n).info(m).pw_frequency=pw_frequency;
            event.(field_name{l})(n).info(m).pw_data=pw_data;
            event.(field_name{l})(n).info(m).lower_ratio=ratio_1;
            event.(field_name{l})(n).info(m).upper_ratio=ratio_2;
            
            event.(field_name{l})(n).info(m).median_peaks=median(dm);
            event.(field_name{l})(n).info(m).std_peaks=std(dm);
            event.(field_name{l})(n).info(m).std_th=std_th;
            event.(field_name{l})(n).info(m).maxv=maxv;
            event.(field_name{l})(n).info(m).maxi=new_maxi;
            event.(field_name{l})(n).info(m).lower_min=lower_min;
            event.(field_name{l})(n).info(m).upper_min=upper_min;
            event.(field_name{l})(n).info(m).l_ratio=lower_ratio;
            event.(field_name{l})(n).info(m).u_ratio=upper_ratio;
            
            if std(dm)==0
                event.(field_name{l})(n).info(m).p_ratio=max(abs(fft_data(512:end)).^2)/median(dm);
            else
                event.(field_name{l})(n).info(m).p_ratio=[];
            end

            
            
            int=int+1;
            
            location(int).l=l;
            location(int).n=n;
            location(int).m=m;
            LR(int)=event.(field_name{l})(n).info(m).lower_ratio;
            UR(int)=event.(field_name{l})(n).info(m).upper_ratio;
            % %% Plot
            %                         subplot(2,3,[1 4])
            %                         plot(event.(field_name{l})(n).info(m).time,event.(field_name{l})(n).info(m).data)
            %                         title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n l=%2.2f, n=%2.2f, m=%2.2f',...
            %                             event.(field_name{l})(n).info(m).tilt,event.(field_name{l})(n).info(m).pan,...
            %                             event.(field_name{l})(n).info(m).range(event.(field_name{l})(n).info(m).location),...
            %                             l,n,m),'interpreter','latex');
            %                         xlabel('time (s)')
            %                         ylabel('detected response (DN)')
            %                         ylim([0 6000])
            %                         subplot(2,3,[2 3])
            %                         plot(event.(field_name{l})(n).info(m).fft_frequency,abs((event.(field_name{l})(n).info(m).fft_data)).^2)
            %                         title(sprintf('Wing-Beat spectrum using FFT'),'interpreter','latex')
            %                         xlabel('frequency (Hz)')
            %                         ylabel('power (arb.)')
            %                         xlim([0 1500])
            %                         ylim([0 1e9])
            %                         subplot(2,3,[5 6])
            %                         plot(event.(field_name{l})(n).info(m).pw_frequency,event.(field_name{l})(n).info(m).pw_data)
            %                         title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
            %                         xlabel('frequency (Hz)')
            %                         ylabel('power (arb.)')
            %                         xlim([0 1500])
            %                         ylim([0 1000])
            %                         set(gcf,'units','normalized')
            %                         set(gcf,'outerposition',[0.8708 0.0574 0.8833 0.9500])
            %
            % %                         set(gcf,'units','normalized','outerposition',[1 0 1 1])
            %                         pause
            %                         close all
        end
    end
end

% int=0;
% for l=1:size(field_name,1);
%     for n=1:size(event.(field_name{l}),2)
%         for m=1:size(event.(field_name{l})(n),2)
%
%             int=int+1;
%
%             location(int).l=l;
%             location(int).n=n;
%             location(int).m=m;
%             LR(int)=event.(field_name{l})(n).info(m).lower_ratio;
%             UR(int)=event.(field_name{l})(n).info(m).upper_ratio;
%         end
%     end
% end
lrur=find(LR<=step_3_th_b & UR>=step_3_th_a);
keepers=location(lrur);

for h=1:length(keepers)
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).vecmean=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).vecmean;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).range=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).range;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).datenum=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).datenum;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_frequency=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_frequency;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_data;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).lower_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).lower_ratio;
    insect_event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).upper_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).upper_ratio;
    
end
clear field_name
field_name=fieldnames(insect_event);
clear ee
for n=1:size(field_name,1)
    ee{n}=arrayfun(@(s) all(structfun(@isempty,s)),insect_event.(field_name{n}));
    insect_event.(field_name{n})(ee{n}==1)=[];
end
clear ee
for n=1:size(field_name,1)
    for m=1:size(insect_event.(field_name{n}),2)
        clear ee
        ee=arrayfun(@(s) all(structfun(@isempty,s)),insect_event.(field_name{n})(m).info);
        insect_event.(field_name{n})(m).info(ee==1)=[];
    end
end

save(fullfile(date_dir,'events','insect_event_16-10-11.mat'),'insect_event','-v7.3')


event_filename=sprintf('event_fTH_%3.2f_sTH_%3.2f_taTH_%3.4f_tbTH_%3.4f',step_1_th, step_2_th, step_3_th_a,step_3_th_b);
keepers_filename=sprintf('keeper_fTH_%3.2f_sTH_%3.2f_taTH_%3.4f_tbTH_%3.4f_size_%5.2f',step_1_th, step_2_th, step_3_th_a, step_3_th_b,size(keepers,2));

event_filename(event_filename=='.')='_';
keepers_filename(keepers_filename=='.')='_';

try
    save(fullfile(date_dir,'events',event_filename),'event','-v7.3')
    save(fullfile(date_dir,'events',keepers_filename),'keepers','-v7.3')
catch
    disp(['couldn''t save ',event_filename,' and ',keepers_filename])
end

toc
field_name=fieldnames(event);
for h=1:length(keepers)
    subplot(2,2,1)
    plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
    title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n l=%2.2f, n=%2.2f, m=%2.2f',...
        event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan,...
        event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).range(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location),...
        keepers(h).l,keepers(h).n,keepers(h).m),'interpreter','latex');
    xlabel('time (s)')
    ylabel('detected response (DN)')
    ylim([0 1.5])
    subplot(2,2,3)
    plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)
    title('gauss_data')
    xlabel('time (s)')
    ylabel('detected response (DN)')
    ylim([0 1.5])
    subplot(2,2,2)
    plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency,abs((event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data)).^2)
    title(sprintf('Wing-Beat spectrum using FFT'),'interpreter','latex')
    xlabel('frequency (Hz)')
    ylabel('power (arb.)')
    xlim([0 2000])
    ylim([0 10])
    subplot(2,2,4)
    plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_frequency,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_data)
    title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
    xlabel('frequency (Hz)')
    ylabel('power (arb.)')
    xlim([0 2000])
    %                         ylim([0 1500])
    set(gcf,'units','normalized')
    set(gcf,'outerposition',[0.995238095238095,0.0304761904761905,1.00952380952381,0.977142857142857])
    
    %                         set(gcf,'units','normalized','outerposition',[1.13809523809524,0.173333333333333,0.961904761904762,0.834285714285714])
    pause
    close all
    % % plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
end
% % %
%
% int=0;
for n=1:length(finding)
    for h=1:length(keepers)
        clear ins
        ins=find((event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location)==finding(1,n) & (event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).datenum)==finding(2,n));
        if ~isempty(ins)
            %         int=int+1;
            matches(1,n)=keepers(h).l;
            matches(2,n)=keepers(h).n;
            matches(3,n)=keepers(h).m;
        end
    end
end










