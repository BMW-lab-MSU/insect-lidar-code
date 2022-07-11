%% Background
% f_dir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08';
% 
% % load(fullfile(f_dir,'full_stats.mat'));
% % file=dir(fullfile(f_dir,'AMK*'));
% filename=full_stats.background(1).filename(1:16);
% load(fullfile(f_dir,filename,'adjusted_data.mat'))
% for n=1:length(adjusted_data)
%     fn{n,1}=adjusted_data(n).filename;
% end
% 
% 
% 
% for bg=1:size(full_stats.background,2)-1
%     clear indx
%     [~,indx]=ismember(full_stats.background(bg).data,adjusted_data(strmatch(full_stats.background(bg).filename,fn,'exact')).normalized_data,'rows');
%     full_stats.background(bg).location=indx;
%     if ~strcmp(full_stats.background(bg+1).filename(1:16),full_stats.background(bg).filename(1:16))
%         clear filename fn
%         filename=full_stats.background(bg+1).filename(1:16);
%         load(fullfile(f_dir,filename,'adjusted_data.mat'))
%         for n=1:length(adjusted_data)
%             fn{n,1}=adjusted_data(n).filename;
%         end
%     end
% end
%     clear indx
%     [~,indx]=ismember(full_stats.background(end).data,adjusted_data(strmatch(full_stats.background(end).filename,fn,'exact')).normalized_data,'rows');
%     full_stats.background(end).location=indx;
%% Hard Target
% f_dir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08';
% 
% % load(fullfile(f_dir,'full_stats.mat'));
% % file=dir(fullfile(f_dir,'AMK*'));
% filename=full_stats.hardtarget(1).filename(1:16);
% load(fullfile(f_dir,filename,'adjusted_data.mat'))
% for n=1:length(adjusted_data)
%     fn{n,1}=adjusted_data(n).filename;
% end
% 
% 
% 
% for bg=1:size(full_stats.hardtarget,2)-1
%     clear indx
%     [~,indx]=ismember(full_stats.hardtarget(bg).data,adjusted_data(strmatch(full_stats.hardtarget(bg).filename,fn,'exact')).normalized_data,'rows');
%     full_stats.hardtarget(bg).location=indx;
%     if ~strcmp(full_stats.hardtarget(bg+1).filename(1:16),full_stats.hardtarget(bg).filename(1:16))
%         clear filename fn
%         filename=full_stats.hardtarget(bg+1).filename(1:16);
%         load(fullfile(f_dir,filename,'adjusted_data.mat'))
%         for n=1:length(adjusted_data)
%             fn{n,1}=adjusted_data(n).filename;
%         end
%     end
% end
%     clear indx
%     [~,indx]=ismember(full_stats.hardtarget(end).data,adjusted_data(strmatch(full_stats.hardtarget(end).filename,fn,'exact')).normalized_data,'rows');
%     full_stats.hardtarget(end).location=indx;
%% Insect
f_dir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08';

% load(fullfile(f_dir,'full_stats.mat'));
% file=dir(fullfile(f_dir,'AMK*'));
filename=full_stats.insect(1).filename(1:16);
load(fullfile(f_dir,filename,'adjusted_data.mat'))
for n=1:length(adjusted_data)
    fn{n,1}=adjusted_data(n).filename;
end



for bg=1:size(full_stats.insect,2)-1
    clear indx
    [~,indx]=ismember(full_stats.insect(bg).data,adjusted_data(strmatch(full_stats.insect(bg).filename,fn,'exact')).normalized_data,'rows');
    full_stats.insect(bg).location=indx;
    if ~strcmp(full_stats.insect(bg+1).filename(1:16),full_stats.insect(bg).filename(1:16))
        clear filename fn
        filename=full_stats.insect(bg+1).filename(1:16);
        load(fullfile(f_dir,filename,'adjusted_data.mat'))
        for n=1:length(adjusted_data)
            fn{n,1}=adjusted_data(n).filename;
        end
    end
end
    clear indx
    [~,indx]=ismember(full_stats.insect(end).data,adjusted_data(strmatch(full_stats.insect(end).filename,fn,'exact')).normalized_data,'rows');
    full_stats.insect(end).location=indx;