clear all
close all

%% Script to sort through data for SVM
%---------------Finding Best Insects-------------------------%
% Load Training data
data_dir = 'D:\Data-Test\2016-06-08\processed_data\Training_Data_new';
data_file_sl = dir(fullfile(data_dir,'sl*.mat'));
data_file_vl = dir(fullfile(data_dir,'vl*.mat'));
sl = load(fullfile(data_dir,data_file_sl.name));
vl = load(fullfile(data_dir,data_file_vl.name));


int=0;
mnt=0;
nnt=0;


for n = 1:1:size(sl.analysis_data,2)
%for n = 1:1:6
close all
figure();
subplot(2,1,1)
plot(sl.analysis_data(n).time,sl.analysis_data(n).positive_data)
ylabel('Positive Data');
xlabel('Time')
hold on 

subplot(2,1,2)

plot(sl.analysis_data(n).frequency,sl.analysis_data(n).freq_power)
ylabel('Freq Data');
xlabel('Frequency');
xlim([0 inf]);

yn=input('good insect (a) or semi good insect (s) or not good insect (w) ? ','s');
        % depending on classification, the field number is saved
        if strcmp(yn,'a')
            int = int +1;
            sorted_insects_svm.good(int).y = n;
         
    elseif  strcmp(yn,'s')
            mnt = mnt + 1;
            sorted_insects_svm.semigood(mnt).y = n;
            
    elseif  strcmp(yn,'w')
            nnt = nnt + 1;
            sorted_insects_svm.notgood(nnt).y = n;
            
        else
            
        end
         

end


for i = 1:1:size(vl.analysis_data,2)
%for i = 1:1:6

figure();
subplot(2,1,1)
plot(vl.analysis_data(i).time,vl.analysis_data(i).positive_data)
ylabel('Positive Data');
xlabel('Time')
hold on 

subplot(2,1,2)
plot(vl.analysis_data(i).frequency,vl.analysis_data(i).freq_power)
ylabel('Freq Data');
xlabel('Frequency')
xlim([0 inf]);

yn=input('good insect (a) or semi good insect (s) or not good insect (w) ? ','s');
        % depending on classification, the field number is saved
        if strcmp(yn,'a')
            int = int +1;
            sorted_insects_svm.good(int).y = i;
         
    elseif  strcmp(yn,'s')
            mnt = mnt + 1;
            sorted_insects_svm.semigood(mnt).y = i;
            
    elseif  strcmp(yn,'w')
            nnt = nnt + 1;
            sorted_insects_svm.notgood(nnt).y = i;
            
        else
            
        end
         

end



%% Find noninsects
 

disp('Now doing noninsects');

% data_dir = 'D:\Data-Test\2016-06-08\processed_data\Training_Data_new';
% data_file_vu = dir(fullfile(data_dir,'vu*.mat'));
% data_file_su = dir(fullfile(data_dir,'su*.mat'));
% vu = load(fullfile(data_dir,data_file_vu.name));
% su = load(fullfile(data_dir,data_file_su.name));
% 
% int=0;
% mnt=0;
% nnt=0;
% 
% 
% for n = 1:1:size(vu.analysis_data,2)
% %for n = 1:1:6
% close all
% figure();
% subplot(2,1,1)
% plot(vu.analysis_data(n).time,vu.analysis_data(n).positive_data)
% ylabel('Positive Data');
% xlabel('Time')
% hold on 
% 
% subplot(2,1,2)
% plot(vu.analysis_data(n).frequency,vu.analysis_data(n).freq_power)
% ylabel('Freq Data');
% xlabel('Frequency')
% xlim([0 inf]);
% 
% yn=input('good noninsect (a) or semi good noninsect (s) or bad noninsect (w) ? ','s');
%         % depending on classification, the field number is saved
%         if strcmp(yn,'a')
%             int = int +1;
%             sorted_insects.goodnoninsects(int).y = n;
%          
%     elseif  strcmp(yn,'s')
%             mnt = mnt + 1;
%             sorted_insects.semigoodnoninsects(mnt).y = n;
%             
%     elseif  strcmp(yn,'w')
%             nnt = nnt + 1;
%             sorted_insects.badnoninsect(nnt).y = n;
%             
%         else
%             
%         end
% 
% end
% 
% for i = 1:1:size(su.analysis_data,2)
% %for i = 1:1:6
% 
% figure();
% subplot(2,1,1)
% plot(su.analysis_data(i).time,su.analysis_data(i).positive_data)
% ylabel('Positive Data');
% xlabel('Time')
% hold on 
% 
% subplot(2,1,2)
% plot(su.analysis_data(i).frequency,su.analysis_data(i).freq_power)
% ylabel('Freq Data');
% xlabel('Frequency')
% xlim([0 inf]);
% 
% yn=input('good noninsect (a) or semi good noninsect (s) or bad noninsect (w) ? ','s');
%         % depending on classification, the field number is saved
%         if strcmp(yn,'a')
%             int = int +1;
%             sorted_insects.goodnoninsects(int).y = i;
%          
%     elseif  strcmp(yn,'s')
%             mnt = mnt + 1;
%             sorted_insects.semigoodnoninsects(mnt).y = i;
%             
%     elseif  strcmp(yn,'w')
%             nnt = nnt + 1;
%             sorted_insects.badnoninsect(nnt).y = i;
%             
%         else
%             
%         end
%          
% 
% end

data_dir = 'D:\Data-Test\2016-06-08\processed_data\Training_Data_new';
load(fullfile(data_dir,'statistics_b'));

int=0;
mnt=0;
nnt=0;

for t = 1:1:length(statistics_b.noninsect)
    %close all
    figure(); 
    subplot(2,1,1);
    plot(statistics_b.noninsect(t).time,statistics_b.noninsect(t).positive_data);
    ylabel('Positive Data');
    xlabel('Time');
    hold on 
    
    subplot(2,1,2);
    plot(statistics_b.noninsect(t).fft_frequency, statistics_b.noninsect(t).fft_power);
    ylabel('Frequency');
    xlabel('Power');
    xlim([0 inf]);
    
    yn = input('good noninsect (a) or semigood noninsect (s) or bad noninsect (w)', 's');
    
%    depending on classification, the field number is saved
        if strcmp(yn,'a')
            int = int +1;
            sorted_insects_svm.goodnoninsects(int).y = t;
         
    elseif  strcmp(yn,'s')
            mnt = mnt + 1;
            sorted_insects_svm.semigoodnoninsects(mnt).y = t;
            
    elseif  strcmp(yn,'w')
            nnt = nnt + 1;
            sorted_insects_svm.badnoninsect(nnt).y = t;
            
        else
            
        end
    
end
%%
save(fullfile(data_dir,'sorted_insects_svm.mat'),'-struct','sorted_insects_svm');






