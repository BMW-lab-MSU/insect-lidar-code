%% insect_lidar_fourier_analysis | 
% This function performs basic data analysis on pre-processed insect
% lidar data by performing a fourier transform on each range bin.
% Low frequency (non-physical)data are tossed out to help eliminate
% hard targets and other non-insect data. 
% Signficant peaks in power are identfied. The strength of these peaks 
% and the frequency at which they occur are saved.
% Author: Elizabeth Rehbein
% Last Modified: 17 October 2019

%% Author notes
% a p-value of <0.05 is the conventional theshold for declaring statistical significance
% matlab's fft function can be used on a vector a a matrix


%% scrap all this stuff and make it a function that you can run on a date of data
% want to laod in each file and be able to save to it
% or else could just save a fourier.mat for each day of data-that might be easiest

%%
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));

% x = file numnber in fols, y = the datafile number in x, z = the range bin number in y

for x=2 %:size(fols,1)
    filename=fullfile(pwd,fols(x).name);
    datafile=load(filename);
    fn=fieldnames(datafile);
    for y=42:44 %y=1:size(datafile.(fn{1}),2) %goes through each (pant,tilt) in a given (pan,tilt) file
        % datafile.(fn{1})(y).fourier = fft(datafile.(fn{1})(y).normalized_data);
        nop = size(datafile.(fn{:})(y).normalized_data,2);
        fourier_grid = fft(datafile.(fn{:})(y).normalized_data,nop,2); %%do fft on each range bin for the 
        %nop=size(fourier_grid,2); % number of pulses
        for z=1:178 % go through each range bin of fourier data
            % shift around the data
            delta_t=mean(diff(datafile.(fn{:})(y).time));  %difference in pulse timing
            max_freq=1./(2*delta_t);
            delta_f=1/datafile.(fn{:})(y).time(end);
            fqdata=(-nop/2:nop/2-1).*delta_f;
            freq_data=fftshift(fourier_grid(z),2) %fftshift(fft(positive_data,nop,2),2);
            % find significance value
            % search for peaks above significance value
            % save power and frequency for each significant peak
        end
        
    end
end

% %% do fft on positive_data
%         nop=size(positive_data,2);
%         delta_t=mean(diff(data.(fn{:})(manual_insects(n).y).time));
%         max_freq=1./(2*delta_t);
%         delta_f=1/data.(fn{:})(manual_insects(n).y).time(end);
%         fqdata=(-nop/2:nop/2-1).*delta_f;
%         freq_data=fftshift(fft(positive_data,nop,2),2);
%         [maxv,maxi]=findpeaks(abs(freq_data(513:end)).^2);
%         [tminv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
%         subplot(2,2,2)
%         plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
%         xlabel('frequency (Hz)')
%         ylabel('power (arb)')
%         title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at AMK Ranch on %s\nat a distance of %2.1f m', exact_time,data.(fn{:})(manual_insects(n).y).range(manual_insects(n).z)))
%         xlim([0 2200])
%         ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
% 
