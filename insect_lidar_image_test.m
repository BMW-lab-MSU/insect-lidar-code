% insect_lidar_image_test | Author: Liz Rehbein | Updated: N 26, 2019
% Perform a variety of statistical processing to non-normalized data
% and plots the resulting data as an image of 
% range vs time vs returned signal.

% THIS SECTION FOR TEST DATA ONLY
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','imageevents'}));

if exist('D:\Data_2018\2018-07-11\processed_data_deathstar\imageevents.mat','file')~=0
    load('D:\Data_2018\2018-07-11\processed_data_deathstar\imageevents.mat');
    int=size(fftevents,2);
else
    mkdir image_classification
    int=0;
end

for x = 1:size(testdata,2)
    figure(1)
    imagesc(testdata(x).data);
    title('Non-norm data');
    xlabel('pulse number');
    ylabel('range');
    isinsect=input('is this an insect (y/n/m)? ','s');
end