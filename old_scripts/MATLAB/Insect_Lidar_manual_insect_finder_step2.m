%% Insect_Lidar_manual_insect_finder_step2 | Martin Tauc | 2017-02-01

% fols is all vectors
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));
% if the manual process was already started, this will load the saved file
% and start counting at the right values
load('C:\Martin_Tauc\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual.mat');

if exist('C:\Martin_Tauc\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual_insects.mat','file')~=0
    load('C:\Martin_Tauc\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual_insects.mat');
    int=size(manual_insects,2);
    
else
    int=0;
end
% first choose insects, then maybe_insect
for n=1:size(manual.insects,2)
    % are there insects in multiple range bins?
    more='y';
    while strcmp(more,'y')==1
        clear data fn
        % load in the run
        data=load(fullfile(pwd,fols(manual.insects(n).x).name));
        fn=fieldnames(data);
        figure(1)
        % display the run
        imagesc(data.(fn{1})(manual.insects(n).y).normalized_data)
        title(sprintf('file %s with x=%i and y=%i and n=%i',fols(manual.insects(n).x).name,manual.insects(n).x,manual.insects(n).y,n),'interpreter','none');
        % input the range number where the insect is
        loc2=input('range number ');
        figure(2)
        % plot that range bin in plot and not image
        plot(data.(fn{1})(manual.insects(n).y).normalized_data(loc2,:))
        title(sprintf('file %s with x=%i and y=%i and z=%i and n=%i',fols(manual.insects(n).x).name,manual.insects(n).x,manual.insects(n).y,loc2,n),'interpreter','none');
        % determine liklyhood of insect
        isinsect=input('is this an insect (y/n/m)? ','s');
        % store insect or non insect based on input
        if strcmp(isinsect,'y') || strcmp(isinsect,'m')
            int=int+1;
            manual_insects(int).filename=fn;
            manual_insects(int).x=manual.insects(n).x;
            manual_insects(int).y=manual.insects(n).y;
            manual_insects(int).z=loc2;
            manual_insects(int).yesORmaybe=isinsect;
        end
        % is there another insect in a different range bin?
        more=input('are there other insects (y/n)? ','s');
        
    end
    
end
save(fullfile(pwd,'events','manual_insects.mat'),'manual_insects','-v7.3')