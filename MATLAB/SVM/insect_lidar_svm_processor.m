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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Data
%image directory for saved figures near end of script
%image_dir = 'C:\Users\lauri_000\Desktop\Work\Insect_Project\Images\Detections';

% Load processed data that has been organized by common vector.
prc_dir = 'D:\Data-Test\2016-06-08\processed_data';
prc_file_list = dir(fullfile(prc_dir,'*T*.mat'));

% Load SVM
file_dir = 'D:\scripts\insect-lidar\Support vector machine';
svm_file = dir(fullfile(file_dir,'SVM_Model_insect_seth.mat'));
svm = load(fullfile(file_dir,svm_file.name));

%% Variables and filters
pp = 0; %Table increment

% %Pass Band Filters %%%not used.
% % Filter 1
% passband=[15, 1000]; %can't go higher then 4hz due to period of snapshot
% passband_fs=2048; % Sampling rate 
% filterOrder=1; % Order of filter
% [pass_b,pass_a]=butter(filterOrder, passband/(passband_fs/2)); 

% % Filter 2
% d1 = designfilt('bandpassfir','FilterOrder',3, ...
%          'CutoffFrequency1',20,'CutoffFrequency2',1000, ...
%          'SampleRate',2048);

% Load and process each vector bin.
wbar = waitbar(0,'Loading data');
for n = 1:length(prc_file_list)
    % Load processed lidar data organized into range bins
    prc_file =load(fullfile(prc_dir,prc_file_list(n).name));
    prc_name = fieldnames(prc_file)'; %filenames for struct
    
    % Initialize first hard target
    min_pos = min(min(prc_file.(prc_name{1})(1).normalized_data));
    positive_hard_target = abs(min_pos) + prc_file.(prc_name{1})(1).normalized_data;
    
    % Find hard targets first (average of every image within a vector file.
    for k = 2:length(prc_file.(prc_name{1}))        
        % Get data, adjust data to positive
        min_pos = min(min(prc_file.(prc_name{1})(k).normalized_data));
        positive_hard_target = positive_hard_target+(abs(min_pos) + prc_file.(prc_name{1})(k).normalized_data);
    end
    
    % Normalize hard target
    positive_hard_target = positive_hard_target/(length(prc_file.(prc_name{1})));
    positive_gauss_hard = imgaussfilt(positive_hard_target,1);

    % Find values of hard target
    min_positive_gauss = min(min(positive_gauss_hard));
    max_positive_gauss = max(max(positive_gauss_hard));

    % Normalize gauss
    positive_gauss_norm = (positive_gauss_hard - min_positive_gauss)./...
        (max_positive_gauss - min_positive_gauss);
    
    % Process each range bin from the sorted vector bin.
    for b = 1:length(prc_file.(prc_name{1}))
        waitbar(b/length(prc_file.(prc_name{1})),...
            wbar,['Loading data ',int2str(n),': '...
            int2str(b),' of ', int2str(length(prc_file.(prc_name{1})))]);
        drawnow;
        
        % Filenames for titles
        [AMK,file] = fileparts(prc_file.(prc_name{1})(b).filename);
        
        min_pos = min(min(prc_file.(prc_name{1})(b).normalized_data));
        positive_data = abs(min_pos) + prc_file.(prc_name{1})(b).normalized_data;
        %%%%%%%%%% NOT removing hard targets b/c they introduce undesired
        %%%%%%%%%% responses. Injects varying frequency responses.
%         % Subtract hard target
%         positive_data_no_t = positive_data(positive_gauss_norm<0.5);
        positive_data_no_t = imgaussfilt(positive_data,1);
        
        % Store and sum data
        bin_num = 1:3:178; % Sum 2 range bins
        for j=1:length(bin_num)-1
            positive_stacked(j,:) = sum(positive_data_no_t(bin_num(j):bin_num(j+1),:));
        end
        
        %%% This should be changed %%%
        % Time series data
%         time_data = prc_file.(prc_name{1})(k).time;        
        time_data_test = 0:0.226/1023:0.226;
        time_data= time_data_test;
        
        % FFT and processes each data set (2 range bins) in positive_stacked.
        for kk = 1:length(bin_num)-1
            %% Adjust and Filter
            % Mean and max of stacked data
            pos_stack_mean = mean(positive_stacked(kk,:));
            pos_stack_max = max(positive_stacked(kk,:));
       
            % Remove negative values and flip curve
            positive_stacked(kk,:) = abs(positive_stacked(kk,:)-pos_stack_max);

            % ====== band-pass filter      % Can't use filtfilt because it
            % alters time series plot to much
            % first filter tried
%             positive_stacked(kk,:) = filtfilt(d1,positive_stacked(kk,:)); 
            % second filter tried
%             positive_stacked(kk,:) = filtfilt(pass_b,pass_a,positive_stacked(kk,:));
%             positive_stacked_norm(kk,:) = abs(positive_stacked(kk,:)-max(positive_stacked(kk,:)));

            %% FFT
            nop=size(positive_stacked(kk,:),2);
            delta_t=mean(time_data);
            max_freq=1./(2*delta_t);
            delta_f=1/time_data(end);
            fqdata=(-nop/2:nop/2-1).*delta_f;
            freq_data=fftshift(fft(positive_stacked(kk,:),nop,2),2);
            
            log_func = [zeros(1,3),log(1:173).^(1/2)];
            max_lg = max(log_func);
            log_func = log_func/max_lg;
            
%             %% First and Second SVM
%             label_raw = predict(svm.SVMs.Mdl_raw,test_raw);
                    
            %% Process Metrics Data
            % Find fundamental and amplitude  
            [non_amp_peaks,non_freq_peaks] = findpeaks((log_func.*abs(freq_data(513:688))).^2);
            partial_fqdata = fqdata(513:688); % partial frequency data (0hz to 1000Hz)           
            % Test_class_ex stores the metrics used by our SVM
            % Fundamental frequency (not perfect)
            test_class_ex(1) = partial_fqdata(non_freq_peaks(non_amp_peaks==max(non_amp_peaks)));
            test_class_ex(2) = max(non_amp_peaks); %max amplitude
                
            % Kurtosis, peak steepness of FFT
            kurt_window = [non_freq_peaks(non_amp_peaks==max(non_amp_peaks))-5+513,...
                513+non_freq_peaks(non_amp_peaks==max(non_amp_peaks))+5]; %fft window to calc kurt.
            test_class_ex(3) = kurtosis(abs(freq_data(kurt_window(1):kurt_window(2))).^2);

            % Positive data peak deviation finder in rawish time data, amp
            [ins_amp_peaks,ins_freq_peaks] = findpeaks(positive_stacked(kk,:));
            ins_peak_std = std(ins_amp_peaks);
            ins_peak_mean = mean(positive_stacked(kk,:));
            ins_peak_min = min(ins_amp_peaks);
            ins_peak_max = max(ins_amp_peaks);
            
            % Peak deviation metric
            ins_peak_dev = ins_peak_max - ins_peak_min;
            test_class_ex(4) = ins_peak_dev;

            % Peak ratio calculation of max and min peaks
            % % several parameters were used, this was the best
            ins_peak_max_num = sum(ins_amp_peaks>(ins_peak_max*0.3));
            if ins_peak_max_num == 0
                ins_peak_max_num = 1;
            end
            ins_peak_min_num = sum(ins_amp_peaks<(ins_peak_max*0.3));
            if ins_peak_min_num == 0
                ins_peak_min_num = 1;
            end
            ins_peak_ratio = ins_peak_max_num/ins_peak_min_num;          
            test_class_ex(5) = ins_peak_ratio;

            % Total number of max peaks, value low for insect, high for
            test_class_ex(6) = ins_peak_max_num;
            
%             % SNR calculation, not used anymore
%             test_class_ex(6) = snr(abs(freq_data(513:688)).^2,1024);

            % Harmonic mean
            test_class_ex(7) = harmmean(ins_amp_peaks);

            %% SVM Prediction
            label_var = predict(svm.SVMs.Mdl_var,test_class_ex(3:7));
            
            %% Select probable insects, Create Plot and Table
            if label_var > 0.85 && max(non_amp_peaks) > 0.1  % ignore plots that have low fft amplitudes
%                 %% Plot output
%                 subplot(2,2,1),imagesc(positive_data_no_t);
%                 title('Raw Data');
%                 xticks(time_data)
%                 try
%                     subplot(4,2,5),imagesc(positive_data_no_t(bin_num(kk)-3:bin_num(kk)+3,:));
%                     title(['Windowed Data, Starting at ',num2str(bin_num(kk))]);
%                 catch
%                     subplot(4,2,5),imagesc(positive_data_no_t(bin_num(kk):bin_num(kk),:));
%                     title(['Windowed Data, Starting at ',num2str(bin_num(kk))]);
%                 end
% %                 xticks(time_data)
%                 subplot(4,2,7),imagesc(positive_gauss_norm);
%                 title('Hard Targets');
%                 xticks(time_data)
%                 subplot(3,2,2),plot(time_data,positive_stacked(kk,:));
% %                 title(['Var= ',num2str(label_var),' Frq= ',num2str(label_fft)]);
%                 title(['SVM Prediction = ',num2str(label_var)]);
% %                 ylim([0 1])
%                 subplot(3,2,4),plot(fqdata(513:688),(log_func.*abs(freq_data(513:688))).^2);
% 
% %                 xlim([0 1500]);
% %                 ylim([0 max((abs(freq_data(end/2+10:end)).^2))+2]);
%                 xlabel('Frequency (Hz)')
%                 ylabel('Power (dB)')   
%                 title([num2str(kk),', ',num2str(b),' - ',prc_file.(prc_name{1})(b).filename]);
% %                 title('Frequency Spectrum');
%                 subplot(3,4,12),plot(abs(freq_data(kurt_window(1):kurt_window(2))).^2);
%                 title('Kurtosis');
%                 f = figure(1);
%     %             set(f,'Position',[500 500 300 150]);
%                 dat =  {' Max Peak        ', test_class_ex(1), ' Hz';...
%                         ' Max Amp         ', test_class_ex(2), ' units';...   
%                         ' Kurtosis        ', test_class_ex(3), ' units';...
%                         ' Peak Deviation  ', test_class_ex(4), ' units';...
%                         ' Peak Ratio      ', test_class_ex(5), ' units';...
%                         ' Number of Peaks ', test_class_ex(6), ' units';...
%                         ' Harmonic Mean   ', test_class_ex(7), ' units';...
%                         ' Filename        ', prc_file.(prc_name{1})(b).filename, '      '};
%                 columnname =   {' Parameter         ',' Value ', ' Units '};
%                 columnformat = {'char', 'numeric', 'char'}; 
%                 t = uitable('Units','normalized','Position',...
%                 [0.575 0.035 0.1384 0.295], 'Data', dat,... 
%                 'ColumnName', columnname,...
%                 'ColumnFormat', columnformat,...
%                 'RowName',[]);
%                 pause;
                
                % Create table
                pp = pp + 1;
                t_filename{pp} = prc_file.(prc_name{1})(b).filename;
                t_predict{pp} = label_var;
                t_dist{pp} = bin_num(kk);
                t_peak{pp} = test_class_ex(1);%peak
                t_amp{pp} = test_class_ex(2);%peak amp
                t_kurt{pp} = test_class_ex(3);%kurtosis
                t_dev{pp} = test_class_ex(4);%dev
                t_ratio{pp} = test_class_ex(5);%ratio
                t_peaknum{pp} = test_class_ex(6);%peaknum
                t_harm{pp} = test_class_ex(7);%harmonic mean
                t_graph{pp} = positive_data_no_t;
                t_n{pp} = n; % Used
                t_b{pp} = b;

%                 %% Save Plot Output
%                 if label_var > 0.9 && max(non_amp_peaks)>0.5
%                     saveas(gcf,fullfile(image_dir,'Very_likely',[AMK,'-',file]),'png'); 
%                 elseif label_var > 0.8 && max(non_amp_peaks)>0.5
%                     saveas(gcf,fullfile(image_dir,'Most_likely',[AMK,'-',file]),'png');
%                 elseif label_var > 0.7 && max(non_amp_peaks)>0.5
%                     saveas(gcf,fullfile(image_dir,'Somewhat_likely',[AMK,'-',file]),'png');
%                 end
            end
        end
    end
end

close(gcf);
close(wbar);

% Create table
t_row = {'Filename','Prediction','Distance','Peak (Hz)','Amplitude',...
    'Kurtosis','Seperation','Peak Ratio','Peak Number','Harmonic Mean'};
T = table(t_filename(:),t_predict(:),t_dist(:),t_peak(:),t_amp(:),t_kurt(:),...
    t_dev(:),t_ratio(:),t_peaknum(:),t_harm(:));

% Create structure (contains raw bin data)
T_struct = {t_filename(:),t_predict(:),t_dist(:),t_peak(:),t_amp(:),t_kurt(:),...
    t_dev(:),t_ratio(:),t_peaknum(:),t_harm(:),t_graph(:),t_b(:),t_n(:)};

% Go through each set of values in T_struct...
for nn = 1:length(t_graph)
    subplot(2,1,1),imagesc(t_graph{nn});
    title(['Predict = ',num2str(t_predict{nn}),', Distance = ',num2str(t_dist{nn}),...
        ', b = ',num2str(t_b{nn}),', n = ',num2str(t_n{nn}),]);
    try %Windowed data
        subplot(2,1,2),imagesc(t_graph{nn}(t_dist{nn}-2:t_dist{nn}+2,:));
    catch
        subplot(2,1,2),imagesc(t_graph{nn}(t_dist{nn}:t_dist{nn},:));
    end
    title(['Predict = ',num2str(t_predict{nn}),', Distance = ',num2str(t_dist{nn}),...
        ', b = ',num2str(t_b{nn}),', n = ',num2str(t_n{nn}),]);
    pause
end