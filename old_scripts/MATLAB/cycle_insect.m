
for n=1:size(insect,2);
m=find(insect(n).wing_frequency>0);
subplot(3,1,1);plot(insect(n).time,insect(n).td_data(m(1),:))
title(num2str(n))
subplot(3,1,2);plot(insect(n).frequency,insect(n).fd_data(m(1),:))
title(num2str(insect(n).wing_frequency(m)))
subplot(3,1,3);plot(insect(n).welch_f,insect(n).welch_d(m(1),:))
pause;
close all;
end
for n=1:size(insect,2)
rt(n)=rangefind(find(insect(n).wing_frequency>0,1));
y(n)=rt(n)*tand(insect(n).tilt_location);
x(n)=rt(n)*tand(insect(n).pan_location);
end
% % 
% % z_r=[0 rangefind(130)];
% % max_pan=z_r(2)*tand(42.5);
% % max_tilt=z_r(2)*tand(15);
% % min_pan=z_r(2)*tand(39);
% % min_tilt=z_r(2)*tand(1.5);
% % z_x=[0 min_pan];
% % z_y=[0 min_tilt];
% % m_x=[0 max_pan];
% % m_y=[0 max_tilt];
% % 
% % 
% % rmax=rangefind(130);
% % rp=[0 rmax rmax 0];
% % 
% % yp1=[0 min_tilt max_tilt 0];
% % yp2=[0 max_tilt max_tilt 0];
% % yp3=[0 min_tilt min_tilt 0];
% % xp1=[0 min_pan max_pan 0];
% % xp2=[0 max_pan max_pan 0];
% % xp3=[0 min_pan min_pan 0];
% % 
% % close all
% % hold on
% % patch(rp,xp1,yp2,'g','facealpha',.25)
% % patch(rp,xp1,yp3,'g','facealpha',.25)
% % patch(rp,xp2,yp1,'g','facealpha',.25)
% % patch(rp,xp3,yp1,'g','facealpha',.25)
% % 
% % 
% % 
% % plot3(rt,x,y,'k*',z_r,z_x,z_y,'k',z_r,z_x,m_y,'k',z_r,m_x,z_y,'k',z_r,m_x,m_y,'k')
% % grid on
% % title('spatial distribution of insects (green region shows scanning area)')
% % xlabel('range (m)')
% % ylabel('horizontal (m)')
% % zlabel('vertical (m)')
% % %% Find Percentage Threshold
% % % yes=[16 17 19 20 27 32 35 82 95];
% % yes=1:16;
% % no=setdiff(1:size(insect,2),yes);
% % 
% % window=50;
% % 
% % for n=1:length(yes)
% %     [max_yes(n),ind(n)]=max(insect(yes(n)).fd_data(find(insect(yes(n)).wing_frequency>0,1),:));
% %     med_yes(n)=mean(insect(yes(n)).fd_data(find(insect(yes(n)).wing_frequency>0,1),[1:ind(n)-window/2,ind(n)+window/2:end]));
% %     
% % end
% % ratio_yes=med_yes./max_yes;
% % disp(['max ratio is ' num2str(max(ratio_yes)*100) '%'])
% % % clear n ind
% % % for n=1:length(no)
% % %     [max_no(n),ind(n)]=max(insect(no(n)).fd_data(find(insect(no(n)).wing_frequency>0,1),:));
% % %     med_no(n)=mean(insect(no(n)).fd_data(find(insect(no(n)).wing_frequency>0,1),[1:ind(n)-window/2,ind(n)+window/2:end]));
% % %     
% % % end
% % % ratio_no=med_no./max_no;
% % % disp(['min ratio is ' num2str(min(ratio_no)*100) '%'])
% % 
% % %% Apply Threshold
% % %
% % % for n=1:size(insect,2)
% % %     med(n)=median(insect(n).fd_data(find(insect(n).wing_frequency>0,1),:));
% % %     maximum(n)=max(insect(n).fd_data(find(insect(n).wing_frequency>0,1),:));
% % % end
