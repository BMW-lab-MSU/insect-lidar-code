function []=ADC_TESTS_FourierTransform(di)

close all
if isempty(di)==1
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end

fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date,'\ProcessedData\');
load(fullfile(fulldir,'processed_data.mat'));


for m=1:length(processed_data)
    %just look at first two range bins.  Ringing causes multiple events to
    %show up
    for n=1:2;
        if find(processed_data(m).event_counts(n).event_tf==1) >= 1
          for o=1:length(processed_data(m).event_counts(n).event)
             [vectors, number_of_points]=size(processed_data(m).event_counts(n).event(o).frequency_domain);
             subplot(2,1,1)
             plot(processed_data(m).event_counts(n).event(o).time_domain(2,:),processed_data(m).event_counts(n).event(o).time_domain(3,:))
             p_title=strcat('Date :', date, ', at time :', processed_data(m).name, ', at depth :', num2str(processed_data(m).event_counts(n).depth),...
                 ' (', num2str(rangefind(processed_data(m).event_counts(n).depth)), ')m', ',  event number :', num2str(o));
             title(p_title,'interpreter','none')

             xlabel('Time (s)')
             ylabel('PMT Response (V)')
             subplot(2,1,2)
             plot(processed_data(m).event_counts(n).event(o).frequency_domain(1,:),processed_data(m).event_counts(n).event(o).frequency_domain(2,:))
             title(strcat(num2str(m),'-',num2str(n),'-',num2str(o)))

             xlabel('Frequency (Hz)')
             ylabel('Intensity (Arbitrary)')
             xlim([-400, 400])
             ylim([0, 0.01])
             pause
          end
        end
    end
end
end