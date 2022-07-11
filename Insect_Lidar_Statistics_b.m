%%%Script for finding statistics for statistics_b file%%%
clear all
start_file='D:\Data-Test\';                          %indicate directory for start_file location
date='2016-06-08';                                   %select date of folder to look at 
filename=fullfile(start_file,date,'processed_data'); %load in processed data
load(fullfile(filename, 'events', 'manual_final_insect'));

home_dir = 'D:\Data-Test\2016-06-08\processed_data';
files = dir(fullfile(home_dir,'*.mat'));

%%insects%%
for i=1:1:length(manual_final_insect.very_likely)

temp =  files(manual_final_insect.very_likely(i).x).name;

insect(i).names = temp; 
insect(i).z = manual_final_insect.very_likely(i).z;
insect(i).x = manual_final_insect.very_likely(i).x;
insect(i).y = manual_final_insect.very_likely(i).y;
%figure();
%plot(temp.(fn{1})(manual_final_insect.very_likely(n).y).normalized_data(manual_final_insect.very_likely(n).z,:))

end

%%noninsects%%
for n=1:1:length(manual_final_insect.very_unlikely)

temp_n =files(manual_final_insect.very_unlikely(n).x).name;

noninsect(n).names = temp_n; 
noninsect(n).z = manual_final_insect.very_unlikely(n).z;
noninsect(n).x = manual_final_insect.very_unlikely(n).x;
noninsect(n).y = manual_final_insect.very_unlikely(n).y;

end

%%maybe insects--in three parts will be concatenated at the end%%
for s=1:1:length(manual_final_insect.somewhat_unlikely)

temp_s =files(manual_final_insect.somewhat_unlikely(s).x).name;

somewhatunlikely(s).names = temp_n; 
somewhatunlikely(s).z = manual_final_insect.somewhat_unlikely(s).z;
somewhatunlikely(s).x = manual_final_insect.somewhat_unlikely(s).x;
somewhatunlikely(s).y = manual_final_insect.somewhat_unlikely(s).y;

end

for l=1:1:length(manual_final_insect.somewhat_likely)

temp_1 = files(manual_final_insect.somewhat_likely(l).x).name;

somewhatlikely(l).names = temp_1; 
somewhatlikely(l).z = manual_final_insect.somewhat_likely(l).z;
somewhatlikely(l).x = manual_final_insect.somewhat_likely(l).x;
somewhatlikely(l).y = manual_final_insect.somewhat_likely(l).y;

end

for m=1:1:length(manual_final_insect.multiple_insects)

temp_m =files(manual_final_insect.multiple_insects(m).x).name;
multiple(m).names = temp_m; 
multiple(m).z = manual_final_insect.multiple_insects(m).z;
multiple(m).x = manual_final_insect.multiple_insects(m).x;
multiple(m).y = manual_final_insect.multiple_insects(m).y;

end

maybeinsect = [somewhatunlikely, somewhatlikely, multiple];

%------------------------------------------------------------------------%

for n = 1:1:length(maybeinsect)

x = load(fullfile(filename, maybeinsect(n).names));
statistics_b.maybeinsect(1,n).data =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).data((maybeinsect(n).z),:);
statistics_b.maybeinsect(1,n).positive_data =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).normalized_data((maybeinsect(n).z),:);
statistics_b.maybeinsect(1,n).time =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).time;
statistics_b.maybeinsect(1,n).pan =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).pan;
statistics_b.maybeinsect(1,n).tilt =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).tilt;
statistics_b.maybeinsect(1,n).filename =  x.(maybeinsect(n).names(5:end-4))(maybeinsect(n).y).filename;

[A, B, C, D ] = quick_FFT(statistics_b.maybeinsect(n).time, statistics_b.maybeinsect(n).positive_data);

statistics_b.maybeinsect(1,n).fft_data =  C;
statistics_b.maybeinsect(1,n).fft_frequency = D;


end

for n = 1:1:length(noninsect)

x = load(fullfile(filename, noninsect(n).names));
statistics_b.noninsect(1,n).data =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).data((noninsect(n).z),:);
statistics_b.noninsect(1,n).positive_data =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).normalized_data((noninsect(n).z),:);
statistics_b.noninsect(1,n).time =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).time;
statistics_b.noninsect(1,n).pan =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).pan;
statistics_b.noninsect(1,n).tilt =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).tilt;
statistics_b.noninsect(1,n).filename =  x.(noninsect(n).names(5:end-4))(noninsect(n).y).filename;

[A, B, C, D ] = quick_FFT(statistics_b.noninsect(n).time, statistics_b.noninsect(n).positive_data);

statistics_b.noninsect(1,n).fft_data =  C;
statistics_b.noninsect(1,n).fft_frequency = D;

end

for n = 1:1:length(insect)
    
x = load(fullfile(filename, insect(n).names));
statistics_b.insect(1,n).data =  x.(insect(n).names(5:end-4))(insect(n).y).data((insect(n).z),:);
statistics_b.insect(1,n).positive_data =  x.(insect(n).names(5:end-4))(insect(n).y).normalized_data((insect(n).z),:);
statistics_b.insect(1,n).time = x.(insect(n).names(5:end-4))(insect(n).y).time;
statistics_b.insect(1,n).pan =  x.(insect(n).names(5:end-4))(insect(n).y).pan;
statistics_b.insect(1,n).tilt =  x.(insect(n).names(5:end-4))(insect(n).y).tilt;
statistics_b.insect(1,n).filename =  x.(insect(n).names(5:end-4))(insect(n).y).filename;

[A, B, C, D ] = quick_FFT(statistics_b.insect(n).time, statistics_b.insect(n).positive_data);

statistics_b.insect(1,n).fft_data =  C;
statistics_b.insect(1,n).fft_frequency = D;


end

save(fullfile(home_dir, 'statistics_b.mat'));

