clear all
date='2014-07-09';

fulldir=strcat('C:\Users\user\Documents\MATLAB\Insect Lidar\Lab Tests\Stored Data\',date);
files = dir(fullfile(fulldir,'*.mat'));
pullamt = length(files);

for n=1:pullamt
    fulldirfile = strcat(fulldir,'\',files(n).name);
    data(n).data = load(fulldirfile);
    data(n).name = files(n).name;
end

clear date files fulldir fulldirfile n pullamt