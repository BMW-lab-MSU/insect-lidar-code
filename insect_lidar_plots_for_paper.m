whichfile=54;
rangebin=8;

figure(1)
imagesc(adjusted_data_decembercal(whichfile).normalized_data)

figure(2)
x=[0 1024]; y=[132 0];
imagesc(x,y,adjusted_data_decembercal(whichfile).normalized_data);
yticks([12 32 52 72 92 112]),yticklabels({'120','100','80','60','40','20','0'}),
set(gca,'FontSize',18)
title(["Insect at Hyalite Creek on 2020-09-20", 
        "at 19:41:24 pan 2.31"+ char(176) + " tilt -2.99" + char(176)])
ylabel('Range (m)')
xlabel('Pulse Number');
colorbar


%Time series plot
figure(3)
plot(adjusted_data_decembercal(whichfile).time,adjusted_data_decembercal(whichfile).normalized_data(rangebin,:));
title(["Hard target signal at a distance of 72.67 m",
        "from 2016-06-08 at 18:49:09 pan 39.48" + char(176) + "tilt 1.49" + char(176)]);
xlabel('time (s)');
ylabel('normalized detected signal (arb)');
set(gca,'FontSize',18)
xlim([0 .25]);


%Frequency domain plot
figure(4)
bin=rangebin;
nop = 1024; % number of pulses
delta_t=mean(diff(adjusted_data_decembercal(whichfile).time));  %difference in pulse timing
mawhichfile_freq=1./(2*delta_t); % largest possible frequency
delta_f=1/adjusted_data_decembercal(whichfile).time(end);
fqdata=(-nop/2:nop/2-1).*delta_f; % gives the range of possible frequencies
freq_data=fftshift(fft(adjusted_data_decembercal(whichfile).normalized_data(bin,:),nop,2),2); % perform fft and shift frequencies, gives the power in the signal of each available frequency
plot(fqdata,abs(freq_data),'LineWidth',.5)
title(["Frequency spectrum of hard target signal",
        "from 2016-06-08 at 18:49:09 pan 39.48"+ char(176) + "tilt 1.49" + char(176)]);
xlabel('frequency (Hz)');
ylabel('power (arb)');
xlim([0 2200])
%ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
set(gca,'FontSize',18,'color','w')
