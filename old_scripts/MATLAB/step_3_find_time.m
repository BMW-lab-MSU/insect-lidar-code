function [exact_time,exact_dnum]=step_3_find_time(start_file,date,fn,data,manual_insects,n)    
dateinfo_dir=[start_file,'\Stored Data\',date];
    dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
    dateinfo=dateinfo([dateinfo.isdir]);
    for k=1:size(dateinfo,1);run_time(k,:)=datenum(dateinfo(k).name(11:end),'HHMMSS');end
    mode_run_time=mode(diff(run_time));
    
    exact_dnum=datenum([date,'-',num2str(str2num(data.(fn{:})(manual_insects(n).y).filename(11:16))+...
        str2num(datestr(mode_run_time*(str2num(data.(fn{:})(manual_insects(n).y).filename(18:22))/230),'HHMMSS')))],...
        'yyyy-mm-dd-HHMMSS');
    
    exact_time=datestr(exact_dnum,'yyyy-mm-dd HH:MM:SS');