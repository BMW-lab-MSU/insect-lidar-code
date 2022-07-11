%% Collect the data
Insect_Lidar_Run_Experiment_no_pan_tilt

%% Preprocess the data
scan_prefix = 'MSU-horticulture-farm-bees-';
Insect_Lidar_Adjust_Data_Trevor('E:\Data_2022', datestr(now,'yyyy-mm-dd'), scan_prefix)

%% Analyze fft
% Load in an adjusted_data_decembercal file before running the fft_test
% script... this feels bad, but it'll work for now...
fft_test

