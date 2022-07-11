function []=plots_for_pub(td)
n=25;
subplot(4,1,[1 2])
plot(td(n).time,td(n).positive_data,'b')
xlim([0 max(td(n).time)])
xlabel('time (s)')
ylabel({'return', 'signal'},'interpreter','latex');

% nop=size(td(n).positive_data,2);
% delta_t=mean(diff(td(n).time));
% max_freq=1./(2*delta_t);
% delta_f=1/td(n).time(end);
% fqdata=(-nop/2:nop/2-1).*delta_f;
% freq_data=fftshift(fft(td(n).positive_data,nop,2),2);
subplot(4,1,[3 4])
plot(td(n).frequency,abs(td(n).freq_data).^2,'b')
xlim([0 max(td(n).frequency)])
ylim([0 15])
xlabel('frequency (Hz)')
ylabel('power');

% format_plot(gcf,gca);

%     line([0.075, 0.01],[4.3e4, 4.0e4],'color','red')
%     yticks([1.0e5 9.3e5 2.2e6])
%     yticklabels({'1.0\times10^5','9.3\times10^5','2.2\times10^6'})


