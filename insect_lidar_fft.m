% insect_lidar_fft | Author: Liz Rehbein | Updated: 6 October 2020
% Plot colormaps of events from manual.mat, plot signals of 
% possible insects in colormap, classify, perform fft across pulse number 
% on possible signals, and classify again.
% You must be in a date directory to run the script.

close all

start_file='/Volumes/Insect Lidar/Data_2020';
date='2020-09-16';
filename=fullfile(start_file,date);
disp(filename)
load(fullfile(filename,'events','manual.mat'))
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events'}));

if exist('/Volumes/Insect Lidar/Data_2020/2020-09-16/events/sigcheck.mat','file')~=0
    load('/Volumes/Insect Lidar/Data_2020/2020-09-16/events/sigcheck.mat');
    goodinput=0;
    int=length(sigcheck.insects);
    nnt=length(sigcheck.noninsect);
    mnt=length(sigcheck.maybe_insect);
    start=sigcheck.lastcompleted+1;
else
    int=0;
    nnt=0;
    mnt=0;
    goodinput=0;
    start=1;
end

fname = fieldnames(manual);
fname = {fname(2),fname(1),fname(5)};

%% Look at digital return signals on insects
for n = start:2     %size(manual.insects,2) CHANGE THIS PRIOR TO RUNNING
    whichfol=manual.insects(n).foldernum;
    whichfile=manual.insects(n).filenum;

    % first identify range bin of interest
    % do imagesc then ask for input on range bin
    
    % Load relevant data 
    load(fullfile(filename,manual.insects(n).name,'adjusted_data_decembercal'));
   
    % Plot colormap
    figure(1)
    imagesc(adjusted_data_decembercal(whichfile).normalized_data)
    title(sprintf('Folder: %s File: %i',manual.insects(n).name,whichfile),'interpreter','none');
    xlabel('Pulse Number');
    ylabel('Range Bin Number')
    
    more='y'; % are there insects in multiple range bins?
    while strcmp(more,'y')==1
        % input the range number where the insect is
        loc2=input('range number ');
        figure(2)
        % plot that range bin in plot and not image
        plot(adjusted_data_decembercal(whichfile).normalized_data(loc2,:))
        xlim([0 1024])
        title(sprintf('Folder:  %s File: %i  Range Bin: %i',manual.insects(n).name,whichfile,loc2),'interpreter','none');
        
        % determine likelihood of insect and if input is valid
        goodinput=0;
        while goodinput==0
        % user decides if there is an insecct present, maybe an insect
        % present, or not an insect present
        yn=input('insect (q) or not (w) or maybe (e) ? ','s');
        % depending on classification, the vector name and run name are
        % stored along with the corresponding filename from the scan folder
        if strcmp(yn,'q') || strcmp(yn,'e')
            lowerbound=input('pulse number of lower bound of event  ? ','s');
            upperbound=input('pulse number of lower bound of event  ? ','s');
        end
        if strcmp(yn,'q') %yes insect present
            int=int+1;
            goodinput=1;
            sigcheck.insects(int).name=fols(whichfol).name;
            sigcheck.insects(int).foldernum=whichfol;
            sigcheck.insects(int).filenum=whichfile;
            sigcheck.insects(int).range=loc2;
            sigcheck.insects(int).lb=lowerbound;
            sigcheck.insects(int).ub=upperbound;
        elseif strcmp(yn,'w') % no insect present
            goodinput=1;
            nnt=nnt+1;
            sigcheck.noninsects(nnt).name=fols(whichfol).name;
            sigcheck.noninsects(nnt).foldernum=whichfol;
            sigcheck.noninsects(nnt).filenum=whichfile;
            sigcheck.noninsects(nnt).range=loc2;
        elseif strcmp(yn,'e') %maybe insect present
            goodinput=1;
            mnt=mnt+1;
            sigcheck.maybe_insects(mnt).name=fols(whichfol).name;
            sigcheck.maybe_insects(mnt).foldernum=whichfol;
            sigcheck.maybe_insects(mnt).filenum=whichfile;
            sigcheck.maybe_insects(mnt).range=loc2;
            sigcheck.insects(mnt).lb=lowerbound;
            sigcheck.insects(mnt).ub=upperbound;
        else
            disp('invalid choice');
            n=0;
        end
        end
        % is there another insect in a different range bin?
        more=input('are there other insects (y/n)? ','s');
   
    end    
