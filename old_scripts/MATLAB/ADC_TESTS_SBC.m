%ADC_TESTS_ExtractSingleBeeCounts

%Find and load all adjusted data from a specified date

clear all
date = input('Extract Files From Which Date?','s');
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date,'\AdjustedData\');
load(fullfile(fulldir,'adjusted_data.mat'));


%new
[runs,columns]=size(adjusted_data);
searchrange=20;

processed_data = struct('name',num2cell(zeros(runs,1)),'bee_counts',num2cell(zeros(runs,1)));


for m = 1 : runs
    [depth, number_of_pulses] = size(adjusted_data(m).run);
    d=1;
    processed_data(m).bee_counts = struct('depth',num2cell(zeros(d,1)),'data',num2cell(zeros(d,1)),'pulse_time',num2cell(zeros(d,1)),'pulse_vector',num2cell(zeros(d,1)),'hist_mean_data',num2cell(zeros(d,1)),'hist_max_data',num2cell(zeros(d,1)),'hist_index',num2cell(zeros(d,1)),'threshold',num2cell(zeros(d,1)),'event_index',num2cell(zeros(d,1)),'event_tf',num2cell(zeros(d,1)),'event',num2cell(zeros(d,1)));
    
    pulse_time = (cell2mat(adjusted_data(m).data_info(10,4:(length(adjusted_data(m).data_info)))))*10^(-6);
    time_between_pulses = mean(diff(pulse_time));
    pulse_spacing = round(time_between_pulses / (154e-6));
    
    o=0;
    
    pulse_number = linspace(1,(number_of_pulses * pulse_spacing) + (1 - pulse_spacing),number_of_pulses);
    background = adjusted_data(m).run(1,:);
    threshold = max(abs(background));
    t_factor = 20;
    for n = 1:depth
        if max(abs(adjusted_data(m).run(n,:))) > threshold * t_factor
            o=o+1;
            q=0;
            clear hist_mean_data
            clear hist_max_data
            clear hist_index
            hist_mean_data=zeros(1,(number_of_pulses/searchrange)-1);
            hist_max_data=zeros(1,(number_of_pulses/searchrange)-1);
            hist_index=zeros(1,(number_of_pulses/searchrange)-1);
            for p = 1:searchrange:number_of_pulses - (searchrange + 1)
                q=q+1;
                hist_mean_data(q) = abs(mean(adjusted_data(m).run(n,p:p+(searchrange-1))));
                hist_max_data(q) = max(abs(adjusted_data(m).run(n,p:p+(searchrange-1))));
                hist_index(q) = pulse_number(p);
            end
                    
            processed_data(m).name = adjusted_data(m).name;
            processed_data(m).bee_counts(o).depth = n;
            processed_data(m).bee_counts(o).data = adjusted_data(m).run(n,:);
            processed_data(m).bee_counts(o).pulse_time = pulse_time;
            processed_data(m).bee_counts(o).pulse_vector = pulse_number;
            processed_data(m).bee_counts(o).hist_mean_data = hist_mean_data;
            processed_data(m).bee_counts(o).hist_max_data = hist_max_data;
            processed_data(m).bee_counts(o).hist_index = hist_index;
            processed_data(m).bee_counts(o).threshold = threshold;
        end
    end
end


%notnew
runs=length(processed_data);
%searchrange=20;

for m = 1 : runs
    depth = length(processed_data(m).bee_counts);   
    for n = 1:depth
        clear event_index
        clear event_tf
        event_index = zeros(1,1);
        threshold = processed_data(m).bee_counts(n).threshold;
        t_factor = 3;
        event_tf = zeros(1,length(processed_data(m).bee_counts(n).hist_max_data)+1);
        %event_index = zeros(1,length(processed_data(m).bee_counts(n).hist_index));
        o=0;
        q=0;
        r=0;
        searchrange = round(length(processed_data(m).bee_counts(n).data)/(length(processed_data(m).bee_counts(n).hist_max_data)+1));
        %p=2;
        for p = 2:length(processed_data(m).bee_counts(n).hist_max_data)
            if abs(processed_data(m).bee_counts(n).hist_max_data(p)) > threshold * t_factor                  
                o=o+1;
                event_tf(p) = 1;
                if event_tf(p-1)==0
                    r=1;  
                    q=q+1;
                    event_index(q,r)=processed_data(m).bee_counts(n).hist_index(p-1);
                end
                r=r+1;
    
                event_index(q,r)=processed_data(m).bee_counts(n).hist_index(p);
                processed_data(m).bee_counts(n).event_index = event_index;
                processed_data(m).bee_counts(n).event_tf = event_tf;
            elseif event_tf(p-1) == 1 && p+2 <= length(processed_data(m).bee_counts(n).hist_max_data)
                event_index(q,r+1)=processed_data(m).bee_counts(n).hist_index(p+1);
                event_index(q,r+2)=processed_data(m).bee_counts(n).hist_index(p+2);
            elseif event_tf(p-1) == 1 && p+1 <= length(processed_data(m).bee_counts(n).hist_max_data)
                event_index(q,r+1)=processed_data(m).bee_counts(n).hist_index(p+1);
            end    
        end    
        
    end
end


for m = 1:runs
    depth = length(processed_data(m).bee_counts);
    for n = 1:depth
        [y, x] = size(processed_data(m).bee_counts(n).event_index);
        processed_data(m).bee_counts(n).event=struct('frequency_domain',num2cell(zeros(y,1)),'time_domain',num2cell(zeros(y,1)));
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

%new 

clear fulldir
fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date);
if exist(fullfile(fulldir,'ProcessedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
else
    mkdir(fullfile(fulldir),'ProcessedData');
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
end

