%% Movefiles

stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08'; %Rack Directory
dateinfo=dir(fullfile(stored_data,'AMK*'));
dateinfo=dateinfo([dateinfo.isdir]);

for n=1:size(dateinfo,1)
    mkdir(fullfile(stored_data,dateinfo(n).name),'raw_data');
    files=dir(fullfile(stored_data,dateinfo(n).name,'0*'));
    for m=1:size(files,1)
        movefile(fullfile(stored_data,dateinfo(n).name,files(m).name),fullfile(stored_data,dateinfo(n).name,'raw_data',files(m).name));
    end
    
end

