function []=fft_simulation_dt(user_def,sv,ylx,ns)
if ns==1
    nfv=(1/10);
    pkv=0;%(5/10);
    tnl=0;%-4;
    tnh=0;%4;
    snl=0;%-1;
    snh=0;%4;
    noise=20*rand(1,1024)*nfv;
    %     noise_string='nnftnsn';
    noise_string='gauss_nf';
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
        sp=gaussmf(nvec,[sv+randi([snl snh],1),indx_mul(n)+200])*20;%+randi([snl snh],1)
        peaks=peaks+sp;
    end
    for n=1:size(nvec,2)
        if peaks(n)<=.1*20
            peaks(n)=peaks(n)+noise(n);
        else
            peaks(n)=peaks(n)-rand(1)*pkv*20;
        end
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%i',sv);
    %     figure('outerposition',[1923 233 576 513])
    figure
    %     peaks=peaks/(max(peaks));
    plot(nvec,peaks,'b')
    t=sprintf('signal with %i peaks spaced by %i s}',user_def, indx_spc);
    r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);
    s=sprintf('simulated with gaussian peaks, %s = %s s}','$$\sigma$$',sig);
    ti=['\makebox[4in][c]{',t];
    th=['\makebox[4in][c]{',r];
    tj=['\makebox[4in][c]{',s];
    title({ti,th,tj},'interpreter','latex')
    [p lp]=findpeaks(peaks(peaks>15));
    rectfl=find(peaks==p(1),1,'first')-10;
    rectfh=find(peaks==p(end),1,'last')+8;

%     rectfl=find(peaks==p,1,'first')-10;
%     rectfh=find(peaks>=19.5,1,'last')+8;
    
    
    ylim([0 22])
    yticks([nfv*20 20])
    %     xticks([0 rectfl+10 rectfh-9 1023])
    xticks([0 rectfl+9 rectfh-9 1023])
    xticklabels({'0',[num2str(rectfl+9),'      '],['      ',num2str(rectfh-9)],'1023'})
    xlim([0 1024])
    xlabel('time (s)')
    ylab=ylabel({'return', 'signal'},'interpreter','latex');
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-90 22/2])
    
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    
    sig(sig=='.')='_';
    ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    
    nop=size(peaks,2);
    %     delta_t=mean(diff(time));
    delta_t=1;
    max_freq=1./(2*delta_t);
    %     delta_f=1/time(end);
    delta_f=1/1024;
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    
    %         figure('outerposition',[1923+563 233 576 513])
    figure
    plot(fqdata,abs(freq_data).^2,'b')
    t=sprintf('with %i peaks spaced by %i s}',user_def, indx_spc);
    r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);
    
    ti=['\makebox[4in][c]{',t];
    ri=['\makebox[4in][c]{',r];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ri,ti},'interpreter','latex')
    
    xlim([0,max_freq])
    ylim([0,ylx])
    prange=2:15;
    pknum=prange(end);
    [fftpeaks,fftloc]=findpeaks(abs(freq_data(512:end)).^2);
    [mxpks,mxloc]=sort(fftpeaks,'descend');
    %     hold on
    %     plot(fqdata(511+fftloc(mxloc(1:pknum))),mxpks(1:3),'k*')
    %     hold off
    %     cntrs=sort(fqdata(511+fftloc(mxloc(1:pknum)),'descend'));
    pktrs=sort(mxpks(prange),'ascend');
    yt=[];
        ytl=[];
        pktrs([2])=[];
        pktrs=pktrs([10 end]);
    for locloop=1:2
        smxy=sprintf('%2.2e',pktrs(locloop));
        strmxy=sprintf('%s%s10^%s',smxy(1:3),'\times',smxy(end));
        yt=[yt pktrs(locloop)];
        ytl{1,locloop}=strmxy;
    end
    hval=5.6e5;
    sylx=sprintf('%2.2e',hval);
    strylx=sprintf('%s%s10^%s',sylx(1:3),'\times',sylx(end));
             ytl{1,end+1}=strylx;
             yt=[yt hval];
    yticks(yt)
    yticklabels(ytl)
    xlabel('frequency (Hz)')
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-0.04 ylx/2-5000])
    ylab=ylabel('power');
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-0.04 ylx/2])
    
    
    ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i_fft',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
