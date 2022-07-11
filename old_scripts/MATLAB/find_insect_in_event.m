% field_name=fieldnames(insect_event);
% totcount=0;
% for x=1:length(field_name)
%     mcount=0;
%     for y=1:size(insect_event.(field_name{x}),2)
%         for z=1:size(insect_event.(field_name{x})(y).info,2)
%             totcount=totcount+1;
%             keepers(totcount).l=x;
%             keepers(totcount).n=y;
%             keepers(totcount).m=z;
%         end
%     end
% end
%
% event=insect_event;
% inc=0;
% inn=0;
% inw=0;
% start_h=1;
% for h=start_h:length(keepers)
%     subplot(2,2,1)
%     plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data,'b',...
%         event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data>=0.001),...
%         event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data>=0.001),'r')
%     title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n l=%2.2f, n=%2.2f, m=%2.2f',...
%         event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan,...
%         event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).range(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location),...
%         keepers(h).l,keepers(h).n,keepers(h).m),'interpreter','latex');
%     ylim([0 1.5])
%     xlabel('time (s)')
%     ylabel('detected response (DN)')
%
%      subplot(2,2,3)
%     plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)
%    title([sprintf('h=%5.0f of %5.0f - ',h,length(keepers)),'gauss data'],'interpreter','latex')
%     xlabel('time (s)')
%     ylabel('detected response (DN)')
%     try
%         xlim([event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time(find(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data(1:find(max(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)==event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data))<=0.00001,1,'last')) event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time(find(max(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)==event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)+find(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data(find(max(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)==event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data):end)<=0.00001,1,'first'))])
%     end
%
%
%     ylim([0 max(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).gauss_data)])
%     subplot(2,2,2)
%     plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency,abs((event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data)).^2)
%     title([sprintf('Wing-Beat spectrum using FFT')],'interpreter','latex') %,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename
%     xlabel('frequency (Hz)')
%     ylabel('power (arb.)')
%     xlim([0 2000])
%     ylim([0 max(abs((event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data(520:end))).^2)])
%     subplot(2,2,4)
%     plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_frequency,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_data)
%     title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
%     xlabel('frequency (Hz)')
%     ylabel('power (arb.)')
%     xlim([0 2000])
% %                             ylim([0 1e-6])
%     set(gcf,'units','normalized')
% %     set(gcf,'outerposition',[0.995238095238095,0.0304761904761905,1.00952380952381,0.977142857142857])
%
%     insect=input('insect e=yes,w=no,q=maybe?: ','s');
%     if strcmp(insect,'e')
%         inc=inc+1;
%         statistics_b.insect(inc).data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data;
%         statistics_b.insect(inc).positive_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data;
%         statistics_b.insect(inc).location=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location;
%         statistics_b.insect(inc).filename=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename;
%         statistics_b.insect(inc).time=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time;
%         statistics_b.insect(inc).pan=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan;
%         statistics_b.insect(inc).tilt=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt;
%         statistics_b.insect(inc).fft_frequency=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency;
%         statistics_b.insect(inc).fft_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data;
%         statistics_b.insect(inc).lower_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).lower_ratio;
%         statistics_b.insect(inc).upper_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).upper_ratio;
%     elseif strcmp(insect,'w')
%         inn=inn+1;
%         statistics_b.noninsect(inn).data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data;
%         statistics_b.noninsect(inn).positive_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data;
%         statistics_b.noninsect(inn).location=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location;
%         statistics_b.noninsect(inn).filename=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename;
%         statistics_b.noninsect(inn).time=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time;
%         statistics_b.noninsect(inn).pan=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan;
%         statistics_b.noninsect(inn).tilt=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt;
%         statistics_b.noninsect(inn).fft_frequency=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency;
%         statistics_b.noninsect(inn).fft_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data;
%         statistics_b.noninsect(inn).lower_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).lower_ratio;
%         statistics_b.noninsect(inn).upper_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).upper_ratio;
%     else
%         inw=inw+1;
%         statistics_b.maybeinsect(inw).data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data;
%         statistics_b.maybeinsect(inw).positive_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).positive_data;
%         statistics_b.maybeinsect(inw).location=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location;
%         statistics_b.maybeinsect(inw).filename=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename;
%         statistics_b.maybeinsect(inw).time=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time;
%         statistics_b.maybeinsect(inw).pan=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan;
%         statistics_b.maybeinsect(inw).tilt=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt;
%         statistics_b.maybeinsect(inw).fft_frequency=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency;
%         statistics_b.maybeinsect(inw).fft_data=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data;
%         statistics_b.maybeinsect(inw).lower_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).lower_ratio;
%         statistics_b.maybeinsect(inw).upper_ratio=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).upper_ratio;
%     end
%
%     %                         set(gcf,'units','normalized','outerposition',[1.13809523809524,0.173333333333333,0.961904761904762,0.834285714285714])
%     %                         pause
%     %                         close all
%     % % plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
% end
%
% % % hf=1500;
% % % lf=100;
% % % stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\';
% % % date='2016-06-08';
% % % dateinfo_dir=[stored_data,date];
% % % dateinfo=dir(fullfile(dateinfo_dir,'AMK*'));
% % % for n=1:size(dateinfo,1);run_time(n,:)=datenum(dateinfo(n).name(11:end),'HHMMSS');end
% % % mode_run_time=mode(diff(run_time));
% % % for n=1:size(statistics.insect,2)
% % %     clear fa floc_a fb floc_b fc floc_c delta_t max_freq pw_data pw_frequency pa ploc_a pb ploc_b pc ploc_c ratio_1 ratio_2
% % %
% % %     delta_t=mean(diff(statistics.insect(n).time));
% % %     max_freq=1./(2*delta_t);
% % %     [pw_data,pw_frequency]=pwelch(statistics.insect(n).data,gausswin(500),[],1024,max_freq*2);
% % %
% % %     [fa, floc_a]=max(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last'):find(statistics.insect(n).fft_frequency<=hf,1,'last'))));
% % %     [fb, floc_b]=min(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last'):find(statistics.insect(n).fft_frequency<=lf,1,'last')+floc_a)));
% % %     [fc, floc_c]=min(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last')+floc_a:find(statistics.insect(n).fft_frequency<=hf,1,'last'))));
% % %
% % %     [pa, ploc_a]=max(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     [pb, ploc_b]=min(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=lf,1,'last')+ploc_a)));
% % %     [pc, ploc_c]=min(abs(pw_data(find(pw_frequency<=lf,1,'last')+ploc_a:find(pw_frequency<=hf,1,'last'))));
% % %
% % %     try
% % %         fratio_1=fa/fb;
% % %     catch
% % %         fratio_1=1;
% % %     end
% % %     try
% % %         fratio_2=fa/fc;
% % %     catch
% % %         fratio_2=1;
% % %     end
% % %     try
% % %         ratio_1=pa/pb;
% % %     catch
% % %         ratio_1=1;
% % %     end
% % %     try
% % %         ratio_2=pa/pc;
% % %     catch
% % %         ratio_2=1;
% % %     end
% % %     statistics.insect(n).datenum=datenum([date,'-',num2str(str2num(statistics.insect(n).filename(11:16))+...
% % %         str2num(datestr(mode_run_time*(str2num(statistics.insect(n).filename(18:22))/240),'HHMMSS')))],'yyyy-mm-dd-HHMMSS');
% % %     statistics.insect(n).datetime=datetime([statistics.insect.datenum],'ConvertFrom','datenum');
% % %     statistics.insect(n).range=range;
% % %     statistics.insect(n).f_lower_ratio=fratio_1;
% % %     statistics.insect(n).f_upper_ratio=fratio_2;
% % %     statistics.insect(n).fmean=mean(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last'):find(statistics.insect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).fmedian=median(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last'):find(statistics.insect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).fmode=mode(abs(statistics.insect(n).fft_data(find(statistics.insect(n).fft_frequency<=lf,1,'last'):find(statistics.insect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).fa=fa;
% % %     statistics.insect(n).fb=fb;
% % %     statistics.insect(n).fc=fc;
% % %     statistics.insect(n).floc_a=statistics.insect(n).fft_frequency(find(statistics.insect(n).fft_frequency<=lf,1,'last')+floc_a-1);
% % %     statistics.insect(n).floc_b=statistics.insect(n).fft_frequency(find(statistics.insect(n).fft_frequency<=lf,1,'last')+floc_b-1);
% % %     statistics.insect(n).floc_c=statistics.insect(n).fft_frequency(find(statistics.insect(n).fft_frequency<=lf,1,'last')+floc_a+floc_c-1);
% % %     statistics.insect(n).pw_frequency=pw_frequency;
% % %     statistics.insect(n).pw_data=pw_data;
% % %     statistics.insect(n).pw_lower_ratio=ratio_1;
% % %     statistics.insect(n).pw_upper_ratio=ratio_2;
% % %     statistics.insect(n).pmean=mean(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).pmedian=median(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).pmode=mode(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.insect(n).pa=pa;
% % %     statistics.insect(n).pb=pb;
% % %     statistics.insect(n).pc=pc;
% % %     statistics.insect(n).ploc_a=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_a-1);
% % %     statistics.insect(n).ploc_b=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_b-1);
% % %     statistics.insect(n).ploc_c=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_a+ploc_c-1);
% % % end
% % %
% % % for n=1:size(statistics.noninsect,2)
% % %     clear fa floc_a fb floc_b fc floc_c delta_t max_freq pw_data pw_frequency pa ploc_a pb ploc_b pc ploc_c ratio_1 ratio_2
% % %
% % %     delta_t=mean(diff(statistics.noninsect(n).time));
% % %     max_freq=1./(2*delta_t);
% % %     [pw_data,pw_frequency]=pwelch(statistics.noninsect(n).data,gausswin(500),[],1024,max_freq*2);
% % %
% % %     [fa, floc_a]=max(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last'):find(statistics.noninsect(n).fft_frequency<=hf,1,'last'))));
% % %     [fb, floc_b]=min(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last'):find(statistics.noninsect(n).fft_frequency<=lf,1,'last')+floc_a)));
% % %     [fc, floc_c]=min(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last')+floc_a:find(statistics.noninsect(n).fft_frequency<=hf,1,'last'))));
% % %
% % %     [pa, ploc_a]=max(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     [pb, ploc_b]=min(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=lf,1,'last')+ploc_a)));
% % %     [pc, ploc_c]=min(abs(pw_data(find(pw_frequency<=lf,1,'last')+ploc_a:find(pw_frequency<=hf,1,'last'))));
% % %
% % %
% % %     try
% % %         fratio_1=fa/fb;
% % %     catch
% % %         fratio_1=1;
% % %     end
% % %     try
% % %         fratio_2=fa/fc;
% % %     catch
% % %         fratio_2=1;
% % %     end
% % %     try
% % %         ratio_1=pa/pb;
% % %     catch
% % %         ratio_1=1;
% % %     end
% % %     try
% % %         ratio_2=pa/pc;
% % %     catch
% % %         ratio_2=1;
% % %     end
% % %
% % %     statistics.noninsect(n).datenum=datenum([date,'-',num2str(str2num(statistics.noninsect(n).filename(11:16))+...
% % %         str2num(datestr(mode_run_time*(str2num(statistics.noninsect(n).filename(18:22))/240),'HHMMSS')))],'yyyy-mm-dd-HHMMSS');
% % %
% % %     statistics.noninsect(n).datetime=datetime([statistics.noninsect.datenum],'ConvertFrom','datenum');
% % %     statistics.noninsect(n).range=range;
% % %     statistics.noninsect(n).f_lower_ratio=fratio_1;
% % %     statistics.noninsect(n).f_upper_ratio=fratio_2;
% % %     statistics.noninsect(n).fmean=mean(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last'):find(statistics.noninsect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).fmedian=median(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last'):find(statistics.noninsect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).fmode=mode(abs(statistics.noninsect(n).fft_data(find(statistics.noninsect(n).fft_frequency<=lf,1,'last'):find(statistics.noninsect(n).fft_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).fa=fa;
% % %     statistics.noninsect(n).fb=fb;
% % %     statistics.noninsect(n).fc=fc;
% % %     statistics.noninsect(n).floc_a=statistics.noninsect(n).fft_frequency(find(statistics.noninsect(n).fft_frequency<=lf,1,'last')+floc_a-1);
% % %     statistics.noninsect(n).floc_b=statistics.noninsect(n).fft_frequency(find(statistics.noninsect(n).fft_frequency<=lf,1,'last')+floc_b-1);
% % %     statistics.noninsect(n).floc_c=statistics.noninsect(n).fft_frequency(find(statistics.noninsect(n).fft_frequency<=lf,1,'last')+floc_a+floc_c-1);
% % %     statistics.noninsect(n).pw_frequency=pw_frequency;
% % %     statistics.noninsect(n).pw_data=pw_data;
% % %     statistics.noninsect(n).pw_lower_ratio=ratio_1;
% % %     statistics.noninsect(n).pw_upper_ratio=ratio_2;
% % %     statistics.noninsect(n).pmean=mean(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).pmedian=median(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).pmode=mode(abs(pw_data(find(pw_frequency<=lf,1,'last'):find(pw_frequency<=hf,1,'last'))));
% % %     statistics.noninsect(n).pa=pa;
% % %     statistics.noninsect(n).pb=pb;
% % %     statistics.noninsect(n).pc=pc;
% % %     statistics.noninsect(n).ploc_a=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_a-1);
% % %     statistics.noninsect(n).ploc_b=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_b-1);
% % %     statistics.noninsect(n).ploc_c=pw_frequency(find(pw_frequency<=lf,1,'last')+ploc_a+ploc_c-1);
% % %
% % % end
% % % % % % % % % hold off
% % % % % % % % % close all
% % % % % % % % %
% % % % % % % % % field_name=fieldnames(statistics.insect);
% % % % % % % % % for n=10:size(field_name,1)
% % % % % % % % %     figure(n);
% % % % % % % % %     histogram([statistics.insect.(field_name{n})],'Normalization','pdf')
% % % % % % % % %     hold on
% % % % % % % % %     histogram([statistics.noninsect.(field_name{n})],'Normalization','pdf')
% % % % % % % % %     hold off
% % % % % % % % %     legend('insect','non insect')
% % % % % % % % %     title(field_name{n},'interpreter','none')
% % % % % % % % % end
% % % % % %
% % % % az=-3.1;el=2;
% % % % for tim=10:20;
% % % %     close all
% % % %     dnum1=datenum(['2016-06-08 ',num2str(tim),':00:00'],'yyyy-mm-dd HH:MM:SS');
% % % %     dnum2=datenum(['2016-06-08 ',num2str(tim+1),':00:00'],'yyyy-mm-dd HH:MM:SS');
% % % %     current_index=find([statistics.insect.datenum]>=dnum1 & [statistics.insect.datenum]<dnum2);
% % % %
% % % %
% % % %     plot3(statistics.insect(1).range([statistics.insect(current_index).location]),...
% % % %         sind([statistics.insect(current_index).pan]).*statistics.insect(1).range([statistics.insect(current_index).location]),...
% % % %         sind([statistics.insect(current_index).tilt]).*statistics.insect(1).range([statistics.insect(current_index).location]),...
% % % %         'o')
% % % %     ylabel('horizontal position (m)')
% % % %     zlabel('vertical position (m)')
% % % %     xlabel('range (m)')
% % % %     xlim([0 120])
% % % %     ylim([0 50])
% % % %     zlim([0 20])
% % % %     tite=['insect locations between ', datestr(dnum1,'HH:MM'), ' and ', datestr(dnum2,'HH:MM'), ' on ', datestr(dnum1,'yyyy-mm-dd')];
% % % %     title(tite);
% % % %     tite(tite==':')='=';
% % % %     tite(tite==' ')='_';
% % % %
% % % %     grid on
% % % %     view(az,el)
% % % %     % set(gca,'CameraViewAngle',7.5287,'CameraPosition',[-45.8415 -801.0747 32.9063],'View',[-7.5 7.6])
% % % %     savefig(fullfile(pwd,'first_figures',tite));
% % % %     print(fullfile(pwd,'first_figures',tite),'-dpng');
% % % %
% % % %
% % % % end
% % % % %
% % % % % for n=1:size(statistics.insect,2)
% % % % %                         subplot(2,3,[1 4])
% % % % %                         plot(statistics.insect(n).time,statistics.insect(n).positive_data,'b')
% % % % %                         title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n',...
% % % % %                             statistics.insect(n).tilt,statistics.insect(n).pan,statistics.insect(n).range(statistics.insect(n).location)),'interpreter','latex');
% % % % %                         xlabel('time (s)')
% % % % %                         ylabel('detected response (DN)')
% % % % %                         ylim([0 1.5])
% % % % %                         subplot(2,3,[2 3])
% % % % %                         plot(statistics.insect(n).fft_frequency,abs(statistics.insect(n).fft_data).^2)
% % % % %                         title(sprintf('Wing-Beat spectrum using FFT'),'interpreter','latex')
% % % % %                         xlabel('frequency (Hz)')
% % % % %                         ylabel('power (arb.)')
% % % % %                         xlim([100 1500])
% % % % %                         ylim([0 statistics.insect(n).fa^2])
% % % % %                         subplot(2,3,[5 6])
% % % % %                          plot(statistics.insect(n).pw_frequency,statistics.insect(n).pw_data)
% % % % %                         title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
% % % % %                         xlabel('frequency (Hz)')
% % % % %                         ylabel('power (arb.)')
% % % % %                         xlim([100 1500])
% % % % %                         ylim([0 statistics.insect(n).pa])
% % % % %                         set(gcf,'units','normalized')
% % % % %                         set(gcf,'outerposition',[0.995238095238095,0.0304761904761905,1.00952380952381,0.977142857142857])
% % % % %
% % % % % %                         set(gcf,'units','normalized','outerposition',[1.13809523809524,0.173333333333333,0.961904761904762,0.834285714285714])
% % % % %                         pause
% % % % %                         close all
% % % % % % % plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
% % % % % end
% % % % % % % %
% % % % % for n=1:size(statistics.noninsect,2)
% % % % %                         subplot(2,3,[1 4])
% % % % %                         plot(statistics.noninsect(n).time,statistics.noninsect(n).positive_data,'b')
% % % % %                         title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n',...
% % % % %                             statistics.noninsect(n).tilt,statistics.noninsect(n).pan,statistics.noninsect(n).range(statistics.noninsect(n).location)),'interpreter','latex');
% % % % %                         xlabel('time (s)')
% % % % %                         ylabel('detected response (DN)')
% % % % %                         ylim([0 1.5])
% % % % %                         subplot(2,3,[2 3])
% % % % %                         plot(statistics.noninsect(n).fft_frequency,abs(statistics.noninsect(n).fft_data).^2)
% % % % %                         title(sprintf('Wing-Beat spectrum using FFT'),'interpreter','latex')
% % % % %                         xlabel('frequency (Hz)')
% % % % %                         ylabel('power (arb.)')
% % % % %                         xlim([100 1500])
% % % % %                         ylim([0 statistics.noninsect(n).fa^2])
% % % % %                         subplot(2,3,[5 6])
% % % % %                          plot(statistics.noninsect(n).pw_frequency,statistics.noninsect(n).pw_data)
% % % % %                         title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
% % % % %                         xlabel('frequency (Hz)')
% % % % %                         ylabel('power (arb.)')
% % % % %                         xlim([100 1500])
% % % % %                         ylim([0 statistics.noninsect(n).pa])
% % % % %                         set(gcf,'units','normalized')
% % % % %                         set(gcf,'outerposition',[0.995238095238095,0.0304761904761905,1.00952380952381,0.977142857142857])
% % % % %
% % % % % %                         set(gcf,'units','normalized','outerposition',[1.13809523809524,0.173333333333333,0.961904761904762,0.834285714285714])
% % % % %                         pause
% % % % %                         close all
% % % % % % % plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
% % % % % end
% % % % % % % %

