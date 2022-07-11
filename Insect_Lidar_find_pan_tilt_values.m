%find_pan_tilt_values

% files=dir(fullfile(pwd));
% files=files(~ismember({files.name},{'.','..','events'}));

fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));

max_pan = -1; 
min_pan = 50;
max_tilt = -1;
min_tilt = 50;


for x=1:size(fols,1) % do -1 if adjusted data is there
    %file=
    %data=load(fullfile(pwd,file(x))); 
    data=load(fullfile(pwd,fols(x).name)); 
    %fn=fieldnames(data);
    p_value = data.full_data.info.Pan;
    t_value = data.full_data.info.Tilt;
    
    %check pan values
    if p_value >= max_pan
        max_pan = p_value;   
    end
    
    if p_value <= min_pan     
        min_pan = p_value;   
    end
    
    %check tilt values
    if t_value >= max_tilt
        max_tilt = t_value;   
    end
    if t_value <= min_tilt     
        min_tilt = t_value;   
    end
    
end
fprintf('maximum pan value is %f\n', max_pan)
fprintf('minimum pan value is %f\n', min_pan)
fprintf('maximum tilt value is %f\n', max_tilt)
fprintf('minimum tilt value is %f\n', min_tilt)
