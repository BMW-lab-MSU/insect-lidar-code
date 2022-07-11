%%%adapted from old script%%%

load(fullfile(pwd,file(h).name,'adjusted_data.mat'))

% hard target
m=1;
stats.hardtarget=[];
while m<=size(adjusted_data,2);
    imagesc(adjusted_data(m).normalized_data);
    set(gca,'fontsize',6,'ytick',1:2:size(adjusted_data(m).normalized_data,1))
    title(m)
start=input('start value');
finish=input('end value');
yn=input('advance to next plot? (y/n)','s');

int=size(stats.hardtarget,2);
for n=start:finish
    int=int+1;

    stats.hardtarget(int).data=adjusted_data(m).normalized_data(n,:);
    stats.hardtarget(int).mean=mean(adjusted_data(m).normalized_data(n,:));
    stats.hardtarget(int).filename=adjusted_data(m).filename;

    %stats.hardtarget(int).location=n;
end
if strcmp(yn,'y')
    m=m+15;
end
end
save(fullfile(pwd,file(h).name,'stats.mat'),'stats','-v7.3');

