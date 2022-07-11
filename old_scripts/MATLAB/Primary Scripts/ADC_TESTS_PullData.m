function []=ADC_TESTS_PullData(di)

if isempty(di)==1
    date = input('Extract Files From Which Date?','s');
else
    date = di;
end

fulldir=strcat('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',date);
files = dir(fullfile(fulldir,'*.mat'));
pullamt = length(files);

for n=1:pullamt
    fulldirfile = strcat(fulldir,'\',files(n).name);
    data(n).data = load(fulldirfile);
    nameoffile = strsplit(files(n).name,'.');
    data(n).name = nameoffile(1);
end
end

