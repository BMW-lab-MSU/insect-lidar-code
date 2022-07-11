for a=1:10
    for b=1:length(processed_data(a).event_counts)
        subplot(2,1,1)
        plot(processed_data(a).event_counts(b).hist_index,processed_data(a).event_counts(b).event_tf)
        %xlim([1 length(processed_data(a).bee_counts(b).data)])
        subplot(2,1,2)
        plot(processed_data(a).event_counts(b).hist_index,processed_data(a).event_counts(b).hist_mean_data)
        %xlim([100,length(processed_data(a).bee_counts(b).data)+100])
        pause
    end
end
