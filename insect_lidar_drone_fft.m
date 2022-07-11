% insect_lidar_drone_fft | Author: Liz Rehbein | Updated: 05-11-2019
% Perform a fast fourier transform across pulse number for every
% range bin of data. Use by running on processed data from a given
% day folder. You must be in that directory to run the script.

load('Volumes\Insect Lidar\Data_2020\2020-07-21\GroundPhantom-105336');

fourier = fft(adjusted_data_decembercal(2).normalized_data(13,:));
nop = 1024;
delta_t=mean(diff(adjusted_data_decembercal(2).time));  %difference in pul
max_freq=1./(2*delta_t);
delta_f=1/adjusted_data_decembercal(2).time(end);
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_data=fftshift(fourier); %fftshift(fft(positive_data,nop,2),2); %fix to get array
figure(1);
plot(fqdata,abs(freq_data));
%plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
xlabel('frequency (Hz)');
ylabel('power (arb)');
%title(sprintf('On file %i of 166', x));
xlim([0 2200])
ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])

% % THIS SECTION FOR TEST DATA ONLY
% fols=dir(fullfile(pwd));
% fols=fols(~ismember({fols.name},{'.','..','fftevents'}));
% 
% if exist('D:\Data-Test\2016-06-08\processed_data\ffteventsmat','file')~=0
%     load('D:\Data-Test\2016-06-08\processed_data\fftevents.mat');
%     int=size(fftevents,2);
% else
%     mkdir classification
%     int=0;
% end
% 
% load('I:\Data_Test\2016-06-08\processed_data\testdata'); 
% for x = 1:size(testdata,2)
%     fourier_array = fft(testdata(x).normalized_data);
%     nop = 1024;
%     delta_t=mean(diff(testdata(x).time));  %difference in pulse timing
%     max_freq=1./(2*delta_t);
%     delta_f=1/testdata(x).time(end);
%     fqdata=(-nop/2:nop/2-1).*delta_f;
%     freq_data=fftshift(fourier_array); %fftshift(fft(positive_data,nop,2),2); %fix to get array
%     figure(1);
%     plot(fqdata,abs(freq_data));
%     plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
%     xlabel('frequency (Hz)');
%     ylabel('power (arb)');
%     title(sprintf('On file %i of 166', x));
%     xlim([0 2200])
%     ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
%     determine likelihood of insect
%     figure(2)
%     image(testdata(x).normalized_data);
%     isinsect=input('is this an insect (y/n/m)? ','s');
% end
