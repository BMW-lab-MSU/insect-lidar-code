 %% Insect_Lidar_manual_insect_finder_step3_Liz | Liz| 2020-10-08

function []=Insect_lidar_manual_insect_finder_step3_Liz()
%set_plot_defaults
start_file='/Volumes/Insect Lidar/Data_2020/';
date='2020-09-16';
filename=fullfile(start_file,date);
disp(filename)
load(fullfile(filename,'events','sigcheck.mat'))
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events'}));
% try
%     load(fullfile(filename,'events\manual_final_insect.mat'));
% catch
%     disp('no mfi yet');
% end
% try
%     inz=size(manual_final_insect.very_unlikely,2);
% catch
%     inz=0;
% end
% try
%     inx=size(manual_final_insect.somewhat_unlikely,2);
% catch
%     inx=0;
% end
% try
%     inc=size(manual_final_insect.somewhat_likely,2);
% catch
%     inc=0;
% end
% try
%     inv=size(manual_final_insect.very_likely,2);
% catch
%     inv=0;
% end
% try
%     inb=size(manual_final_insect.multiple_insects,2);
% catch
%     inb=0;
% end


global CB
global tcb

n_start=input('value of n to start? ');

for n=n_start:size(sigcheck,2)
    close all
    figone=figure(1);
    datacursormode on
    %% load data and calculate positive data
    alldata=load(fullfile(filename,sigcheck.insects(n).name,'adjusted_data_decembercal'));
    whichfile=40;
    bin=12;
    data=alldata.adjusted_data_decembercal(whichfile).normalized_data(bin,:);
    %fn=fieldnames(data.adjusted_data_decembercal);
    %data=abs(data.(fn{:})(sigcheck(n).y).normalized_data(sigcheck(n).z,:)...
     %   -max(data.(fn{:})(sigcheck(n).y).normalized_data(sigcheck(n).z,:)));
    
     %data = data.(fn{:})(sigcheck(n).y).normalized_data(sigcheck(n).z,:);
     %% find exact time of insect incident
    dateinfo_dir=[start_file,date];
    dateinfo=dir(fullfile(dateinfo_dir,'Hyalite*'));
    dateinfo=dateinfo([dateinfo.isdir]);
    for k=1:size(dateinfo,1);run_time(k,:)=datenum(dateinfo(k).name(11:end),'HHMMSS');end
    mode_run_time=mode(diff(run_time));
    
    exact_dnum=datenum([date,'-',num2str(str2num(data.(fn{:})(sigcheck(n).y).filename(11:16))+...
        str2num(datestr(mode_run_time*(str2num(data.(fn{:})(sigcheck(n).y).filename(18:22))/230),'HHMMSS')))],...
        'yyyy-mm-dd-HHMMSS');
    
    exact_time=datestr(exact_dnum,'yyyy-mm-dd HH:MM:SS');
    %% plot
    subplot(2,2,1)
    plot(data)
    title(sprintf('Insect at Hyalite Creek on %s\n at a distance of %2.1f m',...
        exact_time, data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z)))
    xlabel('pulse number')
    ylabel('normalized detected signal (arb)')
    xlim([0 1024])    %set(figone,'outerposition',[633 213 656 688])
    %     multiple_insects=input('are there multiple insects (yes (c)/no (v))? ','s');
    
    
    lower_bound=input('lower bound of insect event ');
    upper_bound=input('upper bound of insect event ');
    if lower_bound==0
        inb=inb+1;
        manual_final_insect.multiple_insects(inb).x=sigcheck(n).x;
        manual_final_insect.multiple_insects(inb).y=sigcheck(n).y;
        manual_final_insect.multiple_insects(inb).z=sigcheck(n).z;
    else
        subplot(2,2,1)
        tcb.plt=plot(data.(fn{:})(sigcheck(n).y).time,data,'b',...
            data.(fn{:})(sigcheck(n).y).time,...
            ones(size(data.(fn{:})(sigcheck(n).y).time)).*max(data),'k:');
        title(sprintf('Insect at AMK Ranch on %s\n at a distance of %2.1f m',...
            exact_time, data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z)))
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        %% do guass
        wind=31;
        pks=input('number of peaks ');
        g=gaussmf(1:length(data),[(upper_bound-lower_bound)/2,mean([upper_bound lower_bound])]);
        np=g.*data;
        gtmaxv=movmax(np,wind);
        gtminv=movmin(np,wind);
        
        sg=unique(sort(gtmaxv));
        fsg=sg(end-pks:end);
        int=0;
        for f=fsg
            int=int+1;
            loc(int)=find(np==f);
        end
        pk_f_freq=abs(1/mean(diff(data.(fn{:})(sigcheck(n).y).time(loc))));
        %% do fft on data
        nop=size(data,2);
        delta_t=mean(diff(data.(fn{:})(sigcheck(n).y).time)); %pulse time difference
        max_freq=1./(2*delta_t); %max frequency based on avg pulse repetition rate
        delta_f=1/data.(fn{:})(sigcheck(n).y).time(end);
        fqdata=(-nop/2:nop/2-1).*delta_f;
        freq_data=fftshift(fft(data,nop,2),2);
        [maxv,maxi]=findpeaks(abs(freq_data(513:end)).^2);
        [tminv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
        subplot(2,2,2)
        plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
        xlabel('frequency (Hz)')
        ylabel('power (arb)')
        title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m', exact_time,data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z)))
        xlim([0 2200])
        ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
        %% do fft on gauss_data
        sl_coef=.2;
        CB.gfreq_data=fftshift(fft(np,nop,2),2);
        CB.np=np;
        CB.nop=nop;
        CB.fqdata=fqdata;
        [gmaxv,gmaxi]=findpeaks(abs(CB.gfreq_data(513:end)).^2);
        gmovmx=movmax((abs(CB.gfreq_data(513:end))).^2,round(sl_coef*mean(diff(gmaxi(2:end)))));
        [umx,igmxnf,igvx]=intersect(gmaxv,gmovmx);
        [igmx,indx_igmx]=sort(igmxnf,'ascend');
        slmin=.010;
        slmax=20;
        
        subplot(2,2,4);
       
        %Triangle Slider
        CB.gfax=plot(CB.fqdata,(abs(CB.gfreq_data)).^2,'b',CB.fqdata(512+gmaxi(igmx)),umx(indx_igmx),'m>'); %,CB.fqdata(513:end),gmovmx,'r.'
        uicontrol('Style','slider','min',slmin,'Max',slmax,'SliderStep', [.01 .1]./(slmax-slmin),'Value',sl_coef,'Position',[510 10 200 20],'Callback',@SliderCB);
        
        xlabel('frequency (Hz)')
        ylabel('power (arb)')
        title(sprintf('Windowed - AMK Ranch on %s\nat a distance of %2.1f m', exact_time,data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z)))
        xlim([0 2200])
        ylim([0 max((abs(CB.gfreq_data(518:end)).^2))+max((abs(CB.gfreq_data(518:end)).^2))*.05])
        temp_lf_offset = find(gmaxi<=5);
        lf_offset = length(temp_lf_offset)+1;
        max_peak=CB.fqdata(512+gmaxi(find(gmaxv==max(gmaxv(lf_offset:end)))));
        
        
        %% peaks
        clear mxval mxtime
        wnd_ts_th=.2;
        freq_space=1/max_peak;
        freq_val=find(data.(fn{:})(sigcheck(n).y).time<=freq_space/2,1,'last');
        tcb.freq_val=freq_val;
        
        cur_loc=find(data(1:upper_bound)>=wnd_ts_th*max(data),1,'first');
        
        inu=0;
        set(tcb.plt(2),'ydata',ones(size(data.(fn{:})(sigcheck(n).y).time)).*max(data).*wnd_ts_th)
        
        while cur_loc<=upper_bound-freq_val
            inu=inu+1;
            if cur_loc<=freq_val
                mxval(inu)=max(np(cur_loc:cur_loc+freq_val));
            else
                mxval(inu)=max(np(cur_loc-freq_val:cur_loc+freq_val));
            end
            cur_loc=cur_loc+freq_val*2+1;
            mxtime(inu)=data.(fn{:})(sigcheck(n).y).time(find(np==mxval(inu)));
        end
        tlmin=.01;
        tlmax=1;
        tcb.data=data;
        tcb.upper_bound=upper_bound;
        tcb.lower_bound=lower_bound;
        tcb.np=np;
        
        tcb.data=data;
        tcb.fn=fn;
        tcb.sigcheck=sigcheck;
        
        tcb.n=n;
        subplot(2,2,3)
        tcb.tax=plot(data.(fn{:})(sigcheck(n).y).time,np,data.(fn{:})(sigcheck(n).y).time,np,'b',...
            data.(fn{:})(sigcheck(n).y).time,np,data.(fn{:})(sigcheck(n).y).time,np,'r.',...
            mxtime,mxval,'ko');
        title(sprintf('Windowed - AMK Ranch on %s\n at a distance of %2.1f m',...
            exact_time, data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z)))
        xlim([data.(fn{:})(sigcheck(n).y).time(lower_bound)...
            data.(fn{:})(sigcheck(n).y).time(upper_bound)])
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        %Circle Slider
        uicontrol('Style','slider','min',tlmin,'Max',tlmax,'SliderStep', [.001 .01]./(slmax-slmin),'Value',wnd_ts_th,'Position',[96 8 188 19],'Callback',@SliderTCB);
       % set(figone,'outerposition',[1043 515 1696 1026])
        
        peak=input('which peaks should be isolated? ');
        pk_freq=1/mean(diff(tcb.mxtime));
        mean_pksnz=mean(diff([CB.fqdata(512+CB.gmaxi(CB.igmx(1:peak)))]));
        std_pksnz=std(diff([CB.fqdata(512+CB.gmaxi(CB.igmx(1:peak)))]));
        mean_peaks=mean(diff([0 CB.fqdata(512+CB.gmaxi(CB.igmx(1:peak)))]));
        std_peaks=std(diff([0 CB.fqdata(512+CB.gmaxi(CB.igmx(1:peak)))]));
        sprintf('mean nonz frequency peaks: %4.2f Hz\nstd no ze frequency peaks: %4.2f Hz\nmean btwn frequency peaks: %4.2f Hz\nstd betwn frequency peaks: %4.2f Hz\nmaximum frequency peak is: %4.2f Hz\nmean freq some time peaks: %4.2f Hz\nmean freq from time peaks: %4.2f Hz\n%s at a distance of %2.1f m',...
            mean_pksnz,std_pksnz,mean_peaks,std_peaks,max_peak,pk_freq,pk_f_freq,exact_time,data.(fn{:})(sigcheck(n).y).range(sigcheck(n).z))
        %% rateing
        rate=input('rate from not likly to likely (z->x->c->v)','s');
        if strcmp(rate,'z')==1
            inz=inz+1;
            manual_final_insect.very_unlikely(inz).x=sigcheck(n).x;
            manual_final_insect.very_unlikely(inz).y=sigcheck(n).y;
            manual_final_insect.very_unlikely(inz).z=sigcheck(n).z;
            
            manual_final_insect.very_unlikely(inz).f_d_mean_pks=mean_peaks;
            manual_final_insect.very_unlikely(inz).f_d_std_pks=std_peaks;
            manual_final_insect.very_unlikely(inz).f_max_pk=max_peak;
            manual_final_insect.very_unlikely(inz).t_s_pks=pk_freq;
            manual_final_insect.very_unlikely(inz).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'x')==1
            inx=inx+1;
            manual_final_insect.somewhat_unlikely(inx).x=sigcheck(n).x;
            manual_final_insect.somewhat_unlikely(inx).y=sigcheck(n).y;
            manual_final_insect.somewhat_unlikely(inx).z=sigcheck(n).z;
            
            manual_final_insect.somewhat_unlikely(inx).f_d_mean_pks=mean_peaks;
            manual_final_insect.somewhat_unlikely(inx).f_d_std_pks=std_peaks;
            manual_final_insect.somewhat_unlikely(inx).f_max_pk=max_peak;
            manual_final_insect.somewhat_unlikely(inx).t_s_pks=pk_freq;
            manual_final_insect.somewhat_unlikely(inx).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'c')==1
            inc=inc+1;
            manual_final_insect.somewhat_likely(inc).x=sigcheck(n).x;
            manual_final_insect.somewhat_likely(inc).y=sigcheck(n).y;
            manual_final_insect.somewhat_likely(inc).z=sigcheck(n).z;
            
            manual_final_insect.somewhat_likely(inc).f_d_mean_pks=mean_peaks;
            manual_final_insect.somewhat_likely(inc).f_d_std_pks=std_peaks;
            manual_final_insect.somewhat_likely(inc).f_max_pk=max_peak;
            manual_final_insect.somewhat_likely(inc).t_s_pks=pk_freq;
            manual_final_insect.somewhat_likely(inc).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'v')==1
            inv=inv+1;
            manual_final_insect.very_likely(inv).x=sigcheck(n).x;
            manual_final_insect.very_likely(inv).y=sigcheck(n).y;
            manual_final_insect.very_likely(inv).z=sigcheck(n).z;
            
            manual_final_insect.very_likely(inv).f_d_mean_pks=mean_peaks;
            manual_final_insect.very_likely(inv).f_d_std_pks=std_peaks;
            manual_final_insect.very_likely(inv).f_max_pk=max_peak;
            manual_final_insect.very_likely(inv).t_s_pks=pk_freq;
            manual_final_insect.very_likely(inv).t_all_pks=pk_f_freq;
        else
            inb=inb+1;
            manual_final_insect.multiple_insects(inb).x=sigcheck(n).x;
            manual_final_insect.multiple_insects(inb).y=sigcheck(n).y;
            manual_final_insect.multiple_insects(inb).z=sigcheck(n).z;
        end
        
    end
    close all
    disp(manual_final_insect)
    save(fullfile(filename,'events','manual_final_insect.mat'),'manual_final_insect','-v7.3')
    disp(n)
    
