% function [p,f]=fft_simulation_subplot(user_def,sv,ylx,ns)
%%
% if ns==1
ylx=1500;
ns=1;
for sv=1:4
for user_def=1:10
    nfv=(1/10);
    pkv=0;%(5/10);
    tnl=0;%-4;
    tnh=0;%4;
    snl=0;%-1;
    snh=0;%4;
    noise=rand(1,1024)*nfv;
%     noise_string='nnftnsn';
    noise_string='full_page_figs\gauss_nf';
    set_plot_defaults
    close all
    % user_def=3;
    od=fullfile('C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs',noise_string);
    ld=fullfile('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs',noise_string);
    time=linspace(0,.25,1024);
    nvec=(0:1023);
    peaks=zeros(size(nvec));
    indx_spc=20;
    indx_mul=[];
    %     peaks=zeros(size(time));
    %     indx_spc=find(time<=(1/200),1,'last');
    %     indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul (n*indx_spc)+randi([tnl tnh],1)];
        sp=gaussmf(nvec,[sv+randi([snl snh],1),indx_mul(n)+200]);%+randi([snl snh],1)
        peaks=peaks+sp;
    end
    for n=1:size(nvec,2)
        if peaks(n)<=0.1
            peaks(n)=peaks(n)+noise(n);
        else
%             peaks(n)=peaks(n)-rand(1)*pkv;
        end
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%i',sv);
    %     figure('outerposition',[1923 233 576 513])
    figure(1);
%     peaks=peaks/(max(peaks));
    subplot(5,2,(user_def*sv))
    plot(nvec,peaks);
    t=sprintf('signal with %i peaks spaced by %i s}',user_def, indx_spc);
    r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);
    s=sprintf('simulated with gaussian peaks, sigma = %s s}',sig);
    ti=['\makebox[4in][c]{',t];
    th=['\makebox[4in][c]{',r];
    tj=['\makebox[4in][c]{',s];
    title({ti,th,tj},'interpreter','latex')
    ylim([0 1.1])
    xlabel('time (s)')
    ylabel('return signal (arb)')
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    
    sig(sig=='.')='_';
    ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
    
    nop=size(peaks,2);
    %     delta_t=mean(diff(time));
    delta_t=1;
    max_freq=1./(2*delta_t);
    %     delta_f=1/time(end);
    delta_f=1/1024;
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    
%         figure('outerposition',[1923+563 233 576 513])
    figure(2);
    subplot(5,2,(user_def*sv))
    plot(fqdata,abs(freq_data).^2);
    t=sprintf('with %i peaks spaced by %i s}',user_def, indx_spc);
    r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);

    ti=['\makebox[4in][c]{',t];
    ri=['\makebox[4in][c]{',r];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ri,ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,ylx])
    xlabel('frequency (Hz)')
    ylabel('power')
    ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i_fft',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
