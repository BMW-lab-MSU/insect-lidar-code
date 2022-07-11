%% Script to add to statistics_b

clear all
start_file='D:\Data-Test\';                          %indicate directory for start_file location
date='2016-06-08';                                   %select date of folder to look at 
filename=fullfile(start_file,date,'processed_data'); %load in processed data
load(fullfile(filename, 'events', 'manual_noninsect'));
load(fullfile(filename,'Training_Data_new','statistics_b'));

home_dir = 'D:\Data-Test\2016-06-08\processed_data';
files = dir(fullfile(home_dir,'*.mat'));


for h=1:1:length(manual_noninsect)

temp_h =files(manual_noninsect(h).x).name;

noninsect(h).names = temp_h; 
noninsect(h).z = manual_noninsect(h).z;
noninsect(h).x = manual_noninsect(h).x;
noninsect(h).y = manual_noninsect(h).y;

end

l = length(statistics_b.noninsect);

for n = 1:1:length(noninsect)

l = l + 1; 

x = load(fullfile(filename, noninsect(n).names));
statistics_b.noninsect(1,l).data =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).data((noninsect(n).z),:);
statistics_b.noninsect(1,l).positive_data =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).normalized_data((noninsect(n).z),:);
statistics_b.noninsect(1,l).time =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).time;
statistics_b.noninsect(1,l).pan =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).pan;
statistics_b.noninsect(1,l).tilt =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).tilt;
statistics_b.noninsect(1,l).filename =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).filename;

[A, B, C, D ] = quick_FFT(statistics_b.noninsect(l).time, statistics_b.noninsect(l).positive_data);

statistics_b.noninsect(1,l).fft_data =  C;
statistics_b.noninsect(1,l).fft_frequency = D;
statistics_b.noninsect(1,l).fft_power = B;


end

disp('done');
save(fullfile(home_dir,'Training_Data_new','statistics_b.mat'),'statistics_b','-v7.3');