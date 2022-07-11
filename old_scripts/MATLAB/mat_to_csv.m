outer_dir = 'E:\Data\2018-07-07\';
amks = dir(fullfile(outer_dir,'AMK*'));
for m = 1:size(amks,1)
    if ~exist(fullfile(outer_dir,amks(m).name,'csv'),'dir')
        mkdir(fullfile(outer_dir,amks(m).name,'csv'))
    end
    clear adjusted_data
    load(fullfile(outer_dir,amks(m).name,'adjusted_data.mat'));
    for n =1:size(adjusted_data,2)
        filen=sprintf('T%3.2fP%3.2f',adjusted_data(n).tilt,adjusted_data(n).pan);
        filen(strfind(filen,'.'))='_';
        temp = adjusted_data(n).normalized_data;
        csvwrite(fullfile(outer_dir,amks(m).name,'csv',[filen,'.csv']), temp);
    end
end


a = 'F:\2018-07-07'
for n = 1:12;
    mkdir(fullfile(a,num2str(n)))
end