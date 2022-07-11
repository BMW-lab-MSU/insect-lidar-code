m=5;
n=2;
o=3;

start=1;
stop=200;

portion_only=1;

close all
if portion_only==1;
subplot(2,1,1)
plot(processed_data(m).bee_counts(n).event(o).time_domain(2,start:stop),processed_data(m).bee_counts(n).event(o).time_domain(3,start:stop))
%title(strcat(num2str(m),'-',num2str(n),'-',num2str(o)))
title(strcat('Data taken on',{' '},date,{' '},'at time',{' '},processed_data(m).name,{' '},'at depth',{' '},num2str(processed_data(m).bee_counts(n).depth), {' '},'with bee count',{' '},num2str(o),{' '},'(Segmenet Extracted)'),'Interpreter','none')
xlabel('Time (s)')
ylabel('PMT Response (V)')





            number_of_points=length(processed_data(m).bee_counts(n).event(o).time_domain(3,start:stop));
            time=processed_data(m).bee_counts(n).event(o).time_domain(2,start:stop);      
            max_time=max(processed_data(m).bee_counts(n).event(o).time_domain(2,start:stop)); 
            min_time=min(processed_data(m).bee_counts(n).event(o).time_domain(2,start:stop)); 
            delta_time=mean(diff(time));
            max_frequency=1/delta_time;
            delta_frequency=1/(max_time-min_time);
            frequency=(-number_of_points/2:number_of_points/2-1).*(delta_frequency);
            fourier_of_data=fft(processed_data(m).bee_counts(n).event(o).time_domain(3,start:stop));
            shifted_fourier=abs(fftshift(fourier_of_data)./number_of_points);
            subplot(2,1,2)
            plot(frequency,shifted_fourier)
            %title(strcat(num2str(m),'-',num2str(n),'-',num2str(o)))
            title(strcat('Data taken on',{' '},date,{' '},'at time',{' '},processed_data(m).name,{' '},'at depth',{' '},num2str(processed_data(m).bee_counts(n).depth), {' '},'with bee count',{' '},num2str(o),{' '},'(Segmenet Extracted)'),'Interpreter','none')
            xlabel('Frequency (Hz)')
            ylabel('Intensity (Arbitrary)')
            xlim([-300, 300])




else
    

subplot(2,1,1)
plot(processed_data(m).bee_counts(n).event(o).time_domain(2,:),processed_data(m).bee_counts(n).event(o).time_domain(3,:))
%title(strcat(num2str(m),'-',num2str(n),'-',num2str(o)))
title(strcat('Data taken on',{' '},date,{' '},'at time',{' '},processed_data(m).name,{' '},'at depth',{' '},num2str(processed_data(m).bee_counts(n).depth), {' '},'with bee count',{' '},num2str(o)),'Interpreter','none')
xlabel('Time (s)')
ylabel('PMT Response (V)')

subplot(2,1,2)
plot(processed_data(m).bee_counts(n).event(o).frequency_domain(1,:),processed_data(m).bee_counts(n).event(o).frequency_domain(2,:))
%title(strcat(num2str(m),'-',num2str(n),'-',num2str(o)))
title(strcat('Data taken on',{' '},date,{' '},'at time',{' '},processed_data(m).name,{' '},'at depth',{' '},num2str(processed_data(m).bee_counts(n).depth), {' '},'with bee count',{' '},num2str(o)),'Interpreter','none')
xlabel('Frequency (Hz)')
ylabel('Intensity (Arbitrary)')
xlim([-300, 300])

end