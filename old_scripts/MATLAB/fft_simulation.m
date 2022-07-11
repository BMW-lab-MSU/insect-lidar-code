function []=fft_simulation(user_def)
od='C:\Martin_Tauc\MS Research\publications\wing-beat modulation theory\figures';
% ld='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs';
close all
time=linspace(0,.25,1024);
peaks=zeros(size(time));
indx_spc=find(time<=(1/200),1,'last');
indx_mul=[];

    for n=1:user_def
        indx_mul=[indx_mul (n*indx_spc)];
        sp=gaussmf(time,[time(2),indx_mul(n)+200])*20;%+randi([snl snh],1)
        peaks=peaks+sp;
    end
    
    
% for n=1:user_def
%     indx_mul=[indx_mul n*indx_spc];
% end
set_plot_defaults
peaks(indx_mul+200)=1;
figure('outerposition',[1923 233 576 513])
plot(time,peaks,'b')
t=sprintf('signal with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*100);
ti=['\makebox[4in][c]{',t];
title({ti,...
    '\makebox[4in][c]{simulated with single points at value 1}'},'interpreter','latex')
ylim([0 1.1])
xlabel('time (s)')
ylabel('return signal (arb)')
% set(gcf,'outerposition',[1923 233 576 513])
% set(gcf,'outerposition',[1923+576 233 576 513])
ft=sprintf('pp_%i_pk',user_def);
savefig(fullfile(od,[ft, '.fig']));
saveas(gcf,fullfile(od,[ft,'.png']));
% savefig(fullfile(ld,[ft, '.fig']));
% saveas(gcf,fullfile(ld,[ft,'.png']));

nop=size(peaks,2);
delta_t=mean(diff(time));
max_freq=1./(2*delta_t);
delta_f=1/time(end);
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_data=fftshift(fft(peaks,nop,2),2);

figure('outerposition',[1923+563 233 576 513])
plot(fqdata,abs(freq_data).^2,'b')
t=sprintf('with %i peaks spaced by %2.2f ms}',user_def, mean(diff(time(indx_mul)))*100);
ti=['\makebox[4in][c]{',t];
title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
    ti},'interpreter','latex')
xlim([0,max_freq])
ylim([0,100])
xlabel('frequency (Hz)')
ylabel('power')

ft=sprintf('pp_%i_pk_fft',user_def);
savefig(fullfile(od,[ft, '.fig']));
saveas(gcf,fullfile(od,[ft,'.png']));
% savefig(fullfile(ld,[ft, '.fig']));
% saveas(gcf,fullfile(ld,[ft,'.png']));
pause(3)
