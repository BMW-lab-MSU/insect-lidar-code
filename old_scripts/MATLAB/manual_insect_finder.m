% fols=dir(fullfile(pwd));
% fols=fols(~ismember({fols.name},{'.','..','events'}));
% load('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual.mat');
%
% int=size(manual.insects,2);
% mnt=size(manual.maybe_insect,2);
% nnt=size(manual.noninsect,2);
% for x=118:size(fols,1)
%     clear data fn
%     data=load(fullfile(pwd,fols(x).name));
%     fn=fieldnames(data);
%     for y=1:size(data.(fn{1}),2)
%         imagesc(data.(fn{1})(y).normalized_data)
%         title(sprintf('file %s with x=%i and y=%i',fols(x).name,x,y),'interpreter','none');
%         yn=input('insect (e) or not (w) or maybe (q) ? ','s');
%
%         if strcmp(yn,'e')
%             int=int+1;
%             manual.insects(int).name=fn;
%             manual.insects(int).x=x;
%             manual.insects(int).y=y;
%         elseif strcmp(yn,'w')
%             nnt=nnt+1;
%             manual.noninsect(nnt).name=fn;
%             manual.noninsect(nnt).x=x;
%             manual.noninsect(nnt).y=y;
%         else
%             mnt=mnt+1;
%             manual.maybe_insect(mnt).name=fn;
%             manual.maybe_insect(mnt).x=x;
%             manual.maybe_insect(mnt).y=y;
%
%         end
%     end
%     save(fullfile(pwd,'events','manual.mat'),'manual','-v7.3')
% end
% % % 
% % % fols=dir(fullfile(pwd));
% % % fols=fols(~ismember({fols.name},{'.','..','events'}));
% % % load('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual.mat');
% % % 
% % % int=size(manual_insects,2);
% % % for n=872:size(manual.insects,2)
% % %     more='y';
% % %     while strcmp(more,'y')==1
% % %         clear data fn
% % %         data=load(fullfile(pwd,fols(manual.insects(n).x).name));
% % %         fn=fieldnames(data);
% % %         figure(1)
% % %         imagesc(data.(fn{1})(manual.insects(n).y).normalized_data)
% % %         title(sprintf('file %s with x=%i and y=%i and n=%i',fols(manual.insects(n).x).name,manual.insects(n).x,manual.insects(n).y,n),'interpreter','none');
% % %         loc2=input('range number ');
% % %         figure(2)
% % %         plot(data.(fn{1})(manual.insects(n).y).normalized_data(loc2,:))
% % %         title(sprintf('file %s with x=%i and y=%i and z=%i and n=%i',fols(manual.insects(n).x).name,manual.insects(n).x,manual.insects(n).y,loc2,n),'interpreter','none');
% % %         isinsect=input('is this an insect (y/n/m)? ','s');
% % %         if strcmp(isinsect,'y') || strcmp(isinsect,'m')
% % %             int=int+1;
% % %             manual_insects(int).filename=fn;
% % %             manual_insects(int).x=manual.insects(n).x;
% % %             manual_insects(int).y=manual.insects(n).y;
% % %             manual_insects(int).z=loc2;
% % %             manual_insects(int).yesORmaybe=isinsect;
% % %         end
% % %         more=input('are there other insects (y/n)? ','s');
% % %         
% % %     end
% % %     
% % % end
% % % save(fullfile(pwd,'events','manual_insects.mat'),'manual_insects','-v7.3')


fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));
load('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\processed_data\events\manual.mat');

int=size(manual_insects,2);
for n=635:size(manual.maybe_insect,2)
    more='y';
    while strcmp(more,'y')==1
        clear data fn
        data=load(fullfile(pwd,fols(manual.maybe_insect(n).x).name));
        fn=fieldnames(data);
        figure(1)
        imagesc(data.(fn{1})(manual.maybe_insect(n).y).normalized_data)
        title(sprintf('file %s with x=%i and y=%i and n=%i',fols(manual.maybe_insect(n).x).name,manual.maybe_insect(n).x,manual.maybe_insect(n).y,n),'interpreter','none');
        loc2=input('range number ');
        figure(2)
        plot(data.(fn{1})(manual.maybe_insect(n).y).normalized_data(loc2,:))
        title(sprintf('file %s with x=%i and y=%i and z=%i and n=%i',fols(manual.maybe_insect(n).x).name,manual.maybe_insect(n).x,manual.maybe_insect(n).y,loc2,n),'interpreter','none');
        isinsect=input('is this an insect (y/n/m)? ','s');
        if strcmp(isinsect,'y') || strcmp(isinsect,'m')
            int=int+1;
            manual_insects(int).filename=fn;
            manual_insects(int).x=manual.maybe_insect(n).x;
            manual_insects(int).y=manual.maybe_insect(n).y;
            manual_insects(int).z=loc2;
            manual_insects(int).yesORmaybe=isinsect;
        end
        more=input('are there other insects (y/n)? ','s');
        
    end
    
end
save(fullfile(pwd,'events','manual_insects.mat'),'manual_insects','-v7.3')
