% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seth Laurie
% Montana State University
% October 10th, 2017
% process_data.m
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script processes lidar data that has been placed into bins. The
% mat files (Ex. '00001-T1_50P39_00.mat') are loaded and processed. 
% Functions are applied to each lidar snapshot and the predict() function
% is used to indentify bugs.
% 
% Creates SVM_Model_insects.m (SVM File)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Training, insect LIDAR
warning('off','all')
warning('query','all')

%% Load data
% Training data
data_dir = 'C:\Users\lauri_000\Desktop\Work\Insect_Project\Training_data';
data_file_sl = dir(fullfile(data_dir,'sl*.mat'));
data_file_vl = dir(fullfile(data_dir,'vl*.mat'));
sl = load(fullfile(data_dir,data_file_sl.name));
vl = load(fullfile(data_dir,data_file_vl.name));

% Raw data
raw_dir = 'C:\Users\lauri_000\Desktop\Work\Insect_Project\Training_data\raw_data\AMK_Ranch-210853';
raw_files = dir(fullfile(raw_dir,'a*.mat'));
raw = load(fullfile(raw_dir,raw_files(1).name));

% Statistic data (insect, non-insects)
stat_dir = 'C:\Users\lauri_000\Desktop\Work\Insect_Project\Training_data';
stat_files = dir(fullfile(stat_dir,'stat*.mat'));
stat = load(fullfile(stat_dir,stat_files(1).name));

%% Variables

% Detected insect training
insects = 1:76;
% Best insects from the above list
best_insects = [4,10,16,20,28,61,69,73];

% No insect present list, hand selected.
non_insects = [1,4,6,7,8,9,11,17,22,33,43,47,57,67,260,262,271,279,284,289,303,...
    304,305,308,313,314,315,316,319,322,325,326,327,328,329,330,...
    331,332,333,335,342,343,345,346,347,348,349,350,352,353,354,355,357,...
    363,366,367,368,369,370,372,374,375,376,377,378,379,381,384,...
    385,386,387,388,390,391,392,393];
% Best non insects
best_non_insects = [4,11,17,22,33,38,43,47,57,67,260,262,271,279,284,289,303];

% Function names
func_name = {'Frequency','Amplitude','Kurtosis','Peak Deviation',...
    'Peak Ratio','Max Peak Number','Harmonic Mean'};
%% Pass Band Filter
% passband=[20, 1000]; 
% passband_fs=2048; % Sampling rate 
% filterOrder=2; % Order of filter
% d1 = designfilt('bandpassfir','FilterOrder',3, ...
%          'CutoffFrequency1',15,'CutoffFrequency2',1000, ...
%          'SampleRate',2048);

%% View data
% % Insects
% for n=1:76
%     subplot(2,1,1), plot(vl.analysis_data(n).time,vl.analysis_data(n).positive_data);
%     title(['Temporal Data #',int2str(n)]), ylabel('Amplitude'), xlabel('Time')
%     subplot(2,1,2),plot(vl.analysis_data(n).frequency,abs(vl.analysis_data(n).gauss_freq_data).^2);
%     xlim([0 2000]);ylim([0 100]);
%     ylabel('Amplitude'), xlabel('Frequency')
%     title(['Frequency Data #',int2str(n),' Max Peak = ',int2str(vl.analysis_data(n).max_peaks)]),
%     pause;
% end
%
% % Non insects
% for n=1:1000
%      plot(stat.statistics_b.noninsect(n).positive_data);
%      title(['Time Data #',int2str(n)]),
%      pause;
% end

%% Train data
% Non-insect data metrics calulated first
for m = 1:length(non_insects)%use this to properly stack m in train_class
    % Get peaks
    [non_amp_peaks,non_freq_peaks] = findpeaks(abs(...
        stat.statistics_b.noninsect(non_insects(m)).fft_data(513:688)).^2);
    partial_fqdata = stat.statistics_b.noninsect(non_insects(m)).fft_frequency(513:688);
    max_peak_fq = non_freq_peaks(non_amp_peaks==max(non_amp_peaks));
    train_class_ex(m,1) = partial_fqdata(max_peak_fq); %find max location
    train_class_ex(m,2) = max(non_amp_peaks).^2; %max amplitude
    
    kurt_window = [(max_peak_fq-5)+513,(max_peak_fq+5)+513];% target freq window
    train_class_ex(m,3) = kurtosis(abs(stat.statistics_b.noninsect(non_insects(m)).fft_data(kurt_window(1):kurt_window(2))).^2);
 
    positive_data = stat.statistics_b.noninsect(non_insects(m)).positive_data;
    
    % Positive data peak deviation finder in rawish time data, amp
    [ins_amp_peaks,ins_freq_peaks] = findpeaks(positive_data);
    ins_peak_std = std(ins_amp_peaks);
    ins_peak_mean = mean(positive_data);
    ins_peak_min = min(ins_amp_peaks);
    ins_peak_max = max(ins_amp_peaks);
    
    % peak deviation metric
    ins_peak_dev = ins_peak_max - ins_peak_min;
    train_class_ex(m,4) = ins_peak_dev;
    
    % calculate number of max and min peaks to find ratio
    ins_peak_max_num = sum(ins_amp_peaks>(ins_peak_max*0.3));
    if ins_peak_max_num == 0
        ins_peak_max_num = 1;
    end
    ins_peak_min_num = sum(ins_amp_peaks<(ins_peak_max*0.3));
    if ins_peak_min_num == 0
        ins_peak_min_num = 1;
    end
    ins_peak_ratio = ins_peak_max_num/ins_peak_min_num;
    train_class_ex(m,5) = ins_peak_ratio;
    
    % Number of max peaks
    train_class_ex(m,6) = ins_peak_max_num;
    
    % Harmonic mean
    train_class_ex(m,7) = harmmean(ins_amp_peaks);

    % All non_insects tagged with a negative input
    index(m) = 0;
    
