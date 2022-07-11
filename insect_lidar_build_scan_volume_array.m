%insect_lidar_build_scan_volume_array
%CHANGE DATE IN TWO PLACES
clear
start_file='/Volumes/Insect Lidar/Data_2020';
date='2020-09-16';
filename=fullfile(start_file,date);
disp(filename);
load(fullfile(filename,'events','manual.mat'));
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events','stats'}));

load('/Volumes/Insect Lidar/Data_2020/2020-09-16/events/fftcheck.mat');

for n=1:length(fftcheck.insects)
    whichfol=fftcheck.insects(n).foldernum;
    whichfile=fftcheck.insects(n).filenum;
    whichrange=fftcheck.insects(n).range;
    % Load relevant data 
    load(fullfile(filename,fftcheck.insects(n).name,'adjusted_data_decembercal'));
    
    scan.tilt(n)=adjusted_data_decembercal(whichfile).tilt;
    scan.pan(n)=adjusted_data_decembercal(whichfile).pan;
    scan.distance(n)=adjusted_data_decembercal(whichfile).range(whichrange);
    
end
save(fullfile(pwd,'events','scan.mat'),'scan','-v7.3');
    
    
   