function []=fft_simulation_gauss(user_def,sv,ylx,ns)
if ns==1
    noise=rand(1,1024)/10;
     set_plot_defaults
    close all
    % user_def=3;
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
    time=linspace(0,.25,1024);
    peaks=zeros(size(time));
    indx_spc=find(time<=(1/200),1,'last');
    indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul (n*indx_spc)+randi([-2 2],1)];
        sp=gaussmf(time,[time(sv+randi([-2 2],1)),time(indx_mul(n)+200)]);
        peaks=peaks+sp;
    end
    for n=1:size(time,2)
%         if peaks(n)<=0.1
            peaks(n)=peaks(n)+noise(n);
%         end
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%3.2f',time(sv)*1000);
%     figure('outerposition',[1923 233 576 513])
figure
    plot(time,peaks)
    t=sprintf('signal with %i peaks spaced by %2.2f ms (n gwt)}',user_def, mean(diff(time(indx_mul)))*1000);
    s=sprintf('simulated with gaussian peaks, sigma = %s ms}',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
    ylim([0 1.1])
    xlabel('time (s)')
    ylabel('return signal (arb)')
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    
    sig(sig=='.')='_';
    ft=sprintf('gg_%i_pk_%s_wngwt',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));

    nop=size(peaks,2);
    delta_t=mean(diff(time));
    max_freq=1./(2*delta_t);
    delta_f=1/time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    
%     figure('outerposition',[1923+563 233 576 513])
figure
    plot(fqdata,abs(freq_data).^2)
    t=sprintf('with %i peaks spaced by %2.2f ms (n gwt)}',user_def, mean(diff(time(indx_mul)))*1000);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,ylx])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('gg_%i_pk_%s_fft_wngwt',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(1)
end
if sv~=0 && ns~=1
    set_plot_defaults
    close all
    % user_def=3;
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
    time=linspace(0,.25,1024);
    peaks=zeros(size(time));
    indx_spc=find(time<=(1/200),1,'last');
    indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul n*indx_spc];
        sp=gaussmf(time,[time(sv),time(indx_mul(n)+200)]);
        peaks=peaks+sp;
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%3.2f',time(sv)*1000);
%     figure('outerposition',[1923 233 576 513])
figure
    plot(time,peaks)
    t=sprintf('signal with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*1000);
    s=sprintf('simulated with gaussian peaks, sigma = %s ms}',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
    ylim([0 1.1])
    xlabel('time (s)')
    ylabel('return signal (arb)')
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    
    sig(sig=='.')='_';
    ft=sprintf('gg_%i_pk_%s',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));

    nop=size(peaks,2);
    delta_t=mean(diff(time));
    max_freq=1./(2*delta_t);
    delta_f=1/time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    
%     figure('outerposition',[1923+563 233 576 513])
figure
    plot(fqdata,abs(freq_data).^2)
    t=sprintf('with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*1000);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,ylx])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('gg_%i_pk_%s_fft',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(1)
elseif sv==0 && ns~=1
    sig='0';
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
    close all
    time=linspace(0,.25,1024);
    peaks=zeros(size(time));
    indx_spc=find(time<=(1/200),1,'last');
    indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul n*indx_spc];
    end
    peaks(indx_mul+200)=1/mean(diff(time(indx_mul)));
%     figure('outerposition',[1923 233 576 513])
    rectfl=find(peaks>0,1,'first');
    rectfh=find(peaks>0,1,'last');
    rect=zeros(size(peaks));
    rect(rectfl:rectfh)=1;
    disp(rectfh-rectfl)
figure
    plot(time,peaks,'b',time,rect,':r')
    t=sprintf('signal with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*1000);
    s=sprintf('simulated with gaussian peaks, sigma = %s ms}',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
%     ylim([0 200])

    xlabel('time (s)')
    ylabel('return signal (arb)')
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    sig(sig=='.')='_';
    ft=sprintf('gg_%i_pk_%s',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    
    nop=size(peaks,2);
    delta_t=mean(diff(time));
    max_freq=1./(2*delta_t);
    delta_f=1/time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    rectfft=fftshift(fft(rect,nop,2),2);
%     figure('outerposition',[1923+563 233 576 513])
figure
    plot(fqdata,abs(freq_data).^1,'b',fqdata,abs(rectfft).^1,'r')
    t=sprintf('with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*1000);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
%     ylim([0,ylx])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('gg_%i_pk_%s_fft',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(1)
end
