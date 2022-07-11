function []=Insect_Lidar_Window(di)
%%
%if arguement is empty, prompt user for date
if nargin==0
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end


%set directory using date from above
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date,'\AdjustedData');
%pull adjusted_data
load(strcat(fulldir,'\adjusted_data.mat'));

%%
sigma=200;
freq_range_BEE=[10,100];

[a_d_y,a_d_x]=size(adjusted_data);
processed_data=struct('name',num2cell(zeros(a_d_y,a_d_x)),'event_counts',num2cell(zeros(a_d_y,a_d_x)));



%%
for m=1:a_d_y;
    [depth,number_of_points]=size(adjusted_data(m).raw_run);
    int_n=0;
    processed_data(m).event_counts = struct('depth',num2cell(zeros(1,1)),...
        'event',num2cell(zeros(1,1)),'time_domain',num2cell(zeros(1,1)),...
        'frequency_domain',num2cell(zeros(1,1)));
    x=1:number_of_points;
    muv=1:(2*sigma):number_of_points;
    for n=1:depth
        int_mu=0;
        for mu = muv
            Gauss=exp(-(x-mu).^2./(2.*(sigma.^2)));
            %choose values for now
%             m=4;
%             n=169;
            windowed_data=((adjusted_data(m).raw_run(n,:)).^2).*Gauss;
            %determine number of points within one event
%             [depth,number_of_points]=size(adjusted_data(m).run(n,:));
            %determine time data in one event
            pulse_time = (cell2mat(adjusted_data(m).data_info(10,...
                    4:(length(adjusted_data(m).data_info)))))*10^(-6);
            delta_time = mean(diff(pulse_time));
            pulse_spacing = round(delta_time / (154e-6));
            
            pulse_number = linspace(1,(number_of_points * pulse_spacing)...
                    + (1 - pulse_spacing),number_of_points);
            %find min, max, and delta time for fourier analysis
            max_time=pulse_time(number_of_points); 
            min_time=pulse_time(1); 
            %find max and delta frequency for fourier analysis
%             max_frequency=1/delta_time;
            delta_frequency=1/(max_time-min_time);
            %acuire frequency vector
            frequency=((-(number_of_points)/2)+.5:((number_of_points)/2)-.5)*(delta_frequency);
            %perform FFT and shift
            fourier_of_data=fft(windowed_data);
            shifted_fourier_nn=(abs(fftshift(fourier_of_data)./number_of_points));
            shifted_fourier = (shifted_fourier_nn)/max(shifted_fourier_nn);

            freq_start=find(frequency <= freq_range_BEE(1),1,'last');
            freq_end  =find(frequency <= freq_range_BEE(2),1,'last');

            noisep = mean(shifted_fourier(1:2000).^2);
            noiseSTDp = std(shifted_fourier(1:2000).^2);
            
            
            if (max(shifted_fourier(freq_start:freq_end)))^2-noisep > 15*noiseSTDp
                int_mu=int_mu+1;
                int_n=int_n+1;
                int_m=m;

%                 subplot(3,1,1)
%                 plot(x,Gauss,'b',x,adjusted_data(m).run(n,:),'r')
%                 subplot(3,1,2)
%                 plot(pulse_time,windowed_data,'b')
%                 xlim([pulse_time(mu-sigma) pulse_time(mu+sigma)])
%                 subplot(3,1,3)
%                 plot(frequency,shifted_fourier.^2,'b')
%                 xlim([freq_range_BEE(1),freq_range_BEE(2)])
%                 ylim([0 .75])
%                 pause()
                if (mu-sigma)>0
                    start=mu-sigma;
                else
                    start=0;
                end
                if (mu+sigma)<=number_of_points;
                    finish=mu+sigma;
                else
                    finish=number_of_points;
                end
                processed_data(m).event_counts(int_n).time_domain=struct('data',num2cell(zeros(1,1)),'pulse_time',num2cell(zeros(1,1)),'pulse_vector',num2cell(zeros(1,1)));
                processed_data(m).event_counts(int_n).frequency_domain = struct('data',num2cell(zeros(1,1)),'frequency',num2cell(zeros(1,1)));
                processed_data(int_m).name=adjusted_data(m).name;
                processed_data(int_m).event_counts(int_n).depth=num2str(n);
                processed_data(int_m).event_counts(int_n).event(int_mu,1)=start;
                processed_data(int_m).event_counts(int_n).event(int_mu,2)=finish;
                processed_data(int_m).event_counts(int_n).time_domain.pulse_time = pulse_time;
                processed_data(int_m).event_counts(int_n).time_domain.pulse_vector = pulse_number;
                processed_data(int_m).event_counts(int_n).time_domain.data = adjusted_data(m).run(n,:);
                processed_data(int_m).event_counts(int_n).frequency_domain.frequency = frequency;
                processed_data(int_m).event_counts(int_n).frequency_domain.data = shifted_fourier;
                
            end
        end
    end
end
clear fulldir
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date);
if exist(fullfile(fulldir,'ProcessedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
else
    mkdir(fullfile(fulldir),'ProcessedData');
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
end
beep
end