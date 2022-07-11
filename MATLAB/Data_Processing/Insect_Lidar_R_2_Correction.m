%Script for performing an R^2 correction to decovnvole to signals 
%October 16th, 2018

%function [adjusted_data.normalized data] = R_2_Correction(date);

K = 7;
N = 9;

load('D:\Data-Test\2016-06-08\processed_data\222-T15_00P40_00.mat');
indx = 0;
for n=[1:K,N:11,13:17]
    
indx = indx + 1;
Mean(:,indx) = mean(T15_00P40_00(n).normalized_data,2);

end

final_mean = mean(Mean,2);


figure();
plot(T15_00P40_00(1).range, final_mean);




