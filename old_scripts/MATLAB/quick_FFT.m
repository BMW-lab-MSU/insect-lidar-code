function [frequency, power] = quick_FFT(time,data)

nop = length(data);
delta_t = mean(diff(time));
max_freq = 1./(2*delta_t);
delta_f = 1/time(end);
fqdata = (-nop/2:nop/2-1).*delta_f;
freq_data = fftshift(fft(data,nop,2),2);

frequency = fqdata;
power = abs(freq_data).^2;

subplot(2,1,1)
plot(time,data)

subplot(2,1,2)
plot(frequency,power)
xlim([0 2000])
ylim([0 1000])