%%
field_name=fieldnames(statistics_b);
k=1;
for h=1:length(statistics_b.(field_name{k}))
    [maxv,maxi]=findpeaks(abs(statistics_b.(field_name{k})(h).fft_data(512:end)).^2);
    [tminv,mini]=findpeaks(1.01*max(abs(statistics_b.(field_name{k})(h).fft_data(512:end)).^2)-abs(statistics_b.(field_name{k})(h).fft_data(512:end)).^2);
    minv=abs(statistics_b.(field_name{k})(h).fft_data(511+mini)).^2;
    std_th=0;
    wl_var=500;
    while wl_var>20 && std_th<max(abs(statistics_b.(field_name{k})(h).fft_data(512:end)).^2)
        std_th=std_th+0.001;
        new_maxi=maxi(find(maxv>std_th));
        dm=diff(statistics_b.(field_name{k})(h).fft_frequency(511+new_maxi));
        wl_var=std(dm);
        disp([wl_var, std_th])
        %         pause(0.01)
    end
    clear lower_min upper_min upper_ratio lower_ratio
    if size(new_maxi,2)>1
        
        for l=2:size(new_maxi,2)
            lower_min(l-1)=minv(find(statistics_b.(field_name{k})(h).fft_frequency(511+mini)<statistics_b.(field_name{k})(h).fft_frequency(511+new_maxi(l)),1,'last'));
            try
                upper_min(l-1)=minv(find(statistics_b.(field_name{k})(h).fft_frequency(511+mini)>statistics_b.(field_name{k})(h).fft_frequency(511+new_maxi(l)),1,'first'));
            catch
                upper_min(l-1)=statistics_b.(field_name{k})(h).fft_frequency(end);
            end
            lower_ratio(l-1)=lower_min(l-1)/new_maxi(l-1);
            upper_ratio(l-1)=upper_min(l-1)/new_maxi(l-1);
        end
    else
        lower_min=0;
        upper_min=0;
        lower_ratio=0;
        upper_ratio=0;
    end
    
    
    
    
    statistics_b.(field_name{k})(h).median_peaks=median(dm);
    statistics_b.(field_name{k})(h).std_peaks=std(dm);
    statistics_b.(field_name{k})(h).std_th=std_th;
    statistics_b.(field_name{k})(h).maxv=maxv;
    statistics_b.(field_name{k})(h).maxi=new_maxi;
    statistics_b.(field_name{k})(h).lower_min=lower_min;
    statistics_b.(field_name{k})(h).upper_min=upper_min;
    statistics_b.(field_name{k})(h).l_ratio=lower_ratio;
    statistics_b.(field_name{k})(h).u_ratio=upper_ratio;
    
    if std(dm)==0
        statistics_b.(field_name{k})(h).p_ratio=max(abs(statistics_b.(field_name{k})(h).fft_data(512:end)).^2)/median(dm);
    else
        statistics_b.(field_name{k})(h).p_ratio=[];
    end
end


%%
field_name=fieldnames(statistics_b);
k=1;
int=0;
for h=1:size(statistics_b.(field_name{k}),2)
    if size(statistics_b.(field_name{k})(h).l_ratio,2)<2
        int=int+1;
        m_p.(field_name{k})(int).lr=statistics_b.(field_name{k})(h).l_ratio;
        m_p.(field_name{k})(int).ur=statistics_b.(field_name{k})(h).u_ratio;
        
    end
end
