end
function []=SliderCB(source,event)
global CB
sl_coef=source.Value;
CB.gfreq_data=fftshift(fft(CB.np,CB.nop,2),2);
[gmaxv,gmaxi]=findpeaks(abs(CB.gfreq_data(513:end)).^2);
rndval=round(sl_coef*mean(diff(gmaxi(2:end))));
gmovmx=movmax((abs(CB.gfreq_data(513:end))).^2,rndval);
[umx,igmxnf,igvx]=intersect(gmaxv,gmovmx);
[igmx,indx_igmx]=sort(igmxnf,'ascend');
set(CB.gfax(2),'ydata',umx(indx_igmx))
set(CB.gfax(2),'xdata',CB.fqdata(512+gmaxi(igmx)))
CB.gmaxv=gmaxv;
CB.gmaxi=gmaxi;
CB.igmx=igmx;

function []=SliderTCB(source,event)
global tcb
wnd_ts_th=source.Value;
cur_loc=find(tcb.data(1:tcb.upper_bound)>=wnd_ts_th*max(tcb.data),1,'first');
inu=0;
while cur_loc<=tcb.upper_bound-tcb.freq_val
    if cur_loc<=tcb.freq_val
        inu=inu+1;
        mxval(inu)=max(tcb.np(cur_loc:cur_loc+tcb.freq_val));
    elseif cur_loc==tcb.upper_bound
        inu=inu+1;
        mxva(inu)=max(tcb.np(cur_loc-tcb.freq_val));
    else
        inu=inu+1;
        mxval(inu)=max(tcb.np(cur_loc-tcb.freq_val:cur_loc+tcb.freq_val));
    end
    cur_loc=cur_loc+tcb.freq_val*2+1;
    if exist('mxval','var')
        mxtime(inu)=tcb.data.(tcb.fn{:})(tcb.sigcheck(tcb.n).y).time(find(tcb.np==mxval(inu)));
    end
    
end
try
    set(tcb.tax(5),'ydata',mxval)
    set(tcb.tax(5),'xdata',mxtime)
    
    set(tcb.plt(2),'ydata',ones(size(tcb.data.(tcb.fn{:})(tcb.sigcheck(tcb.n).y).time)).*max(tcb.data).*wnd_ts_th)
    
    tcb.mxtime=mxtime;
    tcb.mxval=mxval;
    tcb.wnd_ts_th=wnd_ts_th;
catch
    disp('impossible value')
end