end
% Insect data metrics calulated second
c=0; %variable to initialize correct spot in insects table
for m=length(non_insects)+1:length(non_insects)+length(insects)% concatonate m in train_class
    c=c+1;
    % FFT Peaks, already given in existing, analysis_data
    train_class_ex(m,1) = round(vl.analysis_data(insects(c)).max_peaks);
    train_class_ex(m,2) = abs(vl.analysis_data(insects(c)).freq_data(find(vl.analysis_data(insects(c)).frequency==vl.analysis_data(insects(c)).max_peaks))).^2;        
    
    % Kurtosis, peak steepness of FFT
    kurt_window = [train_class_ex(m,1)-15,train_class_ex(m,1)+15];%15 is large and similar to non_insect 5
    %Upper kurt window
    tmp_upper = abs(vl.analysis_data(insects(c)).frequency-kurt_window(2));
    [kurt_upper_idx, kurt_upper] = min(tmp_upper); %index of closest value
    %Lower kurt window
    tmp_lower = abs(vl.analysis_data(insects(c)).frequency-kurt_window(1));
    [kurt_lower_idx, kurt_lower] = min(tmp_lower); %index of closest value
    % Find kurtosis at window
    train_class_ex(m,3) = kurtosis(abs(vl.analysis_data(insects(c)).gauss_freq_data(kurt_lower:kurt_upper)).^2);

    % Positive data peak deviation finder in rawish time data, amp
    [ins_amp_peaks,ins_freq_peaks] = findpeaks(vl.analysis_data(insects(c)).positive_data);
    ins_peak_std = std(ins_amp_peaks);
    ins_peak_mean = mean(vl.analysis_data(insects(c)).positive_data);
    ins_peak_min = min(ins_amp_peaks);
    ins_peak_max = max(ins_amp_peaks);
    
    % Peak deviation
    ins_peak_dev = ins_peak_max - ins_peak_min;
    train_class_ex(m,4) = ins_peak_dev;

    % calculate number of max and min peaks to find ratio
    ins_peak_max_num = sum(ins_amp_peaks>(ins_peak_max*0.3));
    if ins_peak_max_num == 0
        ins_peak_max_num = 1;
    end
    ins_peak_min_num = sum(ins_amp_peaks<(ins_peak_max*0.3));
    if ins_peak_min_num == 0
        ins_peak_min_num = 1;
    end
    ins_peak_ratio = ins_peak_max_num/ins_peak_min_num;
    train_class_ex(m,5) = ins_peak_ratio;
    
    % Number of max peaks
    train_class_ex(m,6) = ins_peak_max_num;
    
    % Harmonic mean
    train_class_ex(m,7) = harmmean(ins_amp_peaks);

    % All insects tagged with a positive input
    index(m) = 1;
end

% View training data, identify seperation
[~, length_var] = size(train_class_ex);
%Plot training variables
for k = 1:length_var
    for kk = 1:length_var
        scatter(train_class_ex(1:length(non_insects),k),...
            train_class_ex(1:length(non_insects),kk),'or');
        hold on
        scatter(train_class_ex(length(insects)+1:m,k),...
            train_class_ex(length(insects)+1:m,kk),'og');
        title([func_name{kk},' vs ',func_name{k}]);
        hold off
        pause
    end
end
close gcf;

% SVM table of values
% Radial basis function (RBF) kernel used by the SVM
SVMs.Mdl_var = fitrsvm(train_class_ex(:,3:7),index',...
    'KernelFunction','rbf',...
    'KernelScale','auto');
save('SVM_Model_insect.mat','SVMs');
