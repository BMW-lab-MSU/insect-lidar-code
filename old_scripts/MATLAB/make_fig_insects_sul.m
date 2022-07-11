function analysis_data=make_fig_insects_sl(vli_start)
close all
set_plot_defaults
start_file='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\';
date='2016-06-08';
filename=fullfile(start_file,'Stored Data',date,'processed_data');
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events'}));
load(fullfile(filename,'events','manual_final_insect_no_mul.mat'));
try
load(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles','repeat_check.mat'));
catch
    disp('no repeat_check.mat on file')
end

% vli=1;
try
    load(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles','analysis_data.mat'))
    int=size(analysis_data,2);
catch
int=0;
end
for vli=vli_start:size(manual_final_insect.somewhat_unlikely,2)
    clearvars -except start_file date filename fols manual_final_insect repeat_check vli int analysis_data
    data=load(fullfile(filename,fols(manual_final_insect.somewhat_unlikely(vli).x).name));
    fn=fieldnames(data);
    tfg=dir(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles'));
    tfg=tfg(~ismember({tfg.name},{'.','..'}));
    tfg=tfg([tfg.isdir]);
    try
        for n=1:length(tfg);tfgname(n)=str2num(tfg(n).name(4:end));end
        nfv=max(tfgname);
    catch
        nfv=0;
    end
    disp([vli, int, nfv])
    
    fig_value=sprintf('fig%03i',nfv+1);
    
    % % dogauss=0;
    % % dofreq=0;
    % % n=74;
    % % m=46;
    % % lsec=300;
    % % hsec=500;
    % % tho_pts=1:size(adjusted_data(n).normalized_data,2);
    % % name=sprintf('%s-%3i-%3i',time,n,m);
    % % name(name==' ')=[];
    
    % info=datainfo(:,4:end);
    % di=cell2struct(info,names,1);
    % full_data=data(:,tho_pts);
    % start_address=[di(tho_pts).Startaddress];
    % tsdata=[di(1:length(tho_pts)).Timestamp];
    % [adjusted_data,tcdata,range]=fix_cell_struct(full_data,start_address,tsdata,true);
    % adjusted_data=adjusted_data-(mean(adjusted_data,2)*ones(1,size(adjusted_data,2)));
    positive_data=abs(data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).normalized_data(manual_final_insect.somewhat_unlikely(vli).z,:)-...
        max(data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).normalized_data(manual_final_insect.somewhat_unlikely(vli).z,:)));
    % positive_data=(adjusted_data(m,:)-min(adjusted_data(m,:)));
    %% find exact datenum
    dateinfo_dir=[start_file,'\Stored Data\',date];
    dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
    dateinfo=dateinfo([dateinfo.isdir]);
    for k=1:size(dateinfo,1);run_time(k,:)=datenum(dateinfo(k).name(11:end),'HHMMSS');end
    mode_run_time=mode(diff(run_time));
    
    exact_dnum=datenum([date,'-',num2str(str2num(data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).filename(11:16))+...
        str2num(datestr(mode_run_time*(str2num(data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).filename(18:22))/230),'HHMMSS')))],...
        'yyyy-mm-dd-HHMMSS');
    
    exact_time=datestr(exact_dnum,'yyyy-mm-dd HH:MM:SS');
    %%
    fig_data.positive_data=positive_data;
    fig_data.time_data=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).time;
    fig_data.range_data=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).range;
    fig_data.x=manual_final_insect.somewhat_unlikely(vli).x;
    fig_data.y=manual_final_insect.somewhat_unlikely(vli).y;
    fig_data.z=manual_final_insect.somewhat_unlikely(vli).z;
    fig_data.dnum=exact_dnum;
    fig_data.date_time=exact_time;
    
    repeat_check(vli).dnum=fig_data.dnum;
    repeat_check(vli).z=fig_data.z;
    repeat_check(vli).data=fig_data;
    datacursormode on
    if vli~=18
        if repeat_check(vli).dnum==repeat_check(vli-1).dnum && repeat_check(vli).z==repeat_check(vli-1).z+1
            fig1=figure(1);
            subplot(2,1,1)
            plot(fig_data.positive_data)
            xlabel('time (s)')
            ylabel('normalized detected signal (arb)')
            title('current data')
            
            subplot(2,1,2)
            plot(repeat_check(vli-1).data.positive_data)
            xlabel('time (s)')
            ylabel('normalized detected signal (arb)')
            title('past data')
            
            datacursormode on

            set(fig1,'outerposition',[1043 515 1696 1000])

            skypyn='q';
            while ~strcmp(skypyn,'y') && ~strcmp(skypyn,'n') && ~strcmp(skypyn,'x')
                skypyn=input('replace cd with pd (y/n)? (x if not a repeat) ','s');
            end
        else
            fig1=figure(1);
            plot(fig_data.positive_data)
            xlabel('time (s)')
            ylabel('normalized detected signal (arb)')
            title(sprintf('Insect at AMK Ranch on %s\nat a distance of %2.1f m',fig_data.date_time, fig_data.range_data(fig_data.z)))
            set(fig1,'outerposition',[1043 515 1696 1000])
            skypyn='x';
        end
    else
        fig1=figure(1);
        plot(fig_data.positive_data)
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        title(sprintf('Insect at AMK Ranch on %s\nat a distance of %2.1f m',fig_data.date_time, fig_data.range_data(fig_data.z)))
        set(fig1,'outerposition',[1043 515 1696 1000])
        skypyn='x';
        
    end
    if strcmp(skypyn,'y')
        clear fig_data fig_value
        fig_data=repeat_check(vli-1).data;
        fig_value=sprintf('fig%03i',nfv);
        rmdir(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles',fig_value),'s')
    end
    if ~strcmp(skypyn,'n')
        % adjusted_data=a_data(:,6001:7000);
        % tcdata=tcdata(1:1000);
        %% new version
        nop=size(fig_data.positive_data,2);
        delta_t=mean(diff(fig_data.time_data));
        max_freq=1./(2*delta_t);
        % bpfilter = designfilt('bandpassfir','FilterOrder',100,'CutoffFrequency1',50,'CutoffFrequency2',1500,'SampleRate',max_freq*2);
        % filt_data = filter(bpfilter,adjusted_data')';
        delta_f=1/fig_data.time_data(end);
        fqdata=(-nop/2:nop/2-1).*delta_f;
        freq_data=fftshift(fft(fig_data.positive_data,nop,2),2);
        %%
        gz_index=find(fqdata>=0);
        fqi_d=fqdata(gz_index);
        freqi_d=abs((freq_data(:,gz_index)/nop).^2);
        [ii, jj] = sort(freqi_d,2,'descend');
        [pxx,f]=pwelch(fig_data.positive_data',500,300,1024,max_freq*2);
        
        
        %         savefig(fullfile(start_file,'Figures','Thesis Figures',fig_value,[fig_value, '.fig']));
        %         saveas(gcf,fullfile(start_file,'Figures','Thesis Figures',fig_value,[name,'w.png']));
        
        
        
        
        if exist(fullfile(start_file,'Figures\Insect_Figures\Profiles',fig_value),'dir')==7
            save(fullfile(start_file,'Figures','Insect_Figures','Profiles',fig_value,'fig_data.mat'),'fig_data','-v7.3')
        else
            mkdir(fullfile(start_file,'Figures','Insect_Figures','Profiles',fig_value))
            save(fullfile(start_file,'Figures','Insect_Figures','Profiles',fig_value,'fig_data.mat'),'fig_data','-v7.3')
        end
        lsec=input('lower bound for Guassian? ');
        hsec=input('upper bound for Guassian? ');
        
        %% gauss stuff
        g=gaussmf(1:length(positive_data),[(hsec-lsec)/2,mean([hsec lsec])]);
        np=g.*positive_data;
        fig_data.gauss_data=np;
        
        g_freq_data=fftshift(fft(fig_data.gauss_data,nop,2),2);
        
        close all
        
        fig1=figure(1);
        subplot(2,2,1)
        plot(fig_data.time_data,fig_data.positive_data)
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        title(sprintf('Insect at AMK Ranch on %s\nat a distance of %2.1f m', fig_data.date_time, fig_data.range_data(fig_data.z)))
        set(fig1,'outerposition',[1043 515 1696 1026])
        
        
        subplot(2,2,3)
        plot(fig_data.time_data,fig_data.gauss_data)
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        title(sprintf('Insect at AMK Ranch with a Gaussian\nwindow on %s\nat a distance of %2.1f m', fig_data.date_time, fig_data.range_data(fig_data.z)))
        
        
        
        subplot(2,2,2)
        plot(fqdata,(abs(freq_data)).^2)
        xlim([0 1500])
        ylim([0 max((abs(freq_data(end/2+10:end)).^2))+2])
        xlabel('frequency (Hz)')
        ylabel('power (arb)')
        title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m',fig_data.date_time, fig_data.range_data(fig_data.z)))
        
        
        subplot(2,2,4)
        plot(fqdata,(abs(g_freq_data)).^2)
        xlim([0 1500])
        ylim([0 max((abs(freq_data(end/2+10:end)).^2))+2])
        xlabel('frequency (Hz)')
        ylabel('power (arb)')
        title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m',fig_data.date_time, fig_data.range_data(fig_data.z)))
        savefig(fullfile(start_file,'Figures','Insect_Figures','Profiles',fig_value,[fig_value, '.fig']));
        saveas(gcf,fullfile(start_file,'Figures','Insect_Figures','Profiles',fig_value,[fig_value,'.png']));
        close all
        
        pause(1.5)
        
        int=int+1;
        analysis_data(int).data=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).normalized_data(manual_final_insect.somewhat_unlikely(vli).z,:);
        analysis_data(int).tilt=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).tilt;
        analysis_data(int).pan=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).pan;
        analysis_data(int).time=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).time;
        analysis_data(int).range=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).range(manual_final_insect.somewhat_unlikely(vli).z);
        analysis_data(int).filename=data.(fn{:})(manual_final_insect.somewhat_unlikely(vli).y).filename;
        analysis_data(int).dnum=fig_data.dnum;
        analysis_data(int).datetime=fig_data.date_time;
        analysis_data(int).frequency=fqdata;
        analysis_data(int).freq_data=freq_data;
        analysis_data(int).gauss_freq_data=g_freq_data;
    end
    close all
    save(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles','repeat_check.mat'),'repeat_check','-v7.3')
    save(fullfile(start_file,'Figures','SL_Insect_Figures','Profiles','analysis_data.mat'),'analysis_data','-v7.3')
end
