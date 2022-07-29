% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

% Set random number generator properties for reproducibility
rng(0, 'twister');

datadir = '../data/msu-bee-hives';
datafile = 'combined-data-2022-06-23-2022-06-24.mat';

%% Load data
load([datadir filesep datafile])

%%
labels = {scans.Labels}';
scanLabels = vertcat(scans.ScanLabel);

%% Partition into training and test sets
TEST_PCT = 0.2;

holdoutPartition = cvpartition(scanLabels, 'Holdout', TEST_PCT, 'Stratify', true);

trainingData = {scans(training(holdoutPartition)).Data}';
testingData = {scans(test(holdoutPartition)).Data}';
trainingLabels = labels(training(holdoutPartition));
testingLabels = labels(test(holdoutPartition));

%% Partition the data for k-fold cross validation
N_FOLDS = 5;

crossvalPartition = cvpartition(scanLabels(training(holdoutPartition)), ...
    'KFold', N_FOLDS, 'Stratify', true);


%% Save training and testing data
mkdir(datadir, 'testing');
save([datadir filesep 'testing' filesep 'testingData.mat'], ...
    'testingData', 'testingLabels', ...
    'holdoutPartition', 'scanLabels', '-v7.3');

mkdir(datadir, 'training');
save([datadir filesep 'training' filesep 'trainingData.mat'], ...
    'trainingData', 'trainingLabels', ...
    'crossvalPartition', 'holdoutPartition', 'scanLabels', '-v7.3');
