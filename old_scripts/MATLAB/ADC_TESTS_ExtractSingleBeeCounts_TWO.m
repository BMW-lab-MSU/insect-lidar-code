%ADC_TESTS_ExtractSingleBeeCounts

%Find and load all adjusted data from a specified date

clear all
date = input('Extract Files From Which Date?','s');
fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date,'\AdjustedData\');
load(fullfile(fulldir,'adjusted_data.mat'));

[runs,columns]=size(adjusted_data);
searchrange=20;

for m = 1 : runs
    [depth, number_of_pulses] = size(adjusted_data(m).run);
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
            for p = 1:searchrange:number_of_pulses - (searchrange + 1)
                q=q+1;
                hist_mean_data(q) = abs(mean(adjusted_data(m).run(n,p:p+(searchrange-1))));
                hist_max_data(q) = max(abs(adjusted_data(m).run(n,p:p+(searchrange-1))));
                hist_index(q) = p;
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

clear fulldir
fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date);
if exist(fullfile(fulldir,'ProcessedData'),'dir')==7;
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
else
    mkdir(fullfile(fulldir),'ProcessedData');
    save(fullfile(strcat(fulldir,'\ProcessedData'),'processed_data'),'processed_data')
end