%     pause(1)
end
if sv~=0 && ns~=1
    set_plot_defaults
    close all
    % user_def=3;
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs\gauss';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs\gauss';
    time=linspace(0,.25,1024);
    
    nvec=(0:1023);
    peaks=zeros(size(nvec));
    indx_spc=20;
    indx_mul=[];
    %     peaks=zeros(size(time));
    %     indx_spc=find(time<=(1/200),1,'last');
    %     indx_mul=[];
    zgaus=gaussmf(nvec,[sv,100]);
    for n=1:user_def
        indx_mul=[indx_mul n*indx_spc];
        sp=gaussmf(nvec,[sv,indx_mul(n)+200])*20;
        peaks=peaks+sp;
    end
    % indx_mul=indx_mul+200;
    % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
    % peaks=peaks+sp;
    sig=sprintf('%i',sv);
    %     figure('outerposition',[1923 233 576 513])
    figure
    rectfl=find(peaks>=20,1,'first')-10;
    rectfh=find(peaks>=20,1,'last')+8;
    plot(nvec,peaks,'b',nvec,zgaus,'r')
    t=sprintf('signal with %i peaks spaced by %i s}',user_def, indx_spc);
    s=sprintf('simulated with gaussian peaks, %s = %s s}','$$\sigma$$',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
    ylim([0 22])
    yticks([1 20])
    %     xticks([0 rectfl+10 rectfh-9 1023])
    xticks([0 rectfl+10 rectfh-9 1023])
    xticklabels({'0','220      ',['      ',num2str(rectfh-9)],'1023'})
    xlim([0 1024])
    xlabel('time (s)')
    ylab=ylabel({'return', 'signal'},'interpreter','latex');
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-90 22/2])
    text(1000,17,{'\makebox[3in][l]{$$gauss\left(\frac{t}{\sigma}\right)\ast comb\left(\frac{t}{T}\right)$$}',...
        '\makebox[3in][l]{$$\times rect\left(\frac{t}{U}\right)$$}'},'Interpreter','latex','color','blue')
    text(600,2,'$$gauss\left(\frac{t}{\sigma}\right)$$','Interpreter','latex','color','red')
    
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    %legend('gauss(t/\sigma)\astcomb(t/T)\timesrect(t/U)','gauss(t/\sigma)','location','best')
    
    
    sig(sig=='.')='_';
    ft=sprintf('wr_pk%i_sg%s',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    
    nop=size(peaks,2);
    %     delta_t=mean(diff(time));
    delta_t=1;
    max_freq=1./(2*delta_t);
    %     delta_f=1/time(end);
    delta_f=1/1024;
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    gausfft=fftshift(fft(zgaus,nop,2),2);
    %     figure('outerposition',[1923+563 233 576 513])
    figure
    plot(fqdata,abs(freq_data).^2,'b',fqdata,4e4*abs(gausfft).^2,'r')
    t=sprintf('with %i peaks spaced by %i s}',user_def, indx_spc);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    xlim([0,max_freq])
    ylim([0,ylx])
    pknum=3;
    [fftpeaks,fftloc]=findpeaks(abs(freq_data(512:end)).^2);
    [mxpks,mxloc]=sort(fftpeaks,'descend');
    %     hold on
    %     plot(fqdata(511+fftloc(mxloc(1:pknum))),mxpks(1:3),'k*')
    %     hold off
    %     cntrs=sort(fqdata(511+fftloc(mxloc(1:pknum)),'descend'));
    pktrs=sort(mxpks(1:pknum),'ascend');
    yt=[];%0;
    ytl{1,1}=[];%'0';
    for locloop=1:pknum
        smxy=sprintf('%2.2e',pktrs(locloop));
        strmxy=sprintf('%s%s10^%s',smxy(1:3),'\times',smxy(end));
        yt=[yt pktrs(locloop)];
        ytl{1,locloop+1}=strmxy;
    end
    hval=2.2619e+06;
    sylx=sprintf('%2.2e',hval);
    strylx=sprintf('%s%s10^%s',sylx(1:3),'\times',sylx(end));
%          ytl{1,end+1}=strylx;
%          yt=[yt hval];
    yticks(yt)
    yticklabels(ytl(2:end))
    xlabel('frequency (Hz)')
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-0.04 ylx/2-5000])
    ylab=ylabel('power');
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-0.04 ylx/2-5000])
    %     legend('((2\pi\sigma^2)^{1/2}U/Tgauss(2\pi\sigmaf)\timescomb(Tf)\astsinc(Uf))^2','((2\pi\sigma^2)^{1/2}gauss(2\pi\sigmaf))^2\times100','location',[.209 .6798 .7839 .1393])
    text(0.37,1e6,{'\makebox[3in][l]{$$(\sqrt{2\pi\sigma^2}TU gauss\left(2\pi\sigma f\right)$$}',...
        '\makebox[3in][l]{$$\times comb\left(Tf\right)\ast sinc\left(Uf\right))^2$$}'},'Interpreter','latex','color','blue')
    line([0.09, 0.055],[9e5,5.5e5],'color','blue')
    text(0.32,2e5,'$$(\sqrt{2\pi\sigma^2}gauss\left(2\pi\sigma f\right))^2\times U^2$$','Interpreter','latex','color','red')
    %     line([0.075, 0.01],[4.3e4, 4.0e4],'color','red')
