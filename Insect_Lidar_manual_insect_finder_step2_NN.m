%% Insect_Lidar_manual_insect_finder_step2_NN | Elizabeth Rehbein | 2019-09-03

% Modified from Insect_Lidar_maunal_insect_finder_step2
% in order to build a training dataset for a neural network.
% This script selects the range bin and time domain for
% insects, possible insects, and "ghost insects."
% So called "ghost insects" are artifacts in the data created by ringing in
% the PMTs in the receiving optics of the insect lidar.

% Loads manual.mat from the "events" folder in processed_data.
% manual.mat indicates whether a 3D dataset contain an insect
% which is labelled "noninsect," "maybe_insect," or "insects."

%%

% Loads initial insect identification "manual.mat"
fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','eventsNN'}));
load('I:\Data_Test\2010-10-10\processed_data\eventsNN\manual.mat');

% Checks to see if the classification has been started, then begins the 
% classification process at the right spot.
if exist('I:Data_Test\2010-10-10\processed_data\classification.mat','file')~=0
    %load('I:\Data_Test\2010-10-10\eventsNN\processed_data\classification.mat');
    load('I:\Data_Test\2010-10-10\processed_data\classification.mat');
 
    if isfield(classification, 'starthere_ii') == 1
         start_ii= classification.starthere_ii; %insect start
    else start_ii = 1;
    end
    
    if isfield(classification, 'starthere_mi') == 1
         start_mi = classification.starthere_mi; %maybe insect start
    else start_mi = 1;
    end
    
    %int=size(classification,2); %starts counting at the right place
    %int=size(manual.insects,2);    
else
    classification = struct('insect',[],'maybe',[],'noninsect',[],'ghost',[]);
    start_ii=1; %insect start
    start_mi=1; %maybe insect start
  % Build up classification for non-insects
  % ***** FIX TO ONLY GET DESIRED FIELDS *****
    classification.noninsect = manual.noninsect;
end



%% first choose insects, then maybe_insect

% doesn't start in the right place because start_ii and start_mi aren't
% being populated correctly  

if start_ii <= size(manual.insect,2)

% loads in insects from manual.mat
for n=start_ii:size(manual.insect,2)
    % are there insects in multiple range bins?
    more='y';
    while strcmp(more,'y')==1
        clear data fn
        % load in the run
        data=load(fullfile(pwd,fols(manual.insect(n).x).name));
        fn=fieldnames(data);
        figure(1)
        % display the run
        imagesc(data.(fn{1})(manual.insect(n).y).normalized_data)
        title(sprintf('file %s with x=%i and y=%i and n=%i',fols(manual.insect(n).x).name,manual.insect(n).x,manual.insect(n).y,n),'interpreter','none');
        ylabel('Range');
        xlabel('Time');
        % input the range number where the insect is
        loc2=input('range number to look at ');
        figure(2)
        % plot that range bin in plot and not image
        plot(data.(fn{1})(manual.insect(n).y).normalized_data(loc2,:))
        title(sprintf('file %s with x=%i and y=%i and z=%i and n=%i',fols(manual.insect(n).x).name,manual.insect(n).x,manual.insect(n).y,loc2,n),'interpreter','none');
        ylabel('Normalized Detected Signal');
        xlabel('Pulse Number');
        % determine likelihood of insect
        isinsect=input('is this an insect (y/n/m)or a ghost(g)? ','s');
        wherestart=input('start time of insect ','s');
        whereend=input('end time of insect ','s');
        % store insect or non insect based on input
        switch isinsect
            case 'y'
                indx = 1;
            case 'n'
                indx = 2;
            case 'm'
                indx = 3;
            case 'g'  
                indx = 4;
        end
        % save data for range bin under examination
        fname = fieldnames(classification);
        count = length(classification.(fname{indx}));
        classification.(fname{indx})(count+1).filename = fn;
        %~~~~~~~~SAVE NORMALIZED DATA~~~~~~~%
        classification.(fname{indx})(count+1).file_number = manual.insect(n).x;
        classification.(fname{indx})(count+1).field_number = manual.insect(n).y;
        classification.(fname{indx})(count+1).rangebin = loc2;
        classification.(fname{indx})(count+1).domain_start = wherestart;
        classification.(fname{indx})(count+1).domain_end = whereend;
        classification.starthere_ii = n +1; 
        
         % is there another insect in a different range bin?
        more=input('are there other insects (y/n)? ','s');
    end
    
save(fullfile(pwd,'classification'),'classification','-v7.3')


end

else
    disp('Manual.insects completed. Beginning manual.maybe_insect now.')
end

%% Classifying maybe insects 

if start_mi <= size(manual.maybe_insect,2)
    
% loads in possible insects from manual.mat
for n=start_mi:size(manual.maybe_insect,2)
    % are there insects in multiple range bins?
    more='y';
    while strcmp(more,'y')==1 
        clear data fn
        % load in the run
        data=load(fullfile(pwd,fols(manual.maybe_insect(n).x).name));
        fn=fieldnames(data);
        figure(1)
        % display the run
        imagesc(data.(fn{1})(manual.maybe_insect(n).y).normalized_data)
        title(sprintf('file %s with x=%i and y=%i and m=%i',fols(manual.maybe_insect(n).x).name,manual.maybe_insect(n).x,manual.maybe_insect(n).y,n),'interpreter','none');
        % input the range number where the insect is
        loc2=input('range number to look at ');
        figure(2)
        % plot that range bin in plot and not image
        plot(data.(fn{1})(manual.maybe_insect(n).y).normalized_data(loc2,:))
        title(sprintf('file %s with x=%i and y=%i and z=%i and n=%i',fols(manual.maybe_insect(n).x).name,manual.maybe_insect(n).x,manual.maybe_insect(n).y,loc2,n),'interpreter','none');
        % determine likelihood of insect
        isinsect=input('is this an insect (y/n/m)or a ghost(g)? ','s');
        wherestart=input('start time of insect ','s');
        whereend=input('end time of insect ','s');
        % store insect or non insect based on input
        switch isinsect
            case 'y'
                indx = 1;
            case 'n'
                indx = 2;
            case 'm'
                indx = 3;
            case 'g'  
                indx = 4;
        end
        % save range bin examined
        fname = fieldnames(classification);
        %~~~~~~~~SAVE NORMALIZED DATA~~~~~~~%
        count = length(classification.(fname{indx}));
        classification.(fname{indx})(count+1).filename = fn;
        classification.(fname{indx})(count+1).file_number = manual.maybe_insect(n).x;
        classification.(fname{indx})(count+1).field_number = manual.maybe_insect(n).y;
        classification.(fname{indx})(count+1).rangebin = loc2;
        classification.(fname{indx})(count+1).domain_start = wherestart;
        classification.(fname{indx})(count+1).domain_end = whereend;
        classification.starthere_mi = n +1; 
        
         % is there another insect in a different range bin?
        more=input('are there other insects (y/n)? ','s');
    end
    save(fullfile(pwd,'classification'),'classification','-v7.3')
end
else
    disp('all done with classifying this day')
end
