% insect_lidar_fft_all | Author: Liz Rehbein | Updated: 05-11-2019
% Perform a fast fourier transform across pulse number for every
% range bin of data. Use by running on processed data from a given
% day folder. You must be in that directory to run the script.

%rewrite section to take in testdata.mat from 2016-06-08 very likely

% THIS SECTION FOR TEST DATA ONLY
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','fftevents'}));

if exist('D:\Data-Test\2016-06-08\processed_data\ffteventsmat','file')~=0
    load('D:\Data-Test\2016-06-08\processed_data\fftevents.mat');
    int=size(fftevents,2);
else
    mkdir classification
    int=0;
end

load('I:\Data_Test\2016-06-08\processed_data\testdata'); 
for x = 1:size(testdata,2)
    fourier_array = fft(testdata(x).normalized_data);
    nop = 1024;
    delta_t=mean(diff(testdata(x).time));  %difference in pulse timing
    max_freq=1./(2*delta_t);
    delta_f=1/testdata(x).time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fftshift(fourier_array); %fftshift(fft(positive_data,nop,2),2); %fix to get array
    figure(1);
    plot(fqdata,abs(freq_data));
    plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
    xlabel('frequency (Hz)');
    ylabel('power (arb)');
    title(sprintf('On file %i of 166', x));
    xlim([0 2200])
    ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
    determine likelihood of insect
    figure(2)
    image(testdata(x).normalized_data);
    isinsect=input('is this an insect (y/n/m)? ','s');
end

% %% THIS SECTION FOR UNPROCESSED DATA  
% fols=dir(fullfile(pwd));
% fols=fols(~ismember({fols.name},{'.','..','fftevents'}));
% 
% if exist('I:\Data_Test\2010-10-10\processed_data\ffteventsmat','file')~=0
%     load('I:\Data_Test\2010-10-10\processed_data\fftevents.mat');
%     int=size(fftevents,2);
% else
%     mkdir classification
%     int=0;
% end
% 
% % x = file numnber in fols, y = the datafile number in x, z = the range bin number in y
% for x=1:size(fols,1)
%     filename=fullfile(pwd,fols(x).name);
%     datafile=load(filename);
%     fn=fieldnames(datafile);
%     
%     for y=1:size(datafile.(fn{1}),2) %goes through each (pant,tilt) in a given (pan,tilt) file
%         % datafile.(fn{1})(y).fourier = fft(datafile.(fn{1})(y).normalized_data);
%         nop = size(datafile.(fn{:})(y).normalized_data,2);
%         fourier_grid = fft(datafile.(fn{:})(y).normalized_data,nop,2); %%do fft on each range bin for the 
%         %nop=size(fourier_grid,2); % number of pulses
%         for z=1:178 %178 % go through each range bin of fourier data
%              % shift around the data
%              delta_t=mean(diff(datafile.(fn{:})(y).time));  %difference in pulse timing
%              max_freq=1./(2*delta_t);
%              delta_f=1/datafile.(fn{:})(y).time(end);
%              fqdata=(-nop/2:nop/2-1).*delta_f;
%              freq_data=fftshift(fourier_grid(z,:)); %fftshift(fft(positive_data,nop,2),2); %fix to get array
% %              figure(1);
% %              plot(fqdata,(abs(fourier_grid(z,:))));
%              figure(1);
%              plot(fqdata,abs(freq_data));
%              %plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
%              xlabel('frequency (Hz)')
%              ylabel('power (arb)')
%              formatSpec = "Frequency spectrum using FFT algorithm of insect \n at pan: %.2f and tilt: %.2f and range %.4f meters. \n Filename: %s ";
%              title(sprintf(formatSpec, datafile.(fn{1})(y).pan, datafile.(fn{1})(y).tilt, datafile.(fn{1})(y).range(z), char(fn)),'Interpreter','none');
%              xlim([0 2200])
%              ylim([0 (max(abs(freq_data(100:end))))^.9])
%              %ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
%              
%              
%              %CHECK WHAT YOU ARE PLOTTING
%              figure(2)
%              imagesc(datafile.(fn{:})(y).normalized_data);
%              title('Normalized Data');
%              caxis([min(min(data.(fn{1})(y).normalized_data)) 0.3*max(max(data.(fn{1})(y).normalized_data))]);
%              colorbar
%              
%              figure(4)
%              imagesc(datafile.(fn{:})(y).data);
%              title('Non-normalized Data');
%              colorbar
%             
%              figure(3)
%              plot(datafile.(fn{:})(y).normalized_data(z,:));
%              xlabel('Pulse Number')
%              ylabel('power [arb]');
%              xlim([0 1024]);
%              ylim([0 (max(abs(datafile.(fn{:})(y).normalized_data(z,:))))^1.1]);
%              title(sprintf('Normalized Signal Return'));
%              
%              % determine likelihood of insect
%              isinsect=input('is this an insect (y/n/m)? ','s');
%              % store insect or non insect based on input
%              % only store some info for non-insects
%              % store more info for insects 
%              if strcmp(isinsect,'y') || strcmp(isinsect,'m')
%                 int=int+1;
%                 fftevents(int).filename=fn;
%                 fftevents(int).path=filename;
%                 fftevents(int).tilt=datafile.(fn{1}).tilt;
%                 fftevents(int).pan=datafile.(fn{1}).pan;
%                 %fftevents(int).normdata=datafile.(fn{1}).normalized_data;
%                 fftevents(int).fftshifted=freq_data;
%                 if strcmp(isinsect,'y')
%                     fftevents(int).classification = 1;
%                 else % if strcmp(isinsect,'m')
%                     fftevents(int).classification = 0;
%                 end
%              elseif strcmp(isinsect,'n') % not an insect
%                  %do nothing
%              else % typo
%                   disp('invalid choice');
%              end
%              %save(fullfile(pwd,'classification','fftevents'),'fftevents', '-v7.3')
%         end
%         save(fullfile(pwd,'classification','fftevents'),'fftevents', '-v7.3')
%     end
%     
% end



