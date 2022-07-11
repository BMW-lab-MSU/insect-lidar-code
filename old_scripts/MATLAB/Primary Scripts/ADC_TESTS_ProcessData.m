function ADC_TESTS_ProcessData(di)
%%
%This script seaches though the adjusted_data to find whole runs that have
%something resembling an event.  The entire run is stored in processed_data
%along with a histogram of average (mean) data dn of maximum data which
%will be used for searching for events within each run.

%%
if isempty(di)==1
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end
fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',...
    date,'\AdjustedData\');
load(fullfile(fulldir,'adjusted_data.mat'));
%%
%input paramters
%set desired searchrange for insect spacing
searchrange=20;
%a factor which determines how much larger than the threshold our
%signal must be before we determine that it more than noise/bg
t_factor = 1.055;
%%
%set size of adjusted_data structure
[runs,columns]=size(adjusted_data);
%preallocate structure processed_data
processed_data = struct('name',num2cell(zeros(runs,1)),'event_counts',num2cell(zeros(runs,1)));

%loop runs for each adjusted_data run
for m = 1 : runs
    %determine how many data points were taken (depth) and how many pulses
    %were shot (number_of_pulses)
    [depth, number_of_pulses] = size(adjusted_data(m).run);
    %preallocate the event_counts portion of the structure.  This will
    %contain all relevent data for post analysis
    processed_data(m).event_counts = struct('depth',num2cell(zeros(depth,1)),...
        'data',num2cell(zeros(depth,1)),'pulse_time',num2cell(zeros(depth,1)),...
        'pulse_vector',num2cell(zeros(depth,1)),'hist_mean_data',...
        num2cell(zeros(depth,1)),'hist_max_data',num2cell(zeros(depth,1)),...
        'hist_index',num2cell(zeros(depth,1)),'threshold',...
        num2cell(zeros(depth,1)),'t_factor',num2cell(zeros(depth,1)),...
        'event_tf',num2cell(zeros(depth,1)),'event_index',num2cell(zeros(depth,1)),...
        'event',num2cell(zeros(depth,1)));
    %pulse time varies with each count.  this looks at the timestamp for
    %each run and extracts the pulse time in seconds
    pulse_time = (cell2mat(adjusted_data(m).data_info(10,...
        4:(length(adjusted_data(m).data_info)))))*10^(-6);
    %the difference between pulses is the important information, that is
    %extracted here
    time_between_pulses = mean(diff(pulse_time));
    %the laser has a pulse spacing period of about 154 miroseconds.
    %pulse_spacing determines if we sampeled every pulse, every two pulses,
    %every three pulses and so on 
    pulse_spacing = round(time_between_pulses / (154e-6));
    
    %set counter o
    o=0;
    
    %set a vector of pulses (e.g., every pulse: [1, 2, 3,...]; every other
    %pulse: [1, 3, 5, ...])
    pulse_number = linspace(1,(number_of_pulses * pulse_spacing)...
        + (1 - pulse_spacing),number_of_pulses);
    %the first adc count happens before the pulse has exited the lidar, so
    %we are looking only at background
    background = adjusted_data(m).run(1,:);
    %set a threshold value of background
    threshold = max(abs(background));
    %the loop searches the individual data points within a single run to
    %see if any exceede the threshold and t_factor product
    for n = 1:depth
        %if some value in the run is greater than the product, we
        %define paramters for that search
        if max(abs(adjusted_data(m).run(n,:))) > threshold * t_factor
            %increase o counter
            o=o+1;
            %set q counter
            q=0;
            %clear values for subsequent loop iterations
            clear hist_mean_data
            clear hist_max_data
            clear hist_index
            %preallocate 2 paramters for searching: mean and maximum
            hist_mean_data=zeros(1,(number_of_pulses/searchrange)-1);
            hist_max_data=zeros(1,(number_of_pulses/searchrange)-1);
            %preallocate index for searching
            hist_index=zeros(1,(number_of_pulses/searchrange)-1);
            %this loop searches for the mean and max within a defined
            %searchrange
            for p = 1:searchrange:number_of_pulses - (searchrange + 1)
                %increase q counter
                q=q+1;
                %every [searchrange] number of points are averaged and
                %thier absolute value is averaged
                hist_mean_data(q) = abs(mean(adjusted_data(m).run(n,p:p+(searchrange-1))));
                %find the maximum value in every [searchrange] number of points 
                hist_max_data(q) = max(abs(adjusted_data(m).run(n,p:p+(searchrange-1))));
                %set index
                hist_index(q) = pulse_number(p);
            end
            %store all data from above into processed_data structure       
            processed_data(m).name = adjusted_data(m).name;
            processed_data(m).event_counts(o).depth = n;
            processed_data(m).event_counts(o).data = adjusted_data(m).run(n,:);
            processed_data(m).event_counts(o).pulse_time = pulse_time;
            processed_data(m).event_counts(o).pulse_vector = pulse_number;
            processed_data(m).event_counts(o).hist_mean_data = hist_mean_data;
            processed_data(m).event_counts(o).hist_max_data = hist_max_data;
            processed_data(m).event_counts(o).hist_index = hist_index;
            processed_data(m).event_counts(o).threshold = threshold;
            processed_data(m).event_counts(o).t_factor = t_factor;            
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
end
