%ADC_TESTS_SingleEvents

clear all
date = input('Extract Files From Which Date?','s');
fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date,'\ProcessedData\');
load(fullfile(fulldir,'processed_data.mat'));

runs = length(processed_data);

for m = 1:runs
    depth = length(processed_data(m).bee_counts);
    for n = 1:depth
        [y, x] = size(processed_data(m).bee_counts(n).event_index);
        for o = 1:y
            clear time_event
            clear frequency_event
            index_min = find(processed_data(m).bee_counts(n).pulse_vector == processed_data(m).bee_counts(n).event_index(o,1));
            index_max = find(processed_data(m).bee_counts(n).pulse_vector == max(processed_data(m).bee_counts(n).event_index(o,:)));
            time_event(1,:) = processed_data(m).bee_counts(n).pulse_vector(index_min:index_max);
            time_event(2,:) = processed_data(m).bee_counts(n).pulse_time(index_min:index_max);
            time_event(3,:) = processed_data(m).bee_counts(n).data(index_min:index_max);
            
            number_of_points=length(processed_data(m).bee_counts(n).pulse_time(index_min:index_max));
            time=processed_data(m).bee_counts(n).pulse_time(index_min:index_max);      
            max_time=processed_data(m).bee_counts(n).pulse_time(index_max); 
            min_time=processed_data(m).bee_counts(n).pulse_time(index_min); 
            delta_time=mean(diff(time));
            max_frequency=1/delta_time;
            delta_frequency=1/(max_time-min_time);
            frequency=(-number_of_points/2:number_of_points/2-1).*(delta_frequency);
            fourier_of_data=fft(processed_data(m).bee_counts(n).data(index_min:index_max));
            shifted_fourier=abs(fftshift(fourier_of_data)./number_of_points);
            frequency_event(1,:) = frequency;
            frequency_event(2,:) = shifted_fourier;
            
            processed_data(m).bee_counts(n).event(o).frequency_domain=frequency_event;
           
            processed_data(m).bee_counts(n).event(o).time_domain=time_event;
        end
    end
end

            
            