% insect_lidar_signalsnfft | Author: Liz Rehbein | Updated: 6 October 2020
% Plot colormaps of events from manual.mat, plot signals of 
% possible insects in colormap, classify, perform fft across pulse number 
% on possible signals, and classify again.
% You must be in a date directory to run the script.

% CHNAGE INT NNT MNT HNT JNT KMT FOR NEW FILE

close all
clear

start_file='/Volumes/Insect Lidar/Data_2020';
date='2020-09-18';
filename=fullfile(start_file,date);
disp(filename)
load(fullfile(filename,'events','manual.mat'))
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events'}));

if exist('/Volumes/Insect Lidar/Data_2020/2020-09-18/events/sigcheck.mat','file')~=0
    load('/Volumes/Insect Lidar/Data_2020/2020-09-18/events/sigcheck.mat');
    goodinput=0;
    int=length(sigcheck.insects); %int=0;
    nnt=length(sigcheck.noninsects); %nnt=0;
    mnt=length(sigcheck.maybe_insects);
    start=sigcheck.lastcompleted+1;
else
    int=0;
    nnt=0;
    mnt=0;
    goodinput=0;
    start=1;
end

if exist('/Volumes/Insect Lidar/Data_2020/2020-09-18/events/fftcheck.mat','file')~=0
    load('/Volumes/Insect Lidar/Data_2020/2020-09-18/events/fftcheck.mat');
    checkinput=0;
    hnt=length(fftcheck.insects);
    jnt=length(fftcheck.noninsects); %jnt=0;
    knt=length(fftcheck.maybe_insects);
    startf=fftcheck.lastcompleted+1;
else
    hnt=0;
    jnt=0;
    knt=0;
    checkinput=0;
    startf=1;
end

fname = fieldnames(manual);
fname = {fname(2),fname(1),fname(5)};

