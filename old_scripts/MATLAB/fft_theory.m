function []=fft_theory()
sv=2;
set_plot_defaults
close all
user_def=10;
time=linspace(0,.25,1024);
peaks=zeros(size(time));
indx_spc=time(20+1);
indx_mul=[];
%     peaks=zeros(size(time));
%     indx_spc=find(time<=(1/200),1,'last');
%     indx_mul=[];
zgaus=gaussmf(time,[time(sv+1),time(100+1)]);
for n=1:user_def
    indx_mul=[indx_mul n*indx_spc];
    sp=gaussmf(time,[time(sv+1),indx_mul(n)+time(200+1)])*time(20+1);
    peaks=peaks+sp;
end

sig=sprintf('%2.4f',time(sv+1));
figure
rectfl=find(peaks>=time(20+1),1,'first')-10;
rectfh=find(peaks>=time(20+1),1,'last')+8;
subplot(4,1,[1 2])
plot(time,peaks,'b',time,time(20+1)*zgaus,'r--')
t=sprintf('signal with %i peaks spaced by %2.3f s}',user_def, indx_spc);
s=sprintf('simulated with gaussian peaks, %s = %s s}','$$\sigma$$',sig);
ti=['\makebox[4in][c]{',t];
% tj=['\makebox[4in][c]{',s];
% title({ti,...
%     tj},'interpreter','latex')
ylim([0 time(20+1+5)])
yticks([0 time(20+1)])
yticklabels({'0',sprintf('%1.3f',time(20+1))})

xticks([0 time(rectfl+10+1) time(rectfh-9+1) time(1023)])
xticklabels({num2str(time(1)),sprintf('%2.2f',time(rectfl+10+1)),['      ',sprintf('%2.2f',time(rectfh-9+1))],sprintf('%2.2f',time(end))})
xlim([time(1) time(1023)])
xlabel('time (s)')
ylab=ylabel({'return', 'signal'},'interpreter','latex');
text(time(1000+1),time(17+1),{'\makebox[3in][l]{$$gauss\left(\frac{t}{\sigma}\right)\ast comb\left(\frac{t}{T}\right)$$}',...
    '\makebox[3in][l]{$$\times rect\left(\frac{t}{U}\right)$$}'},'Interpreter','latex','color','blue')
text(time(200+1),time(23)+.0001,'$$gauss\left(\frac{t}{\sigma}\right)\times T$$','Interpreter','latex','color','red')
line([time(110+1), time(140+1)],[time(20+1),time(23)-.0001],'color','red','linestyle','--')
% format_plot(gcf,gca);

ylx=.0625;
nop=size(peaks,2);
delta_t=mean(diff(time));
max_freq=1./(2*delta_t);
delta_f=1/time(end);
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_data=fftshift(fft(peaks,nop,2),2);
gausfft=fftshift(fft(zgaus,nop,2),2);
%     figure('outerposition',[1923+563 233 576 513])
subplot(4,1,[3 4])
plot(fqdata,abs(freq_data).^2,'b',fqdata,(time(21)*10)^2*abs(gausfft).^2,'r--')
t=sprintf('with %i peaks spaced by %2.3f s}',user_def, indx_spc);
ti=['\makebox[4in][c]{',t];
% title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
%     ti},'interpreter','latex')
xlim([0,max_freq])
ylim([0,ylx])
pknum=3;
[fftpeaks,fftloc]=findpeaks(abs(freq_data(512:end)).^2);
[mxpks,mxloc]=sort(fftpeaks,'descend');

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
% yticklabels(ytl(2:end))
xticks([0 1/time(20+1) 2/time(20+1) 3/time(20+1) 0.5/time(2)])
xticklabels({'0' '200' '400' '600' '2046'})
xlabel('frequency (Hz)')
ylab=ylabel('power');

%     legend('((2\pi\sigma^2)^{1/2}U/Tgauss(2\pi\sigmaf)\timescomb(Tf)\astsinc(Uf))^2','((2\pi\sigma^2)^{1/2}gauss(2\pi\sigmaf))^2\times100','location',[.209 .6798 .7839 .1393])
text(0.37*4088,.038,{'\makebox[3in][l]{$$(\sqrt{2\pi\sigma^2}TU gauss\left(2\pi\sigma f\right)$$}',...
    '\makebox[3in][l]{$$\times comb\left(Tf\right)\ast sinc\left(Uf\right))^2$$}'},'Interpreter','latex','color','blue')
line([0.09*4088, 0.055*4088],[.0388,.03],'color','blue')
text(0.28*4088,.01,'$$(\sqrt{2\pi\sigma^2}gauss\left(2\pi\sigma f\right))^2\times U^2$$','Interpreter','latex','color','red')
% format_plot(gcf,gca);

%     line([0.075, 0.01],[4.3e4, 4.0e4],'color','red')
%     yticks([1.0e5 9.3e5 2.2e6])
%     yticklabels({'1.0\times10^5','9.3\times10^5','2.2\times10^6'})


