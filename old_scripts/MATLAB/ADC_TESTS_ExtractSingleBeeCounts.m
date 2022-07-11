%ADC_TESTS_ExtractSingleBeeCounts

%Find and load all adjusted data from a specified date

clear all
date = input('Extract Files From Which Date?','s');
fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date,'\AdjustedData\');
load(fullfile(fulldir,'adjusted_data.mat'));

[runs,columns]=size(adjusted_data);
searchrange=60;

for n=1:runs
    [depths(n),nops]=size(adjusted_data(n).run);
end

max_depth=max(depths);

event=zeros(runs,max_depth);

for n=1:runs
    [depth, number_of_pulses]=size(adjusted_data(n).run);
    [search_depth, search_number_of_pulses]=size(adjusted_data(n).search_run);
    padding=search_number_of_pulses-number_of_pulses;
    pulse_time=(cell2mat(adjusted_data(n).data_info(10,4:(length(adjusted_data(n).data_info)))))*10^(-6);
    time_between_pulses=mean(diff(pulse_time));
    pulse_spacing=round(time_between_pulses/(155e-6));
    o=0;
    pulse_number=linspace(1,(number_of_pulses*pulse_spacing)+(1-pulse_spacing),number_of_pulses);
    for m=1:depth
        d=0;
        clear localmaxs
        for c=1:searchrange:search_number_of_pulses-searchrange;
            d=d+1;
            localmaxs(d)=max(abs(adjusted_data(n).search_run(m,c:c+(searchrange-1))));
        end
        localmaximum=mean(localmaxs);
        absolutemaximum=max(abs(adjusted_data(n).search_run(m,:)));
        dmax=diff([localmaximum,absolutemaximum]);
        threshold=dmax*(0.25)+localmaximum;
        %for h=(searchrange+1):length(adjusted_data(n).search_run(m,:))-(searchrange+1)
        %    if max(abs(adjusted_data(n).search_run(m,h-searchrange:h+searchrange))) > abs(threshold) && event(n,m)==0 %max(abs(adjusted_data(n).search_run(m,:))) > abs(threshold) %&& abs(localmaximum/absolutemaximum) < 0.2500
        %        event(n,m)=1;
        %    end
        %end
        if abs(mean(adjusted_data(n).search_run(m,:))) < abs(std(adjusted_data(n).search_run(m,:)))
           event(n,m)=1;
           o=o+1;
           processed_data(n).name=adjusted_data(n).name;
           processed_data(n).bee_counts(o).depth=m;
           processed_data(n).bee_counts(o).data=adjusted_data(n).run(m,:);
           processed_data(n).bee_counts(o).pulse_time=pulse_time;
           processed_data(n).bee_counts(o).pulse_vector=pulse_number;
        end
    end
end

p=0;

clear threshold
% [runs,depth]=size(event);
% for a=1:runs
%     f=0;
%     
%     for b=1:depth
%         if event(a,b)==1
%             f=f+1;
%             number_of_points=length(adjusted_data(a).search_run(b,:));
%             d=0;
%             clear localmaxs
%             for c=1:searchrange:number_of_points-searchrange;
%                 d=d+1;
%                 localmaxs(d)=max(abs(adjusted_data(a).search_run(b,c:c+(searchrange-1))));
%             end
%             localmaximums=mean(localmaxs);
%             absolutemaximum=max(abs(adjusted_data(a).search_run(b,:)));
%             dmax=diff([localmaximums,absolutemaximum]);
%             threshold=dmax*(0.2)+localmaximums;
%             o=0;
%             for p=searchrange+1:number_of_points-(searchrange+1)
%                 if max(abs(adjusted_data(a).search_run(b,p-searchrange:p+searchrange))) < abs(threshold)
%                    n=p-(padding/2);
%                    processed_data(a).bee_counts(f).data_with_deletes(p)=0;
%                 else
%                     if max(abs(processed_data(a).bee_counts(f).data_with_deletes(n-11:n-1)))==0;
%                         o=o+1;
%                         p=0;
%                     end
%                     processed_data(a).bee_counts(f).data_with_deletes(n)=processed_data(a).bee_counts(f).data(n);
%                     p=p+1;
%                     processed_data(a).bee_counts(f).extracted_data(o).location(p)=n;
%                     processed_data(a).bee_counts(f).extracted_data(o).counts(p)=processed_data(a).bee_counts(f).data(n);
%                 end
%             end
%         end
%     end
% end


for a=1:length(processed_data)
    for b=1:length(processed_data(a).bee_counts)
        processed_data(a).bee_counts(b).data_with_deletes=zeros(1,length(processed_data(a).bee_counts(b).data)+padding);
        size(processed_data(a).bee_counts(b));
        number_of_points=length(processed_data(a).bee_counts(b).data);
        d=0;
        clear localmaxs
        for c=1:searchrange:number_of_points-searchrange;
            d=d+1;
            localmaxs(d)=max(abs(processed_data(a).bee_counts(b).data(c:c+(searchrange-1))));
        end
        localmaximums=mean(localmaxs);
        absolutemaximum=max(abs(processed_data(a).bee_counts(b).data));
        dmax=diff([localmaximums,absolutemaximum]);
        threshold=dmax*(0.10)+localmaximums;

        o=0;
        for n=searchrange+1:number_of_points-(searchrange+1)
            q=n+padding/2;
            if max(abs(processed_data(a).bee_counts(b).data(n-searchrange:n+searchrange))) < abs(threshold)
               processed_data(a).bee_counts(b).data_with_deletes(q)=0;
            else
                if max(abs(processed_data(a).bee_counts(b).data_with_deletes(q-11:q-1)))==0;
                    o=o+1;
                    p=0;
                end
                processed_data(a).bee_counts(b).data_with_deletes(q)=processed_data(a).bee_counts(b).data(n);
                p=p+1;
                processed_data(a).bee_counts(b).extracted_data(o).location(p)=n;
                processed_data(a).bee_counts(b).extracted_data(o).counts(p)=processed_data(a).bee_counts(b).data(n);
            end
        end
    end
end

clear a
clear b
clear c
clear number_of_points

for a=1:length(processed_data)
    for b=1:length(processed_data(a).bee_counts)
        for c=1:length(processed_data(a).bee_counts(b).extracted_data)
            number_of_points=length(processed_data(a).bee_counts(b).extracted_data(c).counts);
            time=processed_data(a).bee_counts(b).pulse_time(processed_data(a).bee_counts(b).extracted_data(c).location);      
            max_time=time(number_of_points);
            min_time=time(1);
            delta_time=mean(diff(time));
            max_frequency=1/delta_time;
            delta_frequency=1/(max_time-min_time);
            frequency=(-number_of_points/2:number_of_points/2-1).*(delta_frequency);
            fourier_of_data=fft(processed_data(a).bee_counts(b).extracted_data(c).counts);
            shifted_fourier=abs(fftshift(fourier_of_data)./number_of_points);
            processed_data(a).bee_counts(b).extracted_data(c).time=time;
            processed_data(a).bee_counts(b).extracted_data(c).frequency=frequency;
            processed_data(a).bee_counts(b).extracted_data(c).fourier=shifted_fourier;
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



%for n=1:length(processed_data(2).bee_counts)
%    plot(processed_data(2).bee_counts(1).pulse_vector,processed_data(2).bee_counts(1).data,'blue',processed_data(2).bee_counts(n).pulse_vector,processed_data(2).bee_counts(n).data,'red')
%    pause
%end