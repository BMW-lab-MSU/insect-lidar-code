% clear
% hh=[9 11 14 16 18 20 22 38 46 49 51 54 55 69 81];
% file=dir(fullfile(pwd,'AMK*'));
% h=hh(15);
% %% everything but insect
% load(fullfile(pwd,file(h).name,'adjusted_data.mat'))
% m=1;
% add_stats.noninsect=[];
% while m<=size(adjusted_data,2);
%     imagesc(adjusted_data(m).normalized_data);
%     set(gca,'fontsize',10,'ytick',0:5:size(adjusted_data(m).normalized_data,1))
% 
%     title(m);
% 
%     start=input('start value');
%     finish=input('end value');
%     yn=input('advance to next plot? (y/n)','s');
% 
%     int=size(add_stats.noninsect,2);
%     for n=start:finish
%         int=int+1;
% 
%         add_stats.noninsect(int).data=adjusted_data(m).normalized_data(n,:);
%         add_stats.noninsect(int).mean=mean(adjusted_data(m).normalized_data(n,:));
%         add_stats.noninsect(int).filename=adjusted_data(m).filename;
%         add_stats.noninsect(int).location=n;
%     end
%     if strcmp(yn,'y')
%         m=m+14;
%     end
% end
% 
% save(fullfile(pwd,file(h).name,'add_stats.mat'),'add_stats','-v7.3');
%% background
% load(fullfile(pwd,file(h).name,'adjusted_data.mat'))
% m=1;
% stats.background=[];
% while m<=size(adjusted_data,2);
%     imagesc(adjusted_data(m).normalized_data);
%     set(gca,'fontsize',10,'ytick',0:5:size(adjusted_data(m).normalized_data,1))
%
%     title(m);
%
% start=input('start value');
% finish=input('end value');
% yn=input('advance to next plot? (y/n)','s');
%
% int=size(stats.background,2);
% for n=start:finish
%     int=int+1;

%     stats.background(int).data=adjusted_data(m).normalized_data(n,:);
%     stats.background(int).mean=mean(adjusted_data(m).normalized_data(n,:));

%     stats.background(int).filename=adjusted_data(m).filename;
%     stats.background(int).location=n;
% end
% if strcmp(yn,'y')
%     m=m+15;
% end
% end
%
% save(fullfile(pwd,file(h).name,'stats.mat'),'stats','-v7.3');
%% hard target
% m=1;
% stats.hardtarget=[];
% while m<=size(adjusted_data,2);
%     imagesc(adjusted_data(m).normalized_data);
%     set(gca,'fontsize',6,'ytick',1:2:size(adjusted_data(m).normalized_data,1))
%     title(m)
% start=input('start value');
% finish=input('end value');
% yn=input('advance to next plot? (y/n)','s');
%
% int=size(stats.hardtarget,2);
% for n=start:finish
%     int=int+1;

%     stats.hardtarget(int).data=adjusted_data(m).normalized_data(n,:);
%     stats.hardtarget(int).mean=mean(adjusted_data(m).normalized_data(n,:));
%     stats.hardtarget(int).filename=adjusted_data(m).filename;

%     stats.hardtarget(int).location=n;
% end
% if strcmp(yn,'y')
%     m=m+15;
% end
% end
% save(fullfile(pwd,file(h).name,'stats.mat'),'stats','-v7.3');
%% insect
% a=53;
% b=38;
% stats.insect(1).data=adjusted_data(a).normalized_data(b,:);
% stats.insect(1).mean=mean(adjusted_data(a).normalized_data(b,:));
% stats.insect(1).filename=adjusted_data(a).filename;
% stats.insect(1).location=n;

% save(fullfile(pwd,file(h).name,'stats.mat'),'stats','-v7.3');
%% combine stats
inx=[9 11 14 16 18 20 22 38 46 49 51 54 55 69 81];
file=dir(fullfile(pwd,'AMK*'));

% inx=[8 10 13 15 17 19 21 37 45 48 50 52 53 59 68 69 70 71 72 73 78 79 80];
intb=0;
inth=0;
inti=0;
intn=0;
for n=1:length(inx);
    clear add_stats
    load(fullfile(pwd,file(inx(n)).name,'add_stats.mat'));
%     for mb=1:length(stats.background)
%         intb=intb+1;
%         full_stats.background(intb).data=stats.background(mb).data;
%         full_stats.background(intb).mean=stats.background(mb).mean;
%         full_stats.background(intb).filename=stats.background(mb).filename;
%     end
%     for mh=1:length(stats.hardtarget)
%         inth=inth+1;
%         full_stats.hardtarget(inth).data=stats.hardtarget(mh).data;
%         full_stats.hardtarget(inth).mean=stats.hardtarget(mh).mean;
%         full_stats.hardtarget(inth).filename=stats.hardtarget(mh).filename;
%     end
%     for mi=1:length(stats.insect)
%         inti=inti+1;
%         full_stats.insect(inti).data=stats.insect(mi).data;
%         full_stats.insect(inti).mean=stats.insect(mi).mean;
%         full_stats.insect(inti).filename=stats.insect(mi).filename;
%     end
    for mn=1:length(add_stats.noninsect)
        intn=intn+1;
        full_stats.noninsect(intn).data=add_stats.noninsect(mn).data;
        full_stats.noninsect(intn).mean=add_stats.noninsect(mn).mean;
        full_stats.noninsect(intn).filename=add_stats.noninsect(mn).filename;
        full_stats.noninsect(intn).location=add_stats.noninsect(mn).location;
    end
end



