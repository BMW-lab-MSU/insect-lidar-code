
%% time histogram
clear
close all
load('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-08\weather_data\weather_data.mat')
weather_data.temperatureC=([weather_data.temperatureF]-32).*(5/9);
onehr=datenum(datestr('09-Jan-2017 11:19:22','dd-mmm-yyyy HH:MM:SS'),'dd-mmm-yyyy HH:MM:SS')-datenum(datestr('09-Jan-2017 10:19:22','dd-mmm-yyyy HH:MM:SS'),'dd-mmm-yyyy HH:MM:SS');
start_file='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\SL_Insect_Figures\Profiles';
load(fullfile(start_file,'analysis_data.mat'));
sunrise=datenum('2016-06-08 05:41:00','yyyy-mm-dd HH:MM:SS');
sunset=datenum('2016-06-08 21:02:00','yyyy-mm-dd HH:MM:SS');
start_time=datestr(datenum(min([analysis_data.dnum])),'dd-mmm-yyyy HH:MM:SS');
end_time=datestr(datenum(max([analysis_data.dnum])),'dd-mmm-yyyy HH:MM:SS');
fprintf('start: %s | end: %s\n',start_time,end_time);
figure(1)
yyaxis left
h=histogram([analysis_data.dnum]);
h.BinWidth=onehr;
datetick('x',15)
xlabel('time (HH:MM)')
ylabel('number of insects')
title({'\makebox[4in][c]{possible insects collected on 2016-06-08 at}','\makebox[4in][c]{AMK Ranch with corresponding weather values}'},'interpreter','latex')
yyaxis right
p=plot([weather_data.date_num],[weather_data.temperatureC],'g',...
    [weather_data.date_num],[weather_data.humidity],'m--',...
    [weather_data.date_num],[weather_data.windspeed],'r:',...
    [sunset sunset],[0 100],'k');
ylim([0 80])
xlim([datenum('2016-06-08 09:00:00','yyyy-mm-dd HH:MM:SS'); datenum('2016-06-08 24:00:00','yyyy-mm-dd HH:MM:SS');])
text(sunset,75,'sunset \rightarrow','HorizontalAlignment','right')
ax2=gca;
ax2.YColor=[0 0 0];
legend(p,'temp. (C)','RH (%)','wind speed (km/h)','location','northwest')
yyaxis left
hold on
bcs=linspace(h.BinLimits(1)+mean(diff(h.BinEdges))/2,h.BinLimits(2)-mean(diff(h.BinEdges))/2,h.NumBins);
errorbar(bcs,h.Values,sqrt(h.Values),'k.')
hold off
%% frquency histogram
set_plot_defaults
hold off
lv=61;
for n=1:size(analysis_data,2)
    fund_freq(n)=analysis_data(n).max_peak;
    sorter(n)=analysis_data(n).max_peak;
    
    pk_loc=find(analysis_data(n).frequency==analysis_data(n).max_peak);
    scaled_data(n,:)=abs(analysis_data(n).gauss_freq_data).^2/abs(analysis_data(n).gauss_freq_data(pk_loc)).^2;
    tp_data(n,:)=interp1(analysis_data(n).frequency,scaled_data(n,:),analysis_data(lv).frequency);
