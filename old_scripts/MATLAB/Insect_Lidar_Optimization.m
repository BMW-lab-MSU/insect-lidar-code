function [insect]=Insect_Lidar_Optimization(date)

stored_data='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data'; %Rack Directory
date_info=fullfile(stored_data,date,'processed_data\events');
int=0;
for s1=300:10:400;
    for s2=4:1:8;
        for s3=.75:0.05:1.25;
            clear datedir event keepers field_name h
            datedir=dir(fullfile(date_info,sprintf('*fTH_%4.2f_sTH_%4.2f_tTH_%4.2f*',s1,s2,s3)));
            try
            load(fullfile(date_info,datedir(1).name));
            load(fullfile(date_info,datedir(2).name));
            field_name=fieldnames(event);
            int=int+1;
            
            
            for h=1:size(keepers,2)
                insect(int).info=sprintf('%4.2f, %4.2f, %4.2f',s1,s2,s3);
                insect(int).event(h).location=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location;
                insect(int).event(h).name=event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).filename;
            end
            catch
                disp(sprintf('couldn''t load file %4.2f, %4.2f, %4.2f',s1,s2,s3));
            end
            for h=1:size(keepers,2)
                subplot(2,3,[1 4])
                plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).time,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).data)
                title(sprintf('Insect at: Tilt Angle %2.2f. Pan Angle %2.2f, Range %2.2f.\n l=%2.2f, n=%2.2f, m=%2.2f. s1 = %4.2f, s2 = %4.2f, s3 = %4.2f',...
                    event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).tilt,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pan,...
                    event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).range(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).location),...
                    keepers(h).l,keepers(h).n,keepers(h).m,s1,s2,s3),'interpreter','latex');
                xlabel('time (s)')
                ylabel('detected response (DN)')
                ylim([0 6000])
                subplot(2,3,[2 3])
                plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_frequency,abs((event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).fft_data)).^2)
                title(sprintf('Wing-Beat spectrum using FFT'),'interpreter','latex')
                xlabel('frequency (Hz)')
                ylabel('power (arb.)')
                xlim([0 1500])
                ylim([0 1e9])
                subplot(2,3,[5 6])
                plot(event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_frequency,event.(field_name{keepers(h).l})(keepers(h).n).info(keepers(h).m).pw_data)
                title(sprintf('Wing-Beat spectrum using Welch''s Power'),'interpreter','latex')
                xlabel('frequency (Hz)')
                ylabel('power (arb.)')
                xlim([0 1500])
                ylim([0 1000])
                set(gcf,'units','normalized')
                set(gcf,'outerposition',[0.995238095238095,0.0304761904761905,1.00952380952381,0.977142857142857])
                pause
                close all
            end
        end
    end
end

% for n=1:size(insect,2)
%     for m=1:size(insect(n).event,2)
%         for o=m:size(insect,2)
%             for p=1:size(insect(o).event,2)
%         insect(n).event(m).(num2str(o))(m)=strcmp(insect(n).event(m).name,insect(o).event(p).name);
%             end
%         end
%     end
% end
