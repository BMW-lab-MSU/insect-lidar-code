%%Insect Lidar Normalized Data |2018-05-23|

function [adjusted_data]=Insect_Lidar_Normalized_Data(date)

%base directory 
addpath('/mnt/lustrefs/store/clarissa.deleon/insect-lidar/');
stored_data= '/mnt/lustrefs/store/clarissa.deleon/Data/';

%Create date directory
date_dir = fullfile(stored_data, date);

%run through all of the AMK Ranch files on the stored data 
runs=dir(fullfile(date_dir,'/AMK_Ranch*'));

%Create  vector of the run data i.e. the data from AMK Ranch
rn_vec=1:size(runs,1);


for rn = rn_vec
    
%load in the adjusted data for each run 
   load(fullfile(date_dir,runs(rn).name,'adjusted_data.mat'));
   
%Normalization code
   for m = 1:size(adjusted_data,2)

%adjust the data to be centered at the data median
       clear temp_median
       temp_median = median(adjusted_data(m).data,2);
        a = adjusted_data(m).data - temp_median;
 
%Flip the data to create positive signals 
        adjusted_data(m).normalized_data = -a;
        
%Find the maximum  of the flipped data
        M = max(max([adjusted_data(m).normalized_data]));
        
%Divide the data by the max to set the max to 1
        adjusted_data(m).normalized_data = -a/M;
       
       
   end
   
%Save the adjusted data file
   save(fullfile(date_dir,runs(rn).name,['adjusted_data','.mat']),'adjusted_data','-v7.3');

end
end
    
    