sigcheck.lastfilename=fols(n).name;
sigcheck.lastcompleted=n;
save(fullfile(pwd,'events','sigcheck.mat'),'sigcheck','-v7.3')

end
%% Clean up between sections

clear('whichfol','whichfile','n','loc2','more','int','nnt','mnt','yn',...
      'adjusted_data_decembercal')
close(figure(2))

%% Look at FFT's for insects in sigcheck

load(fullfile(filename,'events','sigcheck.mat'))


for m = start:size(sigcheck.insects,2)
    whichfol=sigcheck.insects(m).foldernum;
    whichfile=sigcheck.insects(m).filenum;
    bin=sigcheck.insects(m).range; %range bin where event is located
    lower=sigcheck.insects(m).lb; %lower pulse number bound of insect event
    upper=sigcheck.insects(m).ub; %upper pulse number bound of insect event
    
    % Plot the sectioned pulse signal on time rather than pulse axis
    bindata=adjusted_data_decembercal(whichfile).normalized_data(bin,:); %assign data to variable for indexing access in next step
    figure(3)
    plot(adjusted_data_decembercal(whichfile).time(lower:upper),bindata(lower:upper));
    
    % Load relevant data 
    load(fullfile(filename,sigcheck.insects(m).name,'adjusted_data_decembercal'));
    nop = 1024; % number of pulses
    delta_t=mean(diff(adjusted_data_decembercal(whichfile).time));  %difference in pulse timing
    max_freq=1./(2*delta_t); % largest possible frequency
    delta_f=1/adjusted_data_decembercal(whichfile).time(end);
    fqdata=(-nop/2:nop/2-1).*delta_f; % gives the range of possible frequencies
    freq_data=fftshift(fft(adjusted_data_decembercal(whichfile).normalized_data(bin,:),nop,2),2); % perform fft and shift frequencies, gives the power in the signal of each available frequency
    [maxv,maxi]=findpeaks(abs(freq_data(513:end)).^2); %find complex magnitude peaks for positive frequencies
    [tminv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
%     farray = fft(adjusted_data_decembercal(whichfile).normalized_data(bin,:));
%     freq_data=fftshift(farray); %fftshift(fft(positive_data,nop,2),2); %fix to get array
    figure(4);
    plot(fqdata,abs(freq_data));
    %plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
    title(sprintf('FFT on Folder: %s File: %i Range: %i',sigcheck.insects(m).name,whichfile,bin),'interpreter','none');
    xlabel('frequency (Hz)');
    ylabel('power (arb)');
    xlim([0 2200])
    ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
    determine likelihood of insect
    figure(2)
    imagesc(testdata(x).normalized_data);
    isinsect=input('is this an insect (y/n/m)? ','s');

end
 

%     %% fourier arrary now
%     farray = fft(fols(whichfol).normalized_data);
%     nop = 1024;
%     delta_t=mean(diff(testdata(x).time));  %difference in pulse timing
%     max_freq=1./(2*delta_t);
%     delta_f=1/testdata(x).time(end);
%     fqdata=(-nop/2:nop/2-1).*delta_f;
%     freq_data=fftshift(farray); %fftshift(fft(positive_data,nop,2),2); %fix to get array
%     figure(1);
%     plot(fqdata,abs(freq_data));
%     plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
%     xlabel('frequency (Hz)');
%     ylabel('power (arb)');
%     title(sprintf('On file %i of 166', x));
%     xlim([0 2200])
%     ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
%     determine likelihood of insect
%     figure(2)
%     imagesc(testdata(x).normalized_data);
%     isinsect=input('is this an insect (y/n/m)? ','s');
% 
% 
% % Perform FFT's on maybe insects from events
% for x = 1:size(manual.maybe_insect,2)
% end