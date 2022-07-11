function []=fft_theory_peaknoise()
sv=2;
set_plot_defaults
close all
user_def=10;
time=linspace(0,.25,1024);
peaks=zeros(size(time));
indx_spc=time(20+1);
indx_mul=[];

zgaus=gaussmf(time,[time(sv+1),time(100+1)]);
for n=1:user_def
    indx_mul=[indx_mul n*indx_spc];
    sp=gaussmf(time,[time(sv+1),indx_mul(n)+time(200+1)])*time(20+1);
    peaks=peaks+sp;
end

        for n=1:size(time,2)
            if peaks(n)<0.004
                peaks(n)=peaks(n);
            else
                peaks(n)=peaks(n)-rand(1)*0.5*time(20+1);
            end
        end

figure
rectfl=find(peaks>=time(20+1),1,'first')-10;
rectfh=find(peaks>=time(20+1),1,'last')+8;
subplot(4,1,[1 2])
plot(time,peaks,'b')
ylim([0 time(20+1+5)])
yticks([0 time(20+1)/2 time(20+1)])
yticklabels({'0','0.0025' sprintf('%1.3f',time(20+1))})

xticks([0 time(rectfl+10+1) time(rectfh-9+1) time(1023)])
xticklabels({num2str(time(1)),sprintf('%2.2f',time(rectfl+10+1)),['      ',sprintf('%2.2f',time(rectfh-9+1))],sprintf('%2.2f',time(end))})
xlim([time(1) time(1023)])
xlabel('time (s)')
ylabel({'return', 'signal'},'interpreter','latex');

ylx=.035;
nop=size(peaks,2);
delta_t=mean(diff(time));
max_freq=1./(2*delta_t);
delta_f=1/time(end);
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_data=fftshift(fft(peaks,nop,2),2);
gausfft=fftshift(fft(zgaus,nop,2),2);
%     figure('outerposition',[1923+563 233 576 513])
subplot(4,1,[3 4])
plot(fqdata,abs(freq_data).^2,'b')
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

% yticks(yt)
yticks([abs(freq_data(find(fqdata<=2/time(20+1),1,'last'))).^2 abs(freq_data(find(fqdata<=1/time(20+1),1,'last'))).^2 0.035])
xticks([0 1/time(20+1) 2/time(20+1) 3/time(20+1) 0.5/time(2)])
line([1/time(20+1) 1/time(20+1)], [0 ylx],'Color','red','LineStyle',':')
line([2/time(20+1) 2/time(20+1)], [0 ylx],'Color','red','LineStyle',':')
line([3/time(20+1) 3/time(20+1)], [0 ylx],'Color','red','LineStyle',':')
xticklabels({'0' '200' '400' '600' '2046'})
xlabel('frequency (Hz)')
ylab=ylabel('power');

% format_plot(gcf,gca);

%     line([0.075, 0.01],[4.3e4, 4.0e4],'color','red')
%     yticks([1.0e5 9.3e5 2.2e6])
%     yticklabels({'1.0\times10^5','9.3\times10^5','2.2\times10^6'})


