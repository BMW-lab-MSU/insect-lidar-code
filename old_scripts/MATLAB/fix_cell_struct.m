function [adjusted_data,tcdata_es,range]=fix_cell_struct(full_data,start_address,tsdata,old_data);
if nargin<4
    old_data=false;
end
for n = 1:size(full_data,2)
    adjusted_data(1:length(full_data(:,n))+1+start_address(n),n) = ...
        full_data(-start_address(n):end,n);  
end
adjusted_data=adjusted_data(1:end-10,:);
nop=size(adjusted_data,2);
tcdata=(tsdata-tsdata(1))./1e6;
dt=diff(tcdata);
tcdata_es=mean(dt)*(0:nop-1);
% rangea=rangefind(1:size(adjusted_data,1));
% ma=mean(adjusted_data,2);%max(adjusted_data);
% mad=max(adjusted_data(:));
for n = 1:size(adjusted_data,1)
    adjusted_data(n,:) = interpsinc(tcdata,adjusted_data(n,:),mean(dt),1);
%         adjusted_data(n,:) = abs(adjusted_data(n,:)-mad);

%     adjusted_data(n,:) = abs(adjusted_data(n,:)-max(adjusted_data(n,:)));
%     adjusted_data(n,:) = adjusted_data(n,:)-mean(adjusted_data(n,:));

    %     if old_data==false

%     ma(n)=max(adjusted_data(n,:));
%     adjusted_data(n,:) = abs(adjusted_data(n,:)-ma(n));
%     end
end

adjusted_data=adjusted_data(8:end,:);
range=rangefind(8:size(adjusted_data,1)+7);
% mad=mean(adjusted_data,2);


%
% for n=1:length(insect_lidar)
%
%         imagesc(insect_lidar(n).adjusted_data)
%         title(num2str(n))
%
%         pause
%
% end
%
% % insect_lidar(1).adjusted_data = insect_lidar(1).data(-insect_lidar(1).start_address(1):end,1)
%
%
% for n = 1:size(insect_lidar,2)
%     for m = 1:size(insect_lidar(n).data,2)
%         insect_lidar(n).adjusted_data(1:length(insect_lidar(n).data(:,m))+1+insect_lidar(n).start_address(m),m) = ...
%             insect_lidar(n).data(-insect_lidar(n).start_address(m):end,m);
%     end
% end
% close all
%
% for n=74:length(insect_lidar)
%     imagesc(insect_lidar(n).adjusted_data)
%     title(n)
%     pause
% end

% d=dir(pwd);
% for m=3:size(d,1)
%     load(d(m).name);
%



%     nop=size(adjusted_data,2);
%     tcdata=(tsdata-tsdata(1))./1e6;
%     delta_t=mean(diff(tcdata));
%     max_freq=1./delta_t;
%     delta_f=(nop)./tcdata(end);
%
%      fqdata=(-nop/2:nop/2-1).*delta_f./nop;
%
%     freq_data=fft(adjusted_data,nop,2);
%     sf_data=fftshift(freq_data);
% %     log_fd=log(abs(freq_data));
%
%
%     close all
% %     subplot(1,2,1)
%     imagesc(tcdata,rangefind(1:size(adjusted_data,1)),adjusted_data);
% %     hold on
% %     surf(tcdata,rangefind(1:size(adjusted_data,1)),adjusted_data);
%
%     title(d(m).name)
%
%     xlabel('time (s)')
%     ylabel('range (m)')
%
% %     subplot(1,2,2)
% %     imagesc(fqdata(5:end),rangefind(1:size(adjusted_data,1)),log(abs(sf_data(:,5:end)))./(nop))
% %     title(d(m).name)
% %     xlabel('frequency (Hz)')
% %     ylabel('range (m)')
% %     xlim([0 500])
% %     set(gcf,'units','normalized','OuterPosition',[0, 0, 1, 1,])
%
%     pause
%
% end
% GAGE_CS14200_connect;
% location='Moth_Test-';
% date_dir=['C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\',datestr(now,'yyyy-mm-dd')];
% time_dir=[date_dir,'\',location,datestr(now,'HHMMSS')];
%
% if exist(date_dir,'dir') ~= 7
%     mkdir(date_dir);
% end
%
% mkdir(time_dir);
% full_data=zeros(200,1000);
% tsdata=zeros(1,1000);
%
% for q=1:500
%     GageContinuousRecord_Tauc
%     save(fullfile(time_dir,['mt',sprintf('%05.0f',q)]),'full_data','start_address','tsdata')
%
% end
% ret = CsMl_FreeSystem(handle);
%
