ddf3=[ 16/12 38/12 73/12 ];
ddo=9:3:150;
dd=[ddf3 ddo];

[x,y]=size(adjusted_data);
[xd,yd]=size(adjusted_data(1).run);
d=zeros(xd,yd);
index=zeros(xd,yd);
rd=zeros(x,y);
for m = 1:x
    clear di
    di=diff(adjusted_data(m).run);
    d(m,:)=max(di);
    [xd,yd]=size(d);
    for n=1:yd
        index(m,n)=find(di(:,n)==d(m,n));
    end
    rd(m,1)=round(mean(index(m,:)));
end
rm=1*rd;
dm=0.3048*dd;

close all
m=polyfit(rm,dm',1);
fit_x=linspace(0,max(rm)+10,100);
fit_y=m(1)*fit_x+m(2);
lw=2;
fs=20;
fig=figure('units','normalized','outerposition',[0 0 1 1]);
plot(rm,dm,'b<',fit_x,fit_y,'k','LineWidth',lw)
title('Range Calibration','FontSize',fs)
ylabel('distance (m)','FontSize',fs)
xlabel('ADC peak output location (sample)','FontSize',fs)
legend('Recorded Data',...
    ['Linear Fit y = ',num2str(m(1)),' x + ',num2str(m(2))],...
    'Location','NorthWest','FontSize',fs)
set(gca,'FontSize',fs);
fulldir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures';
print(fig,fullfile(fulldir,'Calibration_Plot'),'-dpng');