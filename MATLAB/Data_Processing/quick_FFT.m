

function [frequency, power, fft_data, fft_frequency] = quick_FFT(time,data)

nop = length(data);
delta_t = mean(diff(time));
max_freq = 1./(2*delta_t);
delta_f = 1/time(end);
fqdata = (-nop/2:nop/2-1).*delta_f;
freq_data = fftshift(fft(data,nop,2),2);

fft_data = freq_data;

frequency = fqdata;
fft_frequency = frequency;
power = abs(freq_data).^2;

% subplot(2,1,1)
% plot(time,data)
% title('Insect: Time Domain','fontsize',16)
% xlabel('Time (s)','fontsize',14)
% ylabel('Range(m)','fontsize',14)
% % set(gca,'YDir','normal')
% % set(gca,'XDir','normal')

% subplot(2,1,2)
% plot(frequency,power)
% xlabel('Frequency (Hz)','fontsize',14)
% ylabel('Power','fontsize',14)
% % set(gca,'YDir','normal')
% % set(gca,'XDir','normal')

  %xlim([0 2000])
%  ylim([0 1000])

