for m=1:1:50         
    for n=1:1:76
        plot(adjusted_data(m).raw_run(n,:))
        ylim([-.5 .5])
        title([num2str(m) '--' num2str(n) '--' num2str(rangefind(n)) ' m'])
        pause
    end
end