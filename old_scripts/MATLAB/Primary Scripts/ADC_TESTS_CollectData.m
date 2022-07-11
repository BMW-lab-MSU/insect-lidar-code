%% Martin Tauc | 2016_02_11


%change these variables
clear
%depth=200;
spacing = 1;


%pretrig=100;

%name the folder where the ADC has saved the raw files
tempgage = 'C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\Temp Gage Storage';
%find the files and count them
files = dir(fullfile(tempgage,'*.dat'));
numseq = length(files);

ix=0;
for n=1:numseq;
    if str2double(files(n).name(end-7:end-4))==1;
        ix=ix+1;
        ind(ix)=n;
    end
end
ind(end+1)=numseq+1;
clear ix
ix=0;
for o=1:length(ind)-1;
    ix=ix+1;
    clear raw1data
    clear r2d
    clear data
    clear tf
    clear index
    clear datainfo
    clear k
    clear fname
    clear raw data
    clear celldata
    clear infob
    %Determine where to start indexing from
    raw1data=importdata(fullfile(tempgage,files(ind(ix)).name));
    r1d=raw1data.textdata;
    
    %determine depth
    depth=raw1data.data(2);
    
    %
    samplepersec=200e6;
    samplesbetweenpulses=31432;
    timebetweenpulses=(samplepersec/samplesbetweenpulses)^-1;
    % if depth >= 30e3
    %       error('Depth too large. Multiple pulses will be detected in one trigger.  Set Depth to less than 30e3')
    % end
    
    %define matrix
    data=zeros(depth,((length(ind(ix):ind(ix+1)-1))/spacing));
    
    tf=0;
    index=2;
    while tf==0;
        tf=isempty(r1d{index,2});
        index=index+1;
    end
    
    datainfo=r1d(2:index-2,1:size(r1d,2));
    
    k=0;
    %extract the data from each run and put it into matrix and vector
    for m=ind(ix):spacing:ind(ix+1)-1;
        fname=files(m).name;
        rawdata=importdata(fullfile(tempgage,fname));
        celldata=rawdata.textdata(index:(index+depth-1),1);
        k=k+1;
        data(:,k)=cellfun(@(celldata) str2double(celldata),celldata);
        datainfo(:,k+3)=num2cell(rawdata.data);
        %create datainfo
        
%         infob=num2cell(rawdata.data);
%         for n=1:size(raw1data.data,1)
%             datainfo(n,k+3)=infob(n);
%         end
    end
    % datestmp=datestr(clock,29);
    % timestmp=datestr(clock,'HH_MM_SS');
    datestmp=[files(ind(ix)).name(1:4),'_',files(ind(ix)).name(5:6),'_',...
        files(ind(ix)).name(7:8)];
    timestmp=[files(ind(ix)).name(10:11),'_',files(ind(ix)).name(12:13),'_',...
        files(ind(ix)).name(14:15)];
    datadir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data';
    currentdatadir=strcat(datadir,'\',datestmp);
    
    if exist(fullfile(datadir,datestmp),'dir')==7;
        save(fullfile(currentdatadir,timestmp),'data','datainfo');
    else
        mkdir(fullfile(datadir),datestmp);
        save(fullfile(currentdatadir,timestmp),'data','datainfo');
    end
    
    for n=ind(ix):ind(ix+1)-1
        fname=files(n).name;
        delete(fullfile(tempgage,fname))
    end
end

