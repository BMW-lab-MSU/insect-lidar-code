function []=Insect_Lidar_manual_insect_finder_step_3(date)
[start_file,filename,fols,inz,inx,inc,inv,inb,n_start,manual_insects]=step_3_initialize(date);
for n=n_start:size(manual_insects,2)
    %% load data and calculate positive data
    [positive_data,fn,data]=step_3_load_data(filename,fols,n,manual_insects);
    %% find exact time of insect incident
    [exact_time,~]=step_3_find_time(start_file,date,fn,data,manual_insects,n);
    %% plot initial data
    fig1=figure(1);
    plot(positive_data);
    title(sprintf('Insect at AMK Ranch on %s\n at a distance of %2.1f m',...
        exact_time, data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
    xlabel('pulse number')
    ylabel('normalized detected signal (arb)')
    multiple_insects=input('are there multiple insects (yes (c)/no (v))? ','s');
    
    if strcmp(multiple_insects,'c')==1
        inb=inb+1;
        manual_final_insects.multiple_insects(inb).x=manual_insects(n).x;
        manual_final_insects.multiple_insects(inb).y=manual_insects(n).y;
        manual_final_insects.multiple_insects(inb).z=manual_insects(n).z;
    else
        lower_bound=input('lower bound of insect event ');
        upper_bound=input('upper bound of insect event ');
        pks=input('number of peaks ');
        
        subplot(2,2,1)
        plot(data.(fn{:})(manual_insects(n).y).time,positive_data)
        title(sprintf('Insect at AMK Ranch on %s\n at a distance of %2.1f m',...
            exact_time, data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        %% do guass
        wind=5;
        [np,pk_f_freq,gtmaxv,gtminv,loc]=step_3_do_gauss(wind,positive_data,lower_bound,upper_bound,fn,data,manual_insects,n,pks);
        subplot(2,2,3)
        plot(data.(fn{:})(manual_insects(n).y).time,np,data.(fn{:})(manual_insects(n).y).time,gtmaxv,'r--',...
            data.(fn{:})(manual_insects(n).y).time,gtminv,'g:',data.(fn{:})(manual_insects(n).y).time(loc),np(loc),'yo')
        
        %% do fft on positive_data
        [fqdata,freq_data,maxi,maxv,~,~,~]=step_3_perform_fft(positive_data,data,manual_insects,1,fn,n);
        %         [minv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
        subplot(2,2,2)
        plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
        xlabel('frequency (Hz)')
        ylabel('power (arb)')
        title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m', exact_time,data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
        xlim([0 1500])
        ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
        %% do fft on gauss_data
        sl_coef=5;
        [fqdata,gfreq_data,gmaxi,gmaxv,umx,igmx,indx_igmx]=step_3_perform_fft(np,data,manual_insects,sl_coef,fn,n);
        
                slmin=1;
                slmax=10;
        
        %         pl4=plot(fqdata,(abs(gfreq_data)).^2,'b',fqdata(512+gmaxi(igmx)),umx(indx_igmx),'m>');
        %
        %         hsl=uicontrol('Style','slider','min',slmin,'Max',slmax,'SliderStep', [1 1]./(slmax-slmin),'Value',1,'Position',[20 20 200 20]);
        %
        h=slidevar('threshold',[0 20]);
%         temp=1;
        subplot(2,2,4);
        ax=axes('Parent',fig1);
        plt1=plot(ax,fqdata,(abs(gfreq_data)).^2,'b',fqdata(512+gmaxi(igmx)),temp.*umx(indx_igmx),'m>');
        
        slider=uicontrol('Parent',fig1,'Style','slider','min',slmin,'Max',slmax,'SliderStep', [1 1]./(slmax-slmin),'Value',temp,'Position',[20 20 200 20],'Callback',@SliderCB);
        
        slider.Callback = @(es,ed) updateSystem(plt1,fqdata,(abs(gfreq_data)).^2,'b',fqdata(512+gmaxi(igmx)),(es.Value).*umx(indx_igmx),'m>');
%         set(h1,'Callback',@(hObject,eventdata) plot(fqdata,(abs(gfreq_data)).^2,'b',fqdata(512+gmaxi(igmx)),get(hObject,'Value')*umx(indx_igmx),'m>'));
%         B=umx(indx_igmx);
%         vars=struct('slider',slider,'B',B);
%         dats=struct('fqdata',fqdata,'gfreq_data',gfreq_data,'gmaxi',gmaxi,'igmx',igmx);
%         set(slider,'Callback',{@SliderCB,vars,dats})
        xlabel('frequency (Hz)')
        
        
        ylabel('power (arb)')
        title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m', exact_time,data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
        xlim([0 1500])
        ylim([0 max((abs(gfreq_data(518:end)).^2))+max((abs(gfreq_data(518:end)).^2))*.05])
        max_peak=fqdata(511+gmaxi(find(gmaxv==max(gmaxv(2:end)))));
        
        
        %% peaks
        clear mxval mxtime
        wnd_ts_th=4;
        freq_space=1/max_peak;
        freq_val=find(data.(fn{:})(manual_insects(n).y).time<=freq_space/2,1,'last');
        cur_loc=find(positive_data(1:upper_bound)>=wnd_ts_th*median(positive_data),1,'first');
        inu=0;
        while cur_loc<=upper_bound-freq_val
            inu=inu+1;
            if cur_loc<=freq_val
                mxval(inu)=max(np(cur_loc:cur_loc+freq_val));
            else
                mxval(inu)=max(np(cur_loc-freq_val:cur_loc+freq_val));
            end
            cur_loc=cur_loc+freq_val*2+1;
            mxtime(inu)=data.(fn{:})(manual_insects(n).y).time(find(np==mxval(inu)));
        end
        subplot(2,2,3)
        plot(data.(fn{:})(manual_insects(n).y).time,np,data.(fn{:})(manual_insects(n).y).time,np,'b',mxtime,mxval,'ko',data.(fn{:})(manual_insects(n).y).time(loc),np(loc),'m*')
        pk_freq=1/mean(diff(mxtime));
        
        title(sprintf('Insect at AMK Ranch on %s\n at a distance of %2.1f m',...
            exact_time, data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        peak=input('which peaks should be isolated? ');
        mean_peaks=mean(diff(fqdata(512+gmaxi(igmx(1:peak)))));
        std_peaks=std(diff(fqdata(512+gmaxi(igmx(1:peak)))));
        sprintf('mean btwn frequency peaks: %4.2f Hz\nstd betwn frequency peaks: %4.2f Hz\nmaximum frequency peak is: %4.2f Hz\nmean freq some time peaks: %4.2f Hz\nmean freq from time peaks: %4.2f Hz',...
            mean_peaks,std_peaks,max_peak,pk_freq,pk_f_freq)
        %% rateing
        rate=input('rate from not likly to likely (z->x->c->v)','s');
        if strcmp(rate,'z')==1
            inz=inz+1;
            manual_final_insect.very_unlikely(inz).x=manual_insects(n).x;
            manual_final_insect.very_unlikely(inz).y=manual_insects(n).y;
            manual_final_insect.very_unlikely(inz).z=manual_insects(n).z;
            
            manual_final_insect.very_unlikely(inz).f_d_mean_pks=mean_peaks;
            manual_final_insect.very_unlikely(inz).f_d_std_pks=std_peaks;
            manual_final_insect.very_unlikely(inz).f_max_pk=max_peak;
            manual_final_insect.very_unlikely(inz).t_s_pks=pk_freq;
            manual_final_insect.very_unlikely(inz).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'x')==1
            inx=inx+1;
            manual_final_insect.somewhat_unlikely(inx).x=manual_insects(n).x;
            manual_final_insect.somewhat_unlikely(inx).y=manual_insects(n).y;
            manual_final_insect.somewhat_unlikely(inx).z=manual_insects(n).z;
            
            manual_final_insect.somewhat_unlikely(inx).f_d_mean_pks=mean_peaks;
            manual_final_insect.somewhat_unlikely(inx).f_d_std_pks=std_peaks;
            manual_final_insect.somewhat_unlikely(inx).f_max_pk=max_peak;
            manual_final_insect.somewhat_unlikely(inx).t_s_pks=pk_freq;
            manual_final_insect.somewhat_unlikely(inx).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'c')==1
            inc=inc+1;
            manual_final_insect.somewhat_likely(inc).x=manual_insects(n).x;
            manual_final_insect.somewhat_likely(inc).y=manual_insects(n).y;
            manual_final_insect.somewhat_likely(inc).z=manual_insects(n).z;
            
            manual_final_insect.somewhat_likely(inc).f_d_mean_pks=mean_peaks;
            manual_final_insect.somewhat_likely(inc).f_d_std_pks=std_peaks;
            manual_final_insect.somewhat_likely(inc).f_max_pk=max_peak;
            manual_final_insect.somewhat_likely(inc).t_s_pks=pk_freq;
            manual_final_insect.somewhat_likely(inc).t_all_pks=pk_f_freq;
        elseif strcmp(rate,'v')==1
            inv=inv+1;
            manual_final_insect.very_likely(inv).x=manual_insects(n).x;
            manual_final_insect.very_likely(inv).y=manual_insects(n).y;
            manual_final_insect.very_likely(inv).z=manual_insects(n).z;
            
            manual_final_insect.very_likely(inv).f_d_mean_pks=mean_peaks;
            manual_final_insect.very_likely(inv).f_d_std_pks=std_peaks;
            manual_final_insect.very_likely(inv).f_max_pk=max_peak;
            manual_final_insect.very_likely(inv).t_s_pks=pk_freq;
            manual_final_insect.very_likely(inv).t_all_pks=pk_f_freq;
        end
        
%         save(fullfile(filename,'events','manual_final_insect.mat'),'manual_final_insect','-v7.3')
    end
    disp(n)
end
function h=slidevar(varname,span)
h=figure;
hs=uicontrol(h,...
    'style','slider',...
    'pos',[10 40 280 20],...
    'min',span(1),...
    'max',span(2),...
    'value',span(1),...
    'callback',@sliderupdate,...
    'tag',varname);

uicontrol(h,...
    'style','text',...
    'pos',[10 10 280 20],...
    'tag',['text_' varname],...
    'string',num2str(span(1)));
function sliderupdate(varargin)
ht=findobj(bcbf,'style','text');
v=get(varargin{1},'value');
set(ht,'string',num2str(v))
assignin('base',get(varargin{1},'tag'),v);
%

% function []=SliderCB(hObject,vars,dats)
% temp=get(hObject, 'Value');
% plot(dats.fqdata,(abs(dats.gfreq_data)).^2,'b',dats.fqdata(512+dats.gmaxi(dats.igmx)),temp.*vars.B,'m>');
% disp(temp)
