%% calibrateRangeBins

% This function returns the slope and offset of the best-fit line for
% calibrating the 'distance vs. range bin' lidar setting. It requires as an
% input the directory where Insect_Lidar_Range_Cal.m saves its calibration
% files.
%
% The returned slope and offset should be hard-coded into the function
% rangefind.m which is used by the preprocessing algorithm to return
% calibrated results.
%
% Example Usage:
% range_cal_dir = 'Data_range_cal/2022-06-24/Range_cal102511';
% [slope, offset] = calibrateRangeBins(range_cal_dir);
%
% NOTE: This function will only work for distances up to 99.99 meters.

function [slope, offset] = calibrateRangeBins(range_cal_dir)

% List all files in the calibration directory
filelist = dir(range_cal_dir);

% Remove '.' '..' and the terminating file (range_9999_00.mat)
filelist = filelist(3:end-1);

% Pre-allocate distance and bin vectors
N = length(filelist);
distances = zeros(N,1);
bins = zeros(N,1);

for i = 1:N
    % Determine the distance associated with the file of interest.
    % Filenames are formatted as 'range_XX_YY.mat', where XX.YY is the
    % recorded distance obtained by the rangefinder in meters. For example,
    % if the rangefinder reading was 13.4 meters, the filename would be
    % 'range_13_40.mat'.
    matfile = filelist(i).name;
    distances(i) = str2double(matfile(7:8)) + 0.01*str2double(matfile(10:11));

    % Load the collected data
    data = load([filelist(i).folder '/' filelist(i).name]);
    data = data.full_data.data(:,1:1024); % The pre-allocated matrix is too big...
    data(data==0) = max(data(:));

    % Note that a hard target should show up as a low photovoltaic current
    % reading at a constant range bin across all time (a horizontal line).

    % Find the smallest current reading in each column (the range bin at
    % which the lidar measured the brightest return)
    targetbin = zeros(1024,1);
    for j = 1:1024
        targetbin(j) = find(data(:,j)==min(data(:,j)),1);
    end

    % Assume that the hard target is located at the median range bin.
    bins(i) = median(targetbin);
end

% Least-squares regression to determine slope and offset
X = [ones(N,1), bins];
y = distances;

b = X\y;

slope = b(2);
offset = b(1);

% Optional: Plot the scatter plot of measured distances as a function of
% range bin as well as the line obtained from least-squares regression.
x = 0:100;
scatter(bins,distances);
hold on;
plot(x, slope*x + offset);
hold off;
xlabel('Range Bin');
ylabel('Distance (meters)');
legend({'Measured Points','Best-Fit Line'});

end