%     pause(1)
end
end
% %%
% if sv~=0 && ns~=1
%     set_plot_defaults
%     close all
%     % user_def=3;
%     od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs\gauss';
%     ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs\gauss';
%     time=linspace(0,.25,1024);
%     
%     nvec=(0:1023);
%     peaks=zeros(size(nvec));
%     indx_spc=20;
%     indx_mul=[];
%     %     peaks=zeros(size(time));
%     %     indx_spc=find(time<=(1/200),1,'last');
%     %     indx_mul=[];
%     zgaus=gaussmf(nvec,[sv,100]);
%     for n=1:user_def
%         indx_mul=[indx_mul n*indx_spc];
%         sp=gaussmf(nvec,[sv,indx_mul(n)+200]);
%         peaks=peaks+sp;
%     end
%     % indx_mul=indx_mul+200;
%     % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
%     % peaks=peaks+sp;
%     sig=sprintf('%i',sv);
%     %     figure('outerposition',[1923 233 576 513])
%     figure
%     plot(nvec,peaks,'b')%,nvec,zgaus,'r')
%     t=sprintf('signal with %i peaks spaced by %i s}',user_def, indx_spc);
%     s=sprintf('simulated with gaussian peaks, sigma = %s s}',sig);
%     ti=['\makebox[4in][c]{',t];
%     tj=['\makebox[4in][c]{',s];
%     title({ti,...
%         tj},'interpreter','latex')
%     ylim([0 1.1])
%     xlabel('time (s)')
%     ylabel('return signal (arb)')
%     % set(gcf,'outerposition',[1923 233 576 513])
%     % set(gcf,'outerposition',[1923+576 233 576 513])
% %legend('gauss(t/\sigma)\astcomb(t/T)\timesrect(t/U)','gauss(t/\sigma)','location','best')
%     
%     
%     sig(sig=='.')='_';
%     ft=sprintf('pk%i_sg%s',user_def,sig);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
%     
%     nop=size(peaks,2);
%     %     delta_t=mean(diff(time));
%     delta_t=1;
%     max_freq=1./(2*delta_t);
%     %     delta_f=1/time(end);
%     delta_f=1/1024;
%     fqdata=(-nop/2:nop/2-1).*delta_f;
%     freq_data=fftshift(fft(peaks,nop,2),2);
%     gausfft=fftshift(fft(zgaus,nop,2),2);
%     %     figure('outerposition',[1923+563 233 576 513])
%     figure
%     plot(fqdata,abs(freq_data).^2,'b')%,fqdata,abs(gausfft).^2*100,'r')
%     t=sprintf('with %i peaks spaced by %i s}',user_def, indx_spc);
%     ti=['\makebox[4in][c]{',t];
%     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
%         ti},'interpreter','latex')
%     xlim([0,max_freq])
%     ylim([0,ylx])
%     xlabel('frequency (Hz)')
%     ylabel('power')
%     
% %     legend('((2\pi\sigma^2)^{1/2}U/Tgauss(2\pi\sigmaf)\timescomb(Tf)\astsinc(Uf))^2','((2\pi\sigma^2)^{1/2}gauss(2\pi\sigmaf))^2\times100','location',[.209 .6798 .7839 .1393])
% 
%     
%     ft=sprintf('pk%i_sg%s_fft',user_def,sig);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
% %     pause(1)
% elseif sv==0 && ns~=1
%     sig='0';
%     od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
%     ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
%     close all
%     time=linspace(0,.25,1024);
%     nvec=(0:1023);
%     peaks=zeros(size(nvec));
%     indx_spc=20;
%     indx_mul=[];
%     for n=1:user_def
%         indx_mul=[indx_mul n*indx_spc];
%     end
%     peaks(indx_mul+200)=1;
%     %     figure('outerposition',[1923 233 576 513])
%     rectfl=find(peaks>0,1,'first')-10;
%     rectfh=find(peaks>0,1,'last')+9;
%     rect=zeros(size(peaks));
%     rect(rectfl:rectfh)=1;
%     disp(size(rect(rect==1)))
%     figure
%     plot(0:1023,peaks,'b',0:1023,rect,'r')
%     t=sprintf('signal with %i peaks spaced by %i s}',user_def,indx_spc);
%     s=sprintf('simulated with gaussian peaks, sigma = %s s}',sig);
%     ti=['\makebox[4in][c]{',t];
%     tj=['\makebox[4in][c]{',s];
%     title({ti,...
%         tj},'interpreter','latex')
%     ylim([0 1.2])
%     
%     xlabel('time (s)')
%     ylabel('return signal (arb)')
%     
%     legend('comb(t/T) \times rect(t/U)','rect(t/U)','location','east')
%     
%     
%     % set(gcf,'outerposition',[1923 233 576 513])
%     % set(gcf,'outerposition',[1923+576 233 576 513])
%     sig(sig=='.')='_';
%     ft=sprintf('gg_%i_pk_%s_cr',user_def,sig);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
%     
%     nop=size(peaks,2);
%     %     delta_t=mean(diff(time));
%     delta_t=1;
%     max_freq=1./(2*delta_t);
%     %     delta_f=1/time(end);
%     delta_f=1/1024;
%     fqdata=(-nop/2:nop/2-1).*delta_f;
%     freq_data=fftshift(fft(peaks,nop,2),2);
%     rectfft=fftshift(fft(rect,nop,2),2);
%     %     figure('outerposition',[1923+563 233 576 513])
%     figure
%     plot(fqdata,abs(freq_data).^2,'b',fqdata,abs(rectfft),'r')
%     t=sprintf('with %i peaks spaced by %i s}',user_def,indx_spc);
%     ti=['\makebox[4in][c]{',t];
%     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
%         ti},'interpreter','latex')
%     xlim([0,max_freq])
%     ylim([0,ylx])
%     xlabel('frequency (Hz)')
%     ylabel('power')
%     
%     legend('(U/T comb(f T) \ast sinc(f U))^2','U sinc(f U)','location','best')
%     
%     ft=sprintf('gg_%i_pk_%s_fft_cr',user_def,sig);
%     savefig(fullfile(od,[ft, '.fig']));
%     saveas(gcf,fullfile(od,[ft,'.png']));
%     savefig(fullfile(ld,[ft, '.fig']));
%     saveas(gcf,fullfile(ld,[ft,'.png']));
%     pause(1)
% end
