%%%adapted from make_fig_insects.sl.m

%index start values 
vli_start =1;
int=0;


start_file='D:\Data-Test\';                          %indicate directory for start_file location
date='2016-06-08';                                   %select date of folder to look at 
filename=fullfile(start_file,date,'processed_data'); %load in processed data
fols=dir(filename);                                  %fols = a list of files in the processed data folder
load(fullfile(filename,'events','manual_final_insect.mat'))  %load in manual_final_insect.mat file
fols=fols(~ismember({fols.name},{'.','..','events'}));  %are the file names in processed data also found in events, if yes saves to fols

t = exist(fullfile(filename, 'Training_Data_new'),'dir');

if t == 0
    
mkdir(filename, 'Training_Data_new');
addpath(fullfile(filename,'Training_Data_new'));

end


for vli=vli_start:size(manual_final_insect.very_likely,2)
    
    clearvars -except start_file date filename fols events manual_final_insect vli int vl mode_run_time data fn t vli_start
    
    data=load(fullfile(filename,fols(manual_final_insect.very_likely(vli).x).name)); %information from filename selected
    fn=fieldnames(data);  %fn is the name of the files in data
    
%positive_data
% positive_data=abs(data.(fn{:})(manual_final_insect.somewhat_likely(vli).y).normalized_data(manual_final_insect.somewhat_likely(vli).z,:)-...
%        max(data.(fn{:})(manual_final_insect.somewhat_likely(vli).y).normalized_data(manual_final_insect.somewhat_likely(vli).z,:)));

positive_data = data.(fn{:})(manual_final_insect.very_likely(vli).y).normalized_data...
    (manual_final_insect.very_likely(vli).z,:);

%dnum%
 
 dateinfo_dir=fullfile(start_file,date);    %makes directory for dateinfo 
 dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));  %makes directory of date info with filenames of AMK_Ranch data
 dateinfo=dateinfo([dateinfo.isdir]);           %data.isdir is all ones
 
 for k=1:size(dateinfo,1)
     run_time(k,:)=datenum(dateinfo(k).name(11:end),'HHMMSS');  %converting each point in time as a serial date number
 end
 
 mode_run_time=mode(diff(run_time));    %mode of the differences in run_time

disp(vli)
 

 exact_dnum=datenum([date,'-',num2str(str2num(data.(fn{:})(manual_final_insect.very_likely(vli).y).filename(11:16))+...
         str2num(datestr(mode_run_time*(str2num(data.(fn{:})(manual_final_insect.very_likely(vli).y).filename(18:22))/230),'HHMMSS')))],...
        'yyyy-mm-dd-HHMMSS');
    
    %finds exact date ^  still a question mark on how it works 
    
%datetime% 
 exact_time=datestr(exact_dnum,'yyyy-mm-dd HH:MM:SS');  %converts it into a string format 


%frequency%
 nop=size(positive_data,2);
 time_data=data.(fn{:})(manual_final_insect.very_likely(vli).y).time;   %collects the time data from each file
   delta_f=1/time_data(end); 
fqdata=(-nop/2:nop/2-1).*delta_f;

%freq_data%
 freq_data=fftshift(fft(positive_data,nop,2),2);
 
%power%
 power = abs(freq_data).^2;
 
%gauss_freq_data%
med=median(positive_data);
        maxpd=max(positive_data);
        cutoff=(maxpd*.15)+med;
        
lowerbound=find(positive_data>=cutoff,1,'first');
        if lowerbound-100>0
            lsec=lowerbound-100;
        else
            lsec=0;
        end
        upperbound=find(positive_data>=cutoff,1,'last');
        if upperbound+100<1024
            hsec=upperbound+100;
        else
            hsec=1024;
        end
        
g=gaussmf(1:length(positive_data),[(hsec-lsec)/2,mean([hsec lsec])]);
        np=g.*positive_data;
        gauss_data=np;
g_freq_data=fftshift(fft(gauss_data,nop,2),2);

%max_peak%
 lbfreq=find(fqdata(513:end)>=50,1,'first')+512;
 [frq_max,freq_i]=max(abs(g_freq_data(lbfreq:end).^2));
 pk_freq=fqdata(lbfreq+freq_i-1);
 
 
 
      int=int+1;
        vl.analysis_data(int).data=data.(fn{:})(manual_final_insect.very_likely(vli).y).normalized_data(manual_final_insect.very_likely(vli).z,:);
        vl.analysis_data(int).tilt=data.(fn{:})(manual_final_insect.very_likely(vli).y).tilt;
        vl.analysis_data(int).pan=data.(fn{:})(manual_final_insect.very_likely(vli).y).pan;
        vl.analysis_data(int).time=data.(fn{:})(manual_final_insect.very_likely(vli).y).time;
        vl.analysis_data(int).range=data.(fn{:})(manual_final_insect.very_likely(vli).y).range(manual_final_insect.very_likely(vli).z);
        vl.analysis_data(int).filename=data.(fn{:})(manual_final_insect.very_likely(vli).y).filename;
        vl.analysis_data(int).dnum=exact_dnum;
        vl.analysis_data(int).datetime=exact_time;
        vl.analysis_data(int).frequency=fqdata;
        vl.analysis_data(int).freq_data=freq_data;
        vl.analysis_data(int).freq_power= power;
        vl.analysis_data(int).gauss_freq_data=g_freq_data;
        vl.analysis_data(int).max_peak=pk_freq;
        vl.analysis_data(int).positive_data=positive_data;
       
end

 disp('done')
 save(fullfile(filename,'Training_Data_new','vl_analysis_data.mat'),'-struct','vl');
 