%% Look at digital return signals on insects
for n = start:size(manual.insects,2) %CHANGE THIS PRIOR TO RUNNING
    close all
    whichfol=manual.insects(n).foldernum;
    whichfile=manual.insects(n).filenum;

    % first identify range bin of interest
    % do imagesc then ask for input on range bin
    
    % Load relevant data 
    load(fullfile(filename,manual.insects(n).name,'adjusted_data_decembercal'));
   
    % Plot colormap
    figure(1)
    imagesc(adjusted_data_decembercal(whichfile).normalized_data)
    f1 = figure(1);
    movegui('north');
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
        f2 = figure(2);
        movegui('northeast');
        xlim([0 1024])
        title(sprintf('Folder:  %s File: %i  Range Bin: %i',manual.insects(n).name,whichfile,loc2),'interpreter','none');
        xlabel('Pulse Number');
        ylabel('Normalized Digital Number');
        
        % determine likelihood of insect and if input is valid
        goodinput=0;
        while goodinput==0
        % user decides if there is an insecct present, maybe an insect
        % present, or not an insect present
        yn=input('insect (q) or not (w) or maybe (e) ? ','s');
        % depending on classification, the vector name and run name are
        % stored along with the corresponding filename from the scan folder
        if strcmp(yn,'q') || strcmp(yn,'e')
            lower=str2double(input('pulse number of lower bound of event  ? ','s'));
            upper=str2double(input('pulse number of upper bound of event  ? ','s'));
        end
        if strcmp(yn,'q') %yes insect present
            int=int+1;
            goodinput=1;
            sigcheck.insects(int).name=fols(whichfol).name;
            sigcheck.insects(int).foldernum=whichfol;
            sigcheck.insects(int).filenum=whichfile;
            sigcheck.insects(int).range=loc2;
            sigcheck.insects(int).lb=lower;
            sigcheck.insects(int).ub=upper;
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
            sigcheck.maybe_insects(mnt).lb=lower;
            sigcheck.maybe_insects(mnt).ub=upper;
        else
            disp('i=Invalid choice. Redo.');
            goodinput=0;
            %n=0;
        end
        
        if strcmp(yn,'q') || strcmp(yn,'e')
        
        % DO FFT HERE
        bin=loc2; %range bin where event is located
        
        % Plot the sectioned pulse signal on time rather than pulse axis
        bindata=adjusted_data_decembercal(whichfile).normalized_data(bin,:); %assign data to variable for indexing access in next step
        figure(3)
        plot(adjusted_data_decembercal(whichfile).time(1,lower:upper),bindata(1,lower:upper));
        title(sprintf('Folder: %s File: %i',manual.insects(n).name,whichfile),'interpreter','none');
        xlabel('Time [s]');
        ylabel('Normalized Digital Number');
        f3 = figure(3);
        movegui('southwest');
        % Load relevant data 
        %load(fullfile(filename,sigcheck.insects(m).name,'adjusted_data_decembercal'));
        % FFT across all pulses
        nop = 1024; % number of pulses
        delta_t=mean(diff(adjusted_data_decembercal(whichfile).time));  %difference in pulse timing
        max_freq=1./(2*delta_t); % largest possible frequency
        delta_f=1/adjusted_data_decembercal(whichfile).time(end);
        fqdata=(-nop/2:nop/2-1).*delta_f; % gives the range of possible frequencies
        freq_data=fftshift(fft(adjusted_data_decembercal(whichfile).normalized_data(bin,:),nop,2),2); % perform fft and shift frequencies, gives the power in the signal of each available frequency
        %[maxv,maxi]=findpeaks(abs(freq_data(513:end)).^2); %find complex magnitude peaks for positive frequencies
        %[tminv,mini]=findpeaks(1.01*max(abs(freq_data(513:end)).^2)-abs(freq_data(513:end)).^2);
        %     farray = fft(adjusted_data_decembercal(whichfile).normalized_data(bin,:));
        %     freq_data=fftshift(farray); %fftshift(fft(positive_data,nop,2),2); %fix to get array
        yy1 = smooth(fqdata,abs(freq_data),0.05,'loess');%Local regression using weighted linear least squares and a 2nd degree polynomial model.
        yy2 = smooth(fqdata,abs(freq_data),0.1,'loess'); 
        figure(4);
        plot(fqdata,abs(freq_data),'Color',[.2, .5, .3],'LineWidth',.5)
        hold on
        plot(fqdata,yy1,'b-','LineWidth',1);
        plot(fqdata,yy2,'m-','LineWidth',1);
        hold off
        %plot(fqdata,abs(freq_data));
        f4 = figure(4);
        movegui('southeast');
        %plot(fqdata,(abs(freq_data)).^2,'b',fqdata(512+maxi),maxv,'ro')
        title(sprintf(' LOESS FFT on Folder: %s File: %i Range: %i',adjusted_data_decembercal(whichfile).filename(1:19),whichfile,bin),'interpreter','none');
        xlabel('frequency (Hz)');
        ylabel('power (arb)');
        xlim([0 2200])
        ylim([0 max((abs(freq_data(517:end)).^2))+max((abs(freq_data(517:end)).^2))*.05])
        
        % Plot fft over just the signal
        nop_s = length(bindata(1,lower:upper)); % number of pulses
        delta_t_s=mean(diff(adjusted_data_decembercal(whichfile).time(1,lower:upper)));  %difference in pulse timing
        max_freq_s=1./(2*delta_t_s); % largest possible frequency
        delta_f_s=1/adjusted_data_decembercal(whichfile).time(upper);
        fqdata_s=(-nop_s/2:nop_s/2-1).*delta_f_s; % gives the range of possible frequencies
        freq_data_s=fftshift(fft(bindata(1,lower:upper),nop_s,2),2); % perform fft and shift frequencies, gives the power in the signal of each available frequency
        figure(5);
        plot(fqdata_s,abs(freq_data_s));
        xlim([0 2200])
        xlabel('frequency (Hz)');
        ylabel('power (arb)');
        title(sprintf('Abbrev. FFT on Folder: %s File: %i Range: %i',adjusted_data_decembercal(whichfile).filename(1:19),whichfile,bin),'interpreter','none');

        
        
        %determine likelihood of insect
       
        isinsect=input('insect (q) or not (w) or maybe (e) ? ','s');
        
        if strcmp(isinsect,'q') %yes insect present
            hnt=hnt+1;
            checkinput=1;
            fftcheck.insects(hnt).name=fols(whichfol).name;
            fftcheck.insects(hnt).foldernum=whichfol;
            fftcheck.insects(hnt).filenum=whichfile;
            fftcheck.insects(hnt).range=loc2;
            fftcheck.insects(hnt).lb=lower;
            fftcheck.insects(hnt).ub=upper;
            maybefreq=str2double(input('Best guess frequency? ','s'));
            fftcheck.insects(hnt).freq=maybefreq;
        elseif strcmp(isinsect,'w') % no insect present
            checkinput=1;
            jnt=jnt+1;
            fftcheck.noninsects(jnt).name=fols(whichfol).name;
            fftcheck.noninsects(jnt).foldernum=whichfol;
            fftcheck.noninsects(jnt).filenum=whichfile;
            fftcheck.noninsects(jnt).range=loc2;
        elseif strcmp(isinsect,'e') %maybe insect present
            checkinput=1;
            knt=knt+1;
            fftcheck.maybe_insects(knt).name=fols(whichfol).name;
            fftcheck.maybe_insects(knt).foldernum=whichfol;
            fftcheck.maybe_insects(knt).filenum=whichfile;
            fftcheck.maybe_insects(knt).range=loc2;
            fftcheck.maybe_insects(knt).lb=lower;
            fftcheck.maybe_insects(knt).ub=upper;
%             maybefreq=str2double(input('Best guess frequency? ','s'));
%             fftcheck.maybe_insects(knt).freq=maybefreq;
        else
            disp('Invalid choice. Redo.');
            checkinput=0;
            %n=0;
        end
       
        
        end % end of checking if sigcheck has insect or not in order to run fft
        
        end
        % is there another insect in a different range bin?
        more=input('are there other insects (y/n)? ','s');
   
    end    
sigcheck.lastfilename=fols(whichfol).name;
sigcheck.lastcompleted=n;
save(fullfile(pwd,'events','sigcheck.mat'),'sigcheck','-v7.3')

fftcheck.lastfilename=fols(whichfol).name;
fftcheck.lastcompleted=n;
save(fullfile(pwd,'events','fftcheck.mat'),'fftcheck','-v7.3')

end

