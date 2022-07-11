function []=Insect_Lidar_Classify(date)

stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\'; %Rack Directory
wrk_dir=dir(fullfile(stored_data,date,'AMK*'));
wrk_dir=wrk_dir([wrk_dir.isdir]);
for l=1:size(wrk_dir,1);
    clear adjusted_data temp
    load(fullfile(stored_data,date,wrk_dir(l).name,'adjusted_data.mat'))
    %     load('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\AMK_Ranch-090925\adjusted_data.mat');
    int=0;
    for n=1:size(adjusted_data,2)
        temp.mean(n).raw_data=adjusted_data(n).data;
        temp.mean(n).data=mean(adjusted_data(n).data,2);
        temp.mean(n).diff=max(diff(temp.mean(n).data));
        
        if temp.mean(n).diff<40
            int=int+1;
            temp.keep(int).data=temp.mean(n).data;
            %         plot(temp.mean(n).data)
            %         title(sprintf('T/F=%1.0f, n=%3.0f',temp.mean(n).tf,n))
            %         pause
        end
        %     plot(temp.mean(n).data)
        %     title(sprintf('T/F=%1.0f, n=%3.0f',temp.mean(n).tf,n))
        %     pause
    end
    figure(1)
    plot([temp.mean.diff],'o')
    figure(2)
    plot([temp.keep.data])
    temp.background=mean([temp.keep.data],2);
    
    for n=1:size(adjusted_data,2)
        for m=1:size(adjusted_data(n).data,2)
            temp.ped_sub(n).data(:,m)=temp.mean(n).raw_data(:,m)./temp.background;
        end
        adjusted_data(n).normalized_data=temp.ped_sub(n).data;
    end
    save(fullfile(stored_data,date,wrk_dir(l).name,'adjusted_data.mat'),'adjusted_data','-v7.3')
    
end