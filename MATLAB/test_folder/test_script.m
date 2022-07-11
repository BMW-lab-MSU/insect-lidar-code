% 
% image_dir = 'D:\scripts\insect-lidar';
% 
% x = 1:2:20;
% y = 2*x+3;
% 
% figure();
% plot(x,y);
% 
% label_var = 0.49972;
% 
% 
% 
% saveas(gcf,fullfile(image_dir,'test_folder', ['test =' strrep(num2str(label_var), '0.', '')]), 'png');

% noninsect = [3,4,5,6,7];
% 
% 
% noninsect(1)

clear all

image_dir = 'G:\Support vector machine\Data_Processed_by_SVM\Images_SVMProcessor12';

most_likely=dir(fullfile(image_dir,'Most_likely','predict*'));
very_likely=dir(fullfile(image_dir,'Very_likely','predict*'));



