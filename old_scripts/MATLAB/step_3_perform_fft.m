function [fqdata,freq_data,maxi,maxv,umx,igmx,indx_igmx]=step_3_perform_fft(positive_data,data,manual_insects,sl_coef,fn,n)
   %% do fft on positive_data
        nop=size(positive_data,2);
%         delta_t=mean(diff(data.(fn{:})(manual_insects(n).y).time));
%         max_freq=1./(2*delta_t);
        % bpfilter = designfilt('bandpassfir','FilterOrder',100,'CutoffFrequency1',50,'CutoffFrequency2',1500,'SampleRate',max_freq*2);
        % filt_data = filter(bpfilter,adjusted_data')';
        delta_f=1/data.(fn{:})(manual_insects(n).y).time(end);
        fqdata=(-nop/2:nop/2-1).*delta_f;
        freq_data=fftshift(fft(positive_data,nop,2),2);
        %% Find peaks
        [maxv,maxi]=findpeaks(abs(freq_data(513:end)).^2);
        movmx=movmax((abs(freq_data(513:end))).^2,round(sl_coef*mean(diff(maxi(2:end)))));

%         [tminv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
%         [imxtf,imx]=ismember(maxv,movmx);
        [umx,igmxnf,~]=intersect(maxv,movmx);
        [igmx,indx_igmx]=sort(igmxnf,'ascend');