%     yticks([1.0e5 9.3e5 2.2e6])
%     yticklabels({'1.0\times10^5','9.3\times10^5','2.2\times10^6'})

    ft=sprintf('wr_pk%i_sg%s_fft',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    %     pause(1)
    %% pks no noise
elseif sv==0 && ns~=1
    sig='0';
    od='C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs';
    ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
    close all
    time=linspace(0,.25,1024);
    nvec=(0:1023);
    peaks=zeros(size(nvec));
    indx_spc=20;
    indx_mul=[];
    for n=1:user_def
        indx_mul=[indx_mul n*indx_spc];
    end
    peaks(indx_mul+200)=20;
    %     figure('outerposition',[1923 233 576 513])
    rectfl=find(peaks>0,1,'first')-10;
    rectfh=find(peaks>0,1,'last')+9;
    rect=zeros(size(peaks));
    rect(rectfl:rectfh)=1;
    disp(size(rect(rect==1)))
    figure
    plot(0:1023,peaks,'b',0:1023,rect,'r')
    t=sprintf('signal with %i peaks spaced by %i s}',user_def,indx_spc);
    s=sprintf('simulated with gaussian peaks, %s = %s s}','$$\sigma$$',sig);
    ti=['\makebox[4in][c]{',t];
    tj=['\makebox[4in][c]{',s];
    title({ti,...
        tj},'interpreter','latex')
    ylim([0 22])
    yticks([0 20])
    %     xticks([0 rectfl+10 rectfh-9 1023])
    xticks([0 rectfl+10 rectfh-9 1023])
    xticklabels({'0','220      ',['      ',num2str(rectfh-9)],'1023'})
    xlim([0 1024])
    xlabel('time (s)')
    ylab=ylabel({'return', 'signal'},'interpreter','latex');
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-90 22/2])
    
    %     legend('comb(t/T) \times rect(t/U)','rect(t/U)','location','east')
    text(725,18,'$$comb\left(\frac{t}{T}\right) \times rect\left(\frac{t}{U}\right)$$','Interpreter','latex','color','blue')
    text(600,2,'$$rect\left(\frac{t}{U}\right)$$','Interpreter','latex','color','red')
    %
    % set(gcf,'outerposition',[1923 233 576 513])
    % set(gcf,'outerposition',[1923+576 233 576 513])
    sig(sig=='.')='_';
    ft=sprintf('gg_%i_pk_%s_cr',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    
    nop=size(peaks,2);
    %     delta_t=mean(diff(time));
    delta_t=1;
    max_freq=1./(2*delta_t);
    %     delta_f=1/time(end);
    delta_f=1/1024;
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fft(peaks,nop,2),2);
    rectfft=fftshift(fft(rect,nop,2),2);
    %     figure('outerposition',[1923+563 233 576 513])
    figure
    plot(fqdata,abs(freq_data).^2,'b',fqdata,abs(rectfft).^2,'r')
    t=sprintf('with %i peaks spaced by %i s}',user_def,indx_spc);
    ti=['\makebox[4in][c]{',t];
    title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
        ti},'interpreter','latex')
    ylab=ylabel('power');
    
    
    xlim([0,max_freq])
    ylim([0,ylx])
    smxy=sprintf('%2.2e',max(abs(freq_data).^2));
    strmxy=sprintf('%s%s10^%s',smxy(1:3),'\times',smxy(end));
    sylx=sprintf('%2.2e',ylx-10000);
    strylx=sprintf('%s%s10^%s',sylx(1:3),'\times',sylx(end));
    yticks([0 max(abs(freq_data).^2)]);% ylx-10000]);
    yticklabels({'0', strmxy});%, strylx});
    xlabel('frequency (Hz)')
    set(get(gca,'ylabel'),'rotation',0)
    set(ylab,'pos',[-0.04 ylx/2-5000])
    %     legend('(U/T comb(f T) \ast sinc(f U))^2','U sinc(f U)','location','best')
    text(0.325,4.5e4,'$$(TU comb\left(Tf\right) \ast sinc\left(Uf\right))^2$$','Interpreter','latex','color','blue')
    line([0.325, 0.3],[4.3e4, 4.1e4],'color','blue')
    text(0.075,4.5e4,'$$(U sinc(Uf))^2$$','Interpreter','latex','color','red')
    line([0.075, 0.01],[4.3e4, 3.8e4],'color','red')
    %
    ft=sprintf('gg_%i_pk_%s_fft_cr',user_def,sig);
    savefig(fullfile(od,[ft, '.fig']));
    saveas(gcf,fullfile(od,[ft,'.png']));
    savefig(fullfile(ld,[ft, '.fig']));
    saveas(gcf,fullfile(ld,[ft,'.png']));
    pause(1)
end
