clear
close all
set_plot_defaults
dogauss=1;
dofreq=1;
fig_value='fig_9';
start_file='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\';
date='2015-10-06';
time='19_13_46';
filename=[fullfile(start_file,'Stored Data',date,time),'.mat'];
load(filename)
for n=1:size(datainfo,1);names{n}=horzcat(datainfo{n,1:2});end
% tho_pts=6201:7324;
tho_pts=1:size(data,2);
m=39;
info=datainfo(:,4:end);
di=cell2struct(info,names,1);
full_data=data(:,tho_pts);
start_address=[di(tho_pts).Startaddress];
tsdata=[di(1:length(tho_pts)).Timestamp];
[adjusted_data,tcdata,range]=fix_cell_struct(full_data,start_address,tsdata,true);
adjusted_data=adjusted_data-(mean(adjusted_data,2)*ones(1,size(adjusted_data,2)));
positive_data=abs(adjusted_data(m,:)-max(adjusted_data(m,:)));
% positive_data=(adjusted_data(m,:)-min(adjusted_data(m,:)));
fig_data.positive_data=positive_data;
fig_data.time_data=tcdata;
fig_data.range_data=range;
fig_data.location_data=m;
fig_data.date=date;
time(time=='_')=':';
fig_data.time=time;
if dogauss==1
    g=gaussmf(1:length(positive_data),[(838-329)/2,533]);
    np=g.*positive_data;
    fig_data.positive_data=np;
end
if isdir(fig_value)
    save(fullfile(start_file,'Figures','Thesis Figures',fig_value,'fig_data.mat'),'fig_data','-v7.3')
else
    mkdir(fullfile(start_file,'Figures','Thesis Figures',fig_value))
    save(fullfile(start_file,'Figures','Thesis Figures',fig_value,'fig_data.mat'),'fig_data','-v7.3')
end
% adjusted_data=a_data(:,6001:7000);
% tcdata=tcdata(1:1000);
%% new version
nop=size(fig_data.positive_data,2);
delta_t=mean(diff(fig_data.time_data));
max_freq=1./(2*delta_t);
% bpfilter = designfilt('bandpassfir','FilterOrder',100,'CutoffFrequency1',50,'CutoffFrequency2',1500,'SampleRate',max_freq*2);
% filt_data = filter(bpfilter,adjusted_data')';
delta_f=1/fig_data.time_data(end);
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_data=fftshift(fft(fig_data.positive_data,nop,2),2);
%%
gz_index=find(fqdata>=0);
fqi_d=fqdata(gz_index);
freqi_d=abs((freq_data(:,gz_index)/nop).^2);
[ii, jj] = sort(freqi_d,2,'descend');
[pxx,f]=pwelch(fig_data.positive_data',500,300,1024,max_freq*2);
%%
% subplot(2,3,[1,4])
if dofreq==0
    if dogauss==1
        figure(1)
        plot(fig_data.time_data,fig_data.positive_data)
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        title(sprintf('Insect at Towne''s Harvest beehive\nwith a Gaussian window on\n%s at %s at a distance of %2.1f m', fig_data.date,fig_data.time, fig_data.range_data(fig_data.location_data)))
        savefig(fullfile(start_file,'Figures','Thesis Figures',fig_value,[fig_value, '.fig']));
        saveas(gcf,fullfile(start_file,'Figures','Thesis Figures',fig_value,'Ginsw.png'));
    else
        
        figure(1)
        plot(fig_data.time_data,fig_data.positive_data)
        xlabel('time (s)')
        ylabel('normalized detected signal (arb)')
        title(sprintf('Insect at Towne''s Harvest beehive on\n%s at %s at a distance of %2.1f m', fig_data.date,fig_data.time, fig_data.range_data(fig_data.location_data)))
        savefig(fullfile(start_file,'Figures','Thesis Figures',fig_value,[fig_value, '.fig']));
        saveas(gcf,fullfile(start_file,'Figures','Thesis Figures',fig_value,'Gins.png'));
    end
else
    
    
    % % subplot(2,3,[2,3])
    figure(1)
    plot(fqdata,(abs(freq_data)).^2)
    xlim([0 1000])
    ylim([0 max((abs(freq_data(end/2+10:end)).^2))+2])
    xlabel('frequency (Hz)')
    ylabel('power (arb)')
    title(sprintf('Frequency spectrum using FFT algorithm of\ninsect at Towne''s Harvest beehive on\n%s at %s at a distance of %2.1f m', fig_data.date,fig_data.time, fig_data.range_data(fig_data.location_data)))
    savefig(fullfile(start_file,'Figures','Thesis Figures',fig_value,[fig_value, '.fig']));
    saveas(gcf,fullfile(start_file,'Figures','Thesis Figures',fig_value,'Ginsf.png'));
end

%
% % subplot(2,3,[5,6])
% figure(3)
% plot(f,pxx)
% ylim([0 max(pxx(20:end))])
% xlabel('frequency (Hz)')
% ylabel('power (arb)')
% title('Frequency derived from Welch''s spectral power algorithm')

%% old version
% nop=size(adjusted_data,2);
% delta_t=mean(diff(tcdata));
% max_freq=1./(2*delta_t);
% bpfilter = designfilt('bandpassfir','FilterOrder',100,'CutoffFrequency1',50,'CutoffFrequency2',1500,'SampleRate',max_freq*2);
% filt_data = filter(bpfilter,adjusted_data')';
% delta_f=1/tcdata(end);
% fqdata=(-nop/2:nop/2-1).*delta_f;
% freq_data=fftshift(fft(filt_data,nop,2),2);
% %%
% gz_index=find(fqdata>=0);
% fqi_d=fqdata(gz_index);
% freqi_d=abs((freq_data(:,gz_index)/nop).^2);
% [ii, jj] = sort(freqi_d,2,'descend');
% [pxx,f]=pwelch(filt_data',500,300,1024,max_freq*2);
% %%
% subplot(2,3,[1,4])
% plot(tcdata,adjusted_data(m,:))
% xlabel('time (s)')
% ylabel('return signal (V)')
% title(strvcat('Insect at Towne''s Harvest beehive on', ['2014-10-20 at 15:05 at a distance of ' num2str(range(m)) ' m']))
%
% subplot(2,3,[2,3])
% plot(fqdata,(abs(freq_data(m,:))/(nop)).^2)
% xlim([0 1800])
% xlabel('frequency (Hz)')
% ylabel('power (arb)')
% title('Frequency derived from FFT algorithm')
%
% subplot(2,3,[5,6])
% plot(f,pxx(:,115))
% xlabel('frequency (Hz)')
% ylabel('power (arb)')
% title('Frequency derived from Welch''s spectral power algorithm')
