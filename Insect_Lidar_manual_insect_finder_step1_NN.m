%% Insect_Lidar_manual_insect_finder_step1_NN | Martin Tauc | 2017-02-01
% Last Updated: 2019-08-02 by Liz Rehbein
% Modified from Insect_Lidar_maunal_insect_finder_step1
% in order to build a training dataset for a neural network.

% fols is all vectors
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));
% if the manual process was already started, this will load the saved file
% and start counting at the right values
if exist('/Volumes/Insect Lidar/Data_2020/2020-09-16/events/manual.mat','file')~=0
    load('/Volumes/Insect Lidar/Data_2020/2020-09-16/events/manual.mat');
    done = manual.lastcompleted;
    start = done+1;
    goodinput=0;
else
    mkdir events
    manual = struct('insect',[],'non_insect',[],'maybe_insect',[],'lastfilename',[],'lastcompleted',[]);
    done = 0;
    start = 1;
    %n=1;
    goodinput=0;
end

fname = fieldnames(manual);

% loop through each run within each vector and classify the if insect 
for x=start:size(fols,1)
    clear data fn
    % load vector
    data=load(fullfile(pwd,fols(x).name,'adjusted_data_decembercal'));
    % determine filenames
    fn=fieldnames(data.adjusted_data_decembercal);
    ss = size(data.adjusted_data_decembercal,2);
    for y=1:ss
        n=1;
        goodinput==0
        % plot each run
        figure(1)
        imagesc(data.adjusted_data_decembercal(y).normalized_data)
        % title for reference
        title(sprintf('%s : File %i of %i',fols(x).name,y,ss),'interpreter','none');
        ylabel('Range Bin');
        xlabel('Time');
        %caxis([min(min(data.(fn{1})(y).normalized_data)) 0.3*max(max(data.(fn{1})(y).normalized_data))]);
        colorbar

        figure(2)
        meandata=mean(data.adjusted_data_decembercal(y).normalized_data,2);       
        for z=1:178
            subtractor=meandata(z);
            meandata_mod = data.adjusted_data_decembercal(x).normalized_data(z,:)-subtractor;
            if z==1
                mean_sub_data = meandata_mod;
            else
                mean_sub_data = [mean_sub_data;meandata_mod];
            end
        end
        imagesc(mean_sub_data)
        title('Mean Subtracted Norm');
        ylabel('Range Bin');
        xlabel('Time');
        colorbar
        
        %while n==1
        % user decides if there is an insect present, maybe an insect
        % present, or not an insect present
        while goodinput==0
        yn=input('insect (q) or not (w) or maybe (e) ? ','s');
        
        if strcmp(yn,'q')==1 || strcmp(yn,'w')==1 ||  strcmp(yn,'e')==1
            goodinput = 1;
        else
            goodinput = 0;
        end   
        end
        % depending on classification, the vector name and run name are
        % stored along with the corresponding filename from the scan folder
       
        switch yn
            case 'q'
                indx = 1;
            case 'w'
                indx = 2;
            case 'e'
                indx = 3;
           
        end 
  
        count = length(manual_(fname{indx})); 
       
        
        manual_(fname{indx})(count+1).filename=fols(x).name;
        manual_(fname{indx})(count+1).folder=fols(x).folder;
        manual_(fname{indx})(count+1).date=fols(x).date;
        manual_(fname{indx})(count+1).datenum=fols(x).datenum;
        manual_(fname{indx})(count+1).x=x;
        manual_(fname{indx})(count+1).y=y;
        
        %n=0;
     
        end
       
        %end for n while
        %disp(y)
%         if y == ss
%             manual.last_completed = x;
%             save(fullfile(pwd,'eventsNN','manual.mat'),'last_completed')
%         end
    manual.lastfilename=fols(x).name;
    manual.lastcompleted=x;
    fnstring = char(fn);
    finish="saving manual.mat for " + fnstring;
    disp(finish)
    save(fullfile(pwd,'events','manual.mat'),'manual','-v7.3')
    if x == size(fols,1)
        disp('done with these files')
    else
    disp('starting next file')
    end
end