end
figure(2)
fr=histogram(fund_freq);
fr.BinWidth=50;
hold on
bcs=linspace(fr.BinLimits(1)+mean(diff(fr.BinEdges))/2,fr.BinLimits(2)-mean(diff(fr.BinEdges))/2,fr.NumBins);
errorbar(bcs,fr.Values,sqrt(fr.Values),'k.')
hold off
xticks(0:150:1200)
xlim([50 1200])
xlabel('frequency (Hz)')
ylabel('number of insects')
title({'\makebox[4in][c]{histogram of wing-beat frequencies from possible}','\makebox[4in][c]{insects collected on 2016-06-08 at AMK Ranch}'},'interpreter','latex')
% title({'histogram of wing-beat frequencies from insects', 'collected on 2016-06-08 at AMK Ranch'})
figure(3)
[sorted, sort_index]=sort(sorter);
sur=imagesc(1:size(scaled_data,1),analysis_data(lv).frequency(513:end),tp_data(sort_index,513:end)',[0 1.1]);
set(gca,'ydir','normal')
ylim([20 1000])
xlim([1 size(scaled_data,1)])
hold on
plot(1:size(scaled_data,1),fund_freq(sort_index),'ro')
hold off
xlabel('insect number (in ascending order)')
ylabel('frequency (Hz)')
title({'\makebox[4in][c]{possible-insect wing-beat frequencies}','\makebox[4in][c]{detected on 2016-06-08 at AMK Ranch}'},'interpreter','latex')

%% spatial plot
set_plot_defaults
start_file='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\SL_Insect_Figures\Profiles';
load(fullfile(start_file,'analysis_data.mat'));

hold off
minr=0;
maxr=125;
mint=1.5;
maxt=15.5;
minp=39.0;
maxp=42.5;

x1=[minr (maxr*cosd(mint))*cosd(maxp) (maxr*cosd(maxt))*cosd(maxp)];
x2=[minr (maxr*cosd(mint))*cosd(minp) (maxr*cosd(maxt))*cosd(minp)];
x3=[minr (maxr*cosd(maxt))*cosd(maxp) (maxr*cosd(maxt))*cosd(minp)];
x4=[minr (maxr*cosd(mint))*cosd(maxp) (maxr*cosd(mint))*cosd(minp)];
x5=[(maxr*cosd(mint))*cosd(minp) (maxr*cosd(mint))*cosd(maxp) (maxr*cosd(maxt))*cosd(maxp) (maxr*cosd(maxt))*cosd(minp)];

y1=[minr (maxr*cosd(mint))*sind(maxp) (maxr*cosd(maxt))*sind(maxp)];
y2=[minr (maxr*cosd(mint))*sind(minp) (maxr*cosd(maxt))*sind(minp)];
y3=[minr (maxr*cosd(maxt))*sind(maxp) (maxr*cosd(maxt))*sind(minp)];
y4=[minr (maxr*cosd(mint))*sind(maxp) (maxr*cosd(mint))*sind(minp)];
y5=[(maxr*cosd(mint))*sind(minp) (maxr*cosd(mint))*sind(maxp) (maxr*cosd(maxt))*sind(maxp) (maxr*cosd(maxt))*sind(minp)];

z1=[minr maxr*sind(mint) (maxr*sind(maxt))];
z2=[minr maxr*sind(mint) (maxr*sind(maxt))];
z3=[minr (maxr*sind(maxt)) (maxr*sind(maxt))];
z4=[minr maxr*sind(mint) maxr*sind(mint)];
z5=[maxr*sind(mint) maxr*sind(mint) (maxr*sind(maxt)) (maxr*sind(maxt))];


for n=1:size(analysis_data,2)
    fund_freq(n)=analysis_data(n).max_peak;
    sorter(n)=analysis_data(n).max_peak;
end
[sorted, sort_index]=sort(sorter);


%% time
sevenoclock=datenum(datestr('08-Jun-2016 19:00:00','dd-mmm-yyyy HH:MM:SS'));
int=0;
ins=0;
for n=1:size(analysis_data,2)
    if analysis_data(n).dnum>=sevenoclock
        int=int+1;
        indexettm(int)=n;
    else
        ins=ins+1;
        indexestm(ins)=n;
    end
end
figure(6);
erltm=histogram([analysis_data(indexestm).tilt]);
erltm.BinWidth=1.5;
erltm.FaceColor=[1 0 0];
hold on
bcs=linspace(erltm.BinLimits(1)+mean(diff(erltm.BinEdges))/2,erltm.BinLimits(2)-mean(diff(erltm.BinEdges))/2,erltm.NumBins);
errorbar(bcs,erltm.Values,sqrt(erltm.Values),'r.')
hold off

hold on
figure(6);
ltetm=histogram([analysis_data(indexettm).tilt]);
ltetm.BinWidth=1.5;
ltetm.FaceColor=[0 0 1];
hold on
bcs=linspace(ltetm.BinLimits(1)+mean(diff(ltetm.BinEdges))/2,ltetm.BinLimits(2)-mean(diff(ltetm.BinEdges))/2,ltetm.NumBins);
errorbar(bcs,ltetm.Values,sqrt(ltetm.Values),'b.')
hold off

xlabel('tilt (degrees)')
ylabel('number of insects')
title({'\makebox[4in][c]{possible-insect numbers at each tilt angle}','\makebox[4in][c]{at AMK Ranch on 2016-06-08}'},'interpreter','latex')
legend([erltm ltetm],'insects before 19:00','insects after 19:00','location','best')
hold off
figure(7)
pl3tm=plot3(([analysis_data(indexestm).range].*cosd([analysis_data(indexestm).tilt])).*cosd([analysis_data(indexestm).pan]),...
    ([analysis_data(indexestm).range].*cosd([analysis_data(indexestm).tilt])).*sind([analysis_data(indexestm).pan]),...
    [analysis_data(indexestm).range].*sind([analysis_data(indexestm).tilt]),'rd',...
    ([analysis_data(indexettm).range].*cosd([analysis_data(indexettm).tilt])).*cosd([analysis_data(indexettm).pan]),...
    ([analysis_data(indexettm).range].*cosd([analysis_data(indexettm).tilt])).*sind([analysis_data(indexettm).pan]),...
    [analysis_data(indexettm).range].*sind([analysis_data(indexettm).tilt]),'b.');
legend('insects before 19:00','insects after 19:00','location','best')

pl3tm(2).MarkerSize=12;
pl3tm(1).MarkerSize=5;

hold on
opv=0.2;
edv=.2;
pat1=fill3(x1,y1,z1,'green');
pat2=fill3(x2,y2,z2,'green');
pat3=fill3(x3,y3,z3,'green');
pat4=fill3(x4,y4,z4,'green');
pat5=fill3(x5,y5,z5,'green');
pat1.EdgeAlpha=edv;
pat2.EdgeAlpha=edv;
pat3.EdgeAlpha=edv;
pat4.EdgeAlpha=edv;
pat5.EdgeAlpha=edv;
alpha(pat1,opv)
alpha(pat2,opv)
alpha(pat3,opv)
alpha(pat4,opv)
alpha(pat5,opv)

view([-2.3,20.4])

grid on
xlabel('x pan distance (m)')
ylabel('y pan distance (m)')
zlabel('height (m)')
set(gca,'Ztick',[0:10:30])

title({'\makebox[4in][c]{possible-insect spatial distribution on 2016-06-08 at}','\makebox[4in][c]{AMK Ranch (green polygon shows scan region)}'},'interpreter','latex')
hold off
%% frequency
int=0;
ins=0;
for n=1:size(analysis_data,2)
    if fund_freq(n)<=300
        int=int+1;
        indexet(int)=n;
    else
        ins=ins+1;
        indexes(ins)=n;
    end
end
figure(4);
erl=histogram([analysis_data(indexes).tilt]);
erl.BinWidth=1.5;
erl.FaceColor=[1 0 0];
hold on
bcs=linspace(erl.BinLimits(1)+mean(diff(erl.BinEdges))/2,erl.BinLimits(2)-mean(diff(erl.BinEdges))/2,erl.NumBins);
errorbar(bcs,erl.Values,sqrt(erl.Values),'r.')
hold off

hold on
figure(4);
lte=histogram([analysis_data(indexet).tilt]);
lte.BinWidth=1.5;
lte.FaceColor=[0 0 1];
hold on
bcs=linspace(lte.BinLimits(1)+mean(diff(lte.BinEdges))/2,lte.BinLimits(2)-mean(diff(lte.BinEdges))/2,lte.NumBins);
errorbar(bcs,lte.Values,sqrt(lte.Values),'b.')
hold off
xlabel('tilt (degrees)')
ylabel('number of insects')
title({'\makebox[4in][c]{possible-insect numbers at each tilt angle}','\makebox[4in][c]{at AMK Ranch on 2016-06-08}'},'interpreter','latex')
legend([erl lte],'wing-beat over 300 Hz','wing-beat under 300 Hz','location','best')
hold off

figure(5)
pl3=plot3(([analysis_data(indexes).range].*cosd([analysis_data(indexes).tilt])).*cosd([analysis_data(indexes).pan]),...
    ([analysis_data(indexes).range].*cosd([analysis_data(indexes).tilt])).*sind([analysis_data(indexes).pan]),...
    [analysis_data(indexes).range].*sind([analysis_data(indexes).tilt]),'rd',...
    ([analysis_data(indexet).range].*cosd([analysis_data(indexet).tilt])).*cosd([analysis_data(indexet).pan]),...
    ([analysis_data(indexet).range].*cosd([analysis_data(indexet).tilt])).*sind([analysis_data(indexet).pan]),...
    [analysis_data(indexet).range].*sind([analysis_data(indexet).tilt]),'b.');
legend('wing-beat over 300 Hz','wing-beat under 300 Hz','location','north')

pl3(2).MarkerSize=12;
pl3(1).MarkerSize=5;

hold on
opv=0.2;
edv=.2;
pat1=fill3(x1,y1,z1,'green');
pat2=fill3(x2,y2,z2,'green');
pat3=fill3(x3,y3,z3,'green');
pat4=fill3(x4,y4,z4,'green');
pat5=fill3(x5,y5,z5,'green');
pat1.EdgeAlpha=edv;
pat2.EdgeAlpha=edv;
pat3.EdgeAlpha=edv;
pat4.EdgeAlpha=edv;
pat5.EdgeAlpha=edv;
alpha(pat1,opv)
alpha(pat2,opv)
alpha(pat3,opv)
alpha(pat4,opv)
alpha(pat5,opv)

view([-2.3,20.4])

grid on
xlabel('x pan distance (m)')
ylabel('y pan distance (m)')
zlabel('height (m)')
set(gca,'Ztick',[0:10:30])
title({'\makebox[4in][c]{possible-insect spatial distribution on 2016-06-08 at}','\makebox[4in][c]{AMK Ranch (green polygon shows scan region)}'},'interpreter','latex')
hold off
%% all insects
figure(8)
pl3=plot3(([analysis_data.range].*cosd([analysis_data.tilt])).*cosd([analysis_data.pan]),...
    ([analysis_data.range].*cosd([analysis_data.tilt])).*sind([analysis_data.pan]),...
    [analysis_data.range].*sind([analysis_data.tilt]),'b.');

pl3(1).MarkerSize=12;

hold on
opv=0.2;
edv=.2;
pat1=fill3(x1,y1,z1,'green');
pat2=fill3(x2,y2,z2,'green');
pat3=fill3(x3,y3,z3,'green');
pat4=fill3(x4,y4,z4,'green');
pat5=fill3(x5,y5,z5,'green');
pat1.EdgeAlpha=edv;
pat2.EdgeAlpha=edv;
pat3.EdgeAlpha=edv;
pat4.EdgeAlpha=edv;
pat5.EdgeAlpha=edv;
alpha(pat1,opv)
alpha(pat2,opv)
alpha(pat3,opv)
alpha(pat4,opv)
alpha(pat5,opv)

view([-2.3,20.4])

grid on
xlabel('x pan distance (m)')
ylabel('y pan distance (m)')
zlabel('height (m)')
set(gca,'Ztick',[0:10:30])
title({'\makebox[4in][c]{possible-insect spatial distribution on 2016-06-08 at}','\makebox[4in][c]{AMK Ranch (green polygon shows scan region)}'},'interpreter','latex')
hold off
figure(9);
erltm=histogram([analysis_data.tilt]);
erltm.BinWidth=1.5;
erltm.FaceColor=[0 0 1];
hold on
bcs=linspace(erltm.BinLimits(1)+mean(diff(erltm.BinEdges))/2,erltm.BinLimits(2)-mean(diff(erltm.BinEdges))/2,erltm.NumBins);
errorbar(bcs,erltm.Values,sqrt(erltm.Values),'k.')
hold off
xlabel('tilt (degrees)')
ylabel('number of insects')
title({'\makebox[4in][c]{possible-insect numbers at each tilt angle}','\makebox[4in][c]{at AMK Ranch on 2016-06-08}'},'interpreter','latex')



