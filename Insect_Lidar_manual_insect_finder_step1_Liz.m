%% Insect_Lidar_manual_insect_finder_step1_Liz | Martin Tauc & Liz Rehbein | 2020-09-08

clear

% fols is all vectors
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));
% if the manual process was already started, this will load the saved file
% and start counting at the right values
if exist('/Volumes/Insect Lidar/Data_2020/2020-09-20/events/manual.mat','file')~=0
    load('/Volumes/Insect Lidar/Data_2020/2020-09-20/events/manual.mat');
    int=size(manual.insects,2);
    mnt=size(manual.maybe_insect,2);
    nnt=size(manual.noninsect,2);
    start=manual.lastcompleted+1;
else
    mkdir events
    int=0;
    mnt=0;
    nnt=0;
    n=1;
    start=1;
end



% loop through each run scan and classify the if insect or maybe or not
for x=start:size(fols,1)
    clear data fn
    % load vector
    data=load(fullfile(pwd,fols(x).name,'adjusted_data_decembercal'));
    
    % determine filenames
    %fn=fieldnames(data.adjusted_data_decembercal);
    
    filenumber=size(data.adjusted_data_decembercal,2); %number of files in folder x 
   
    for y=1:filenumber
        n=1;
        % plot each scan
        figure(1)
        
        % !!! FIX RANGE ON PLOT CAUSE IT IS BACKWARDS UGH !!!
        imagesc(data.adjusted_data_decembercal(y).normalized_data)
        
        %image(data.(fn{1})(y).normalized_data);
        %caxis([min(min(data.(fn{1})(y).normalized_data)) 0.3*max(max(data.(fn{1})(y).normalized_data))]);
        % title for reference
        title(sprintf('%s : File %i of %i',fols(x).name,y,filenumber),'interpreter','none');
        ylabel('Range Bin');
        xlabel('Pulse Number');
        
        while n==1
        % user decides if there is an insecct present, maybe an insect
        % present, or not an insect present
        yn=input('insect (q) or not (w) or maybe (e) ? ','s');
        % depending on classification, the vector name and run name are
        % stored along with the corresponding filename from the scan folder
        if strcmp(yn,'q')
            int=int+1;
            n=0;
            manual.insects(int).name=fols(x).name;
            manual.insects(int).foldernum=x;
            manual.insects(int).filenum=y;
        elseif strcmp(yn,'w')
            n=0;
            nnt=nnt+1;
            manual.noninsect(nnt).name=fols(x).name;
            manual.noninsect(nnt).foldernum=x;
            manual.noninsect(nnt).filenum=y;
        elseif strcmp(yn,'e')
            n=0;
            mnt=mnt+1;
            manual.maybe_insect(mnt).name=fols(x).name;
            manual.maybe_insect(mnt).foldernum=x;
            manual.maybe_insect(mnt).filenum=y;
        else
            disp('invalid choice');
            n=1;
        end
        end
    end
    manual.lastfilename=fols(x).name;
    manual.lastcompleted=x;
    save(fullfile(pwd,'events','manual.mat'),'manual','-v7.3')
end

