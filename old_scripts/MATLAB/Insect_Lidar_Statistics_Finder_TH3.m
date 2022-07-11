function full_stats=Insect_Lidar_Statistics_Finder_TH3(date,sf,full_stats)
stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\'; %Rack Directory
dateinfo_dir=[stored_data,date];
% load(fullfile(dateinfo_dir,'full_stats.mat'));
statfield=fieldnames(full_stats);
th2=0.9;
low_freq=50;
high_freq=1500;
for n=1:size(full_stats.(statfield{sf}),2)
    if full_stats.(statfield{sf})(n).max_ratio<th2
        full_stats.(statfield{sf})(n).positive_data=full_stats.(statfield{sf})(n).data-min(full_stats.(statfield{sf})(n).data);
        clear nop delta_t max_freq delta_f fqdata freq_data a b c loc_a loc_b loc_c
        nop=size(full_stats.(statfield{sf})(n).positive_data,2);
        delta_t=mean(diff(full_stats.(statfield{sf})(n).time));
        max_freq=1./(2*delta_t);
        delta_f=1/full_stats.(statfield{sf})(n).time(end);
        fft_frequency=(-nop/2:nop/2-1).*delta_f;
        fft_data=fftshift(fft(full_stats.(statfield{sf})(n).positive_data,nop,2),2);
        [pw_data,pw_frequency]=pwelch(full_stats.(statfield{sf})(n).positive_data,800,600,1024,max_freq*2);
        
        [a, loc_a]=max(abs(fft_data(find(fft_frequency<=low_freq,1,'last'):find(fft_frequency<=high_freq,1,'last'))));
        [b, loc_b]=min(abs(fft_data(find(fft_frequency<=low_freq,1,'last'):find(fft_frequency<=low_freq,1,'last')+loc_a)));
        [c, loc_c]=min(abs(fft_data(find(fft_frequency<=low_freq,1,'last')+loc_a:find(fft_frequency<=high_freq,1,'last'))));
        
        try
%             ratio_1=loc_a/loc_b;
            ratio_1=a/b;

        catch
            ratio_1=1;
        end
        try
%             ratio_2=loc_a/loc_c;
            ratio_2=a/c;
        catch
            ratio_2=1;
        end
        
        full_stats.(statfield{sf})(n).fft_frequency=fft_frequency;
        full_stats.(statfield{sf})(n).fft_data=fft_data;
        full_stats.(statfield{sf})(n).pw_frequency=pw_frequency;
        full_stats.(statfield{sf})(n).pw_data=pw_data;
        full_stats.(statfield{sf})(n).lower_ratio=ratio_1;
        full_stats.(statfield{sf})(n).upper_ratio=ratio_2;
        
        

        
    else
        full_stats.(statfield{sf})(n).fft_frequency=[];
        full_stats.(statfield{sf})(n).fft_data=[];
        full_stats.(statfield{sf})(n).pw_frequency=[];
        full_stats.(statfield{sf})(n).pw_data=[];
        full_stats.(statfield{sf})(n).lower_ratio=[];
        full_stats.(statfield{sf})(n).upper_ratio=[];
    end
    disp(n)
end



