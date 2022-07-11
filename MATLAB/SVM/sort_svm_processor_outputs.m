%% Sort SVM_Processor_Output
%%Script for sorting through processed data and determining fasle positives
%% Clarissa DeLeon 
%% 2019-05-13
clear all
image_dir = 'G:\Support vector machine\Data_Processed_by_SVM\Images_SVMProcessor12';
most_likely=dir(fullfile(image_dir,'Most_likely','predict*'));
very_likely=dir(fullfile(image_dir,'Very_likely','predict*'));
somewhat_likely=dir(fullfile(image_dir,'Somewhat_likely','predict*'));
load(fullfile(image_dir,'MostLikely_stats.mat'));
load(fullfile(image_dir,'VeryLikely_stats.mat'));

t = exist(fullfile(image_dir, 'false_positives'),'dir');

if t == 0

mkdir(image_dir, 'false_positives');
addpath(fullfile(image_dir,'false_positives'));

end

t = exist(fullfile(image_dir, 'found_insects'),'dir');

if t == 0

mkdir(image_dir, 'found_insects');
addpath(fullfile(image_dir,'found_insects'));

end

%Most_likely

for m = 1:1:length(most_likely)
close all
n = 1;
%check = imread(most_likely(m).name);
check = openfig(fullfile(most_likely(m).folder,most_likely(m).name));

%figure();
%set(gcf, 'Position', get(0, 'Screensize'));
%image(check);
%axis off


        while n==1
            
        yn=input('insect (y) or false positive (f)?','s');
        
        if strcmp(yn,'y') 
            n=0;
            %saveas(gcf,fullfile(image_dir,'found_insects',most_likely(m).name), 'png'); 
            [row, col] = find(MostLikely_stats.PredictValue == most_likely(m).name);
            
        elseif strcmp(yn,'f')
            n=0;
            %saveas(gcf,fullfile(image_dir,'false_positives',most_likely(m).name), 'png'); 
             [row, col] = find(MostLikely_stats.PredictValue == most_likely(m).name);
       
        else
            disp('invalid choice');
            n=1;
        end
        end

end

%very_likely

for h = 1:1:length(very_likely)
close all
n = 1;
check = imread(very_likely(h).name);
figure();
set(gcf, 'Position', get(0, 'Screensize'));
image(check);
axis off
 

         while n==1
            
        yn=input('insect (y) or false positive (f)?','s');
        
        if strcmp(yn,'y') 
            n=0;
            saveas(gcf,fullfile(image_dir,'found_insects',very_likely(h).name), 'png'); 
        
        elseif strcmp(yn,'f')
            n=0;
            saveas(gcf,fullfile(image_dir,'false_positives',very_likely(h).name), 'png'); 
       
        else
            disp('invalid choice');
            n=1;
        end
        end


end

%somewhat_likely

% for s = 1:1:length(somewhat_likely)
% close all
% n = 1;
% check = imread(somewhat_likely(s).name);
% figure();
% set(gcf, 'Position', get(0, 'Screensize'));
% image(check);
% axis off
% 
% 
%          while n==1
%             
%         yn=input('insect (y) or false positive (f)?','s');
%         
%         if strcmp(yn,'y') 
%             n=0;
%             saveas(gcf,fullfile(image_dir,'found_insects',somewhat_likely(m).name), 'png'); 
%         
%         elseif strcmp(yn,'f')
%             n=0;
%             saveas(gcf,fullfile(image_dir,'false_positives',somewhat_likely(m).name), 'png'); 
%        
%         else
%             disp('invalid choice');
%             n=1;
%         end
%         end
% 
% 
% end

