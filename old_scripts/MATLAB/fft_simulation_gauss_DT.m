function []=fft_simulation_gauss(user_def,sv)
if sv~=0
    set_plot_defaults
    close all
    % user_def=3;
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
    time=linspace(-512,511,1024);
    peaks=zeros(size(time));
    indx_spc=25;
    indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul n*indx_spc];
        sp=gaussmf(time,[time(sv),time(indx_mul(n))]);
        peaks=peaks+sp;
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%3.2f',time(sv));
    figure('outerposition',[1923 233 576 513])
    plot(time,peaks)
    t=sprintf('signal with %i peaks spaced by %2.2f}',user_def, mean(diff(time(indx_mul))));
    s=sprintf('simulated with gaussian peaks, sigma = %s}',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
    ylim([0 1.1])
    xlabel('time')
    ylabel('return signal')
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    
    sig(sig=='.')='_';
    ft=sprintf('dtgg_%i_pk_%s',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    
        nyq=.5/(mean(diff(time)));
    %     xof(:)=gaussmf(time,[time(sv),time(indx_spc)]);
    xof=peaks;
    w0=1/max(time);
    w=(-size(xof,2)/2:(size(xof,2)/2)-1).*w0;
    Xof(1)=0;
    for k=1:size(xof,2)-1
        Xof(k+1)=0;        
        %     Xof=xof(1)*exp(-1i*w*time(1));
        for n=1:size(xof,2)-1
            Xof(k+1)=Xof(k)+(xof(n+1)*exp(-1i*n*k*w0));
        end
    end
    figure
    plot(time,xof)
    figure
    plot(w,abs(Xof).^2)
%     xlim([0 nyq])
%     ylim([0 10])
    nyq=.5/(mean(diff(time)));
    xof(:)=gaussmf(time,[time(sv),time(indx_spc)]);
    w0=4;
    w=-nyq:w0:nyq;
    Xof=xof(1)*exp(-1i*w*1);
    for n=2:size(xof,2)
    Xof=Xof(n-1)+xof(n)*exp(-1i*w*n);
    end
    nop=size(peaks,2);
    delta_t=mean(diff(time));
    max_freq=1./(2*delta_t);
    delta_f=1/time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    
    figure('outerposition',[1923+563 233 576 513])
    plot(fqdata,abs(freq_data).^2)
    t=sprintf('with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*100);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,2500])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('dtgg_%i_pk_%s_fft',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(3)
else
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
    peaks(indx_mul+200)=1;
    figure('outerposition',[1923 233 576 513])
    plot(time,peaks)
    t=sprintf('signal with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*100);
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
    ft=sprintf('dtgg_%i_pk_%s',user_def,sig);
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
    
    figure('outerposition',[1923+563 233 576 513])
    plot(fqdata,abs(freq_data).^2)
    t=sprintf('with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*100);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,2500])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('dtgg_%i_pk_%s_fft',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(3)
end
