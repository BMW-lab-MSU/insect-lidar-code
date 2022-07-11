function []=ADC_TESTS_EventSearch(di)
%%

if isempty(di)==1
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',...
    date,'\ProcessedData\');
load(fullfile(fulldir,'processed_data.mat'));
%%
%determine length of processed_data
runs=length(processed_data);
t_factor_m=1.30;

for m = 1 : runs
    %define depth
    d = length(processed_data(m).event_counts);
    depth=0;
    for o=1:d
        if processed_data(m).event_counts(o).depth ~= 0
            depth=depth+1;
        end
    end
    for n = 1:depth
        %clear iterating variables
        clear event_index
        clear event_tf
        %event index size depends on the search
        event_index = zeros(1,1);
        %retrieve threshold and t_factor values from processed_data struct
        threshold = processed_data(m).event_counts(n).threshold;
        t_factor = processed_data(m).event_counts(n).t_factor*t_factor_m;
        %preallocate event_tf
        event_tf = zeros(1,length(processed_data(m).event_counts(n).hist_max_data)+1);
        %event_index = zeros(1,length(processed_data(m).event_counts(n).hist_index));
        %set counters o, q, and r
        q=0;
        r=0;
        %extract searchrange from processed_data struct
        searchrange = round(length(processed_data(m).event_counts(n).data)/...
            (length(processed_data(m).event_counts(n).hist_max_data)+1));
        %run loop for all hist_max_data points
        for p = 1:length(processed_data(m).event_counts(n).hist_max_data)
            %look for portions of the whole run where the the histogram has
            %a larger value than the threshold t_factor product
            if abs(processed_data(m).event_counts(n).hist_max_data(p)) >...
                    mean(processed_data(m).event_counts(n).hist_max_data)*1.024;                  
                %was there an event 1=yes, 0=no.
                event_tf(p) = 1;
                %if there was no event prior to this one
                if p>1 && event_tf(p-1)==0
                    %reset r counter
                    r=1;
                    %increase q counter by 1
                    q=q+1;
                    %add location of previous [searchrange] data points 
                    %to event_index matrix for completeness
                    event_index(q,r)=processed_data(m).event_counts(n).hist_index(p-1);
                end
                %increase r counter by 1
                r=r+1;
                %add location of events to index matrix and account for p
                %and q = 0
                if p==1
                    q=1;
                end
                event_index(q,r)=processed_data(m).event_counts(n).hist_index(p);
                %send event_index matrix and event_tf matrix to process
                %data structure for permanent save
                processed_data(m).event_counts(n).event_index = event_index;
                processed_data(m).event_counts(n).event_tf = event_tf;
                %if the previous [searchrange] had an event, AND we are
                %looking very close to the end, include the rest of the
                %data points (this is if an event was occuring at the end
                %of collection and we didn't capture the whole event)
            elseif p>1 && event_tf(p-1) == 1 && p+2 <= length(processed_data(m).event_counts(n).hist_max_data)
                event_index(q,r+1)=processed_data(m).event_counts(n).hist_index(p+1);
                event_index(q,r+2)=processed_data(m).event_counts(n).hist_index(p+2);
            elseif p>1 && event_tf(p-1) == 1 && p+1 <= length(processed_data(m).event_counts(n).hist_max_data)
                event_index(q,r+1)=processed_data(m).event_counts(n).hist_index(p+1);
            end    
        end    
        
    end
end

%%
%in this section we are using our true false matrix event_tf to locate all
%events
for m = 1:runs
    for n = 1:depth
        %determine how many events per run and how long
        [y, x] = size(processed_data(m).event_counts(n).event_index);
        %preallocate for fourier transform
        processed_data(m).event_counts(n).event=struct('frequency_domain',...
            num2cell(zeros(y,1)),'time_domain',num2cell(zeros(y,1)));
        if find(processed_data(m).event_counts(n).event_tf == 1)>1
            for o = 1:y
                %clear iterated values
                clear time_event
                clear frequency_event
                %find the pulse where the event index is at a minimum
                index_min = find(processed_data(m).event_counts(n).pulse_vector...
                    == processed_data(m).event_counts(n).event_index(o,1));
                %find the pulse where the event index is at a maximum
                index_max = find(processed_data(m).event_counts(n).pulse_vector...
                    == max(processed_data(m).event_counts(n).event_index(o,:)));
                %input all time information for fourier transform.  Includes
                %pulse vector, pulse time and data
                time_event(1,:) = processed_data(m).event_counts(n).pulse_vector(index_min:index_max);
                time_event(2,:) = processed_data(m).event_counts(n).pulse_time(index_min:index_max);
                time_event(3,:) = processed_data(m).event_counts(n).data(index_min:index_max);

                %determine number of points within one event
                number_of_points=length(processed_data(m).event_counts(n).pulse_time(index_min:index_max));
                %determine time data in one event
                time=processed_data(m).event_counts(n).pulse_time(index_min:index_max);
                %find min, max, and delta time for fourier analysis
                max_time=processed_data(m).event_counts(n).pulse_time(index_max); 
                min_time=processed_data(m).event_counts(n).pulse_time(index_min); 
                delta_time=mean(diff(time));
                %find max and delta frequency for fourier analysis
                max_frequency=1/delta_time;
                delta_frequency=1/(max_time-min_time);
                %acuire frequency vector
                frequency=((-(number_of_points)/2)+.5:((number_of_points)/2)-.5)*(delta_frequency);
                %perform FFT and shift
                fourier_of_data=fft(processed_data(m).event_counts(n).data(index_min:index_max));
                shifted_fourier=abs(fftshift(fourier_of_data)./number_of_points);
                frequency_event(1,:) = frequency;
                frequency_event(2,:) = shifted_fourier;

                %store time and frequency domains
                processed_data(m).event_counts(n).event(o).frequency_domain=frequency_event;

                processed_data(m).event_counts(n).event(o).time_domain=time_event;
            end
        end
    end
end
%%
%save whole processed_data structrue
clear fulldir
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date);
if exist(fullfile(fulldir,'ProcessedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
else
    mkdir(fullfile(fulldir),'ProcessedData');
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
end
end
