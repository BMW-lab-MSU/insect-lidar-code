%% Insect_Lidar_manual_insect_finder_step1 | Martin Tauc | 2017-02-01

% fols is all vectors
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));
% if the manual process was already started, this will load the saved file
% and start counting at the right values
if exist('I:\Data_Test\2010-10-10\processed_data\events\manual.mat','file')~=0
    load('I:\Data_Test\2010-10-10\processed_data\events\manual.mat');
%     int=size(manual.insects,2);
%     mnt=size(manual.maybe_insect,2);
%     nnt=size(manual.noninsect,2);
else
    mkdir events
    int=01;
    mnt=0;
    nnt=0;
    n=1;
end


% loop through each run within each vector and classify the if insect or
% maybe or not
for x=1:size(fols,1)
    clear data fn
    % load vector
    data=load(fullfile(pwd,fols(x).name));
    % determine filenames
    fn=fieldnames(data);
    for y=1:size(data.(fn{1}),2)
        n=1;
        % plot each run
        figure(1)
        imagesc(data.(fn{1})(y).normalized_data)
        %image(data.(fn{1})(y).normalized_data);
        caxis([min(min(data.(fn{1})(y).normalized_data)) 0.3*max(max(data.(fn{1})(y).normalized_data))]);
        % title for reference
        title(sprintf('file %s with x=%i and y=%i',fols(x).name,x,y),'interpreter','none');
        
        
        while n==1
        % user decides if there is an insecct present, maybe an insect
        % present, or not an insect present
        yn=input('insect (e) or not (w) or maybe (q) ? ','s');
        % depending on classification, the vector name and run name are
        % stored along with the corresponding filename from the scan folder
        if strcmp(yn,'e')
            int=int+1;
            n=0;
            manual.insects(int).name=fn;
            manual.insects(int).x=x;
            manual.insects(int).y=y;
        elseif strcmp(yn,'w')
            n=0;
            nnt=nnt+1;
            manual.noninsect(nnt).name=fn;
            manual.noninsect(nnt).x=x;
            manual.noninsect(nnt).y=y;
        elseif strcmp(yn,'q')
            n=0;
            mnt=mnt+1;
            manual.maybe_insect(mnt).name=fn;
            manual.maybe_insect(mnt).x=x;
            manual.maybe_insect(mnt).y=y;
        else
            disp('invalid choice');
            n=1;
        end
        end
    end
    save(fullfile(pwd,'events','manual.mat'),'manual','-v7.3')
end

