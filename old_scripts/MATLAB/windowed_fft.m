%% windowed_fft

% loc=83;
dt=diff(tcdata);
tcdata_es=mean(dt)*(0:nop-1);
for loc=1:size(adjusted_data,1)
aesd(loc,:)=interpsinc(tcdata,adjusted_data(loc,:),mean(dt),1);
aesd(loc,:)=max(aesd(loc,:))-aesd(loc,:);
end
% aesd=interp1(tcdata,adjusted_data(loc,:),tcdata_es,'next');
% aesd=max(aesd)-aesd;
% g=gaussmf(tcdata_es,[.015 .14])*3000;
% 
% figure(1)
% plot(tcdata_es,aesd,'b',tcdata_es,g,'r')

% aesdg=aesd.*g;
% figure(2)
% plot(tcdata_es,aesdg)
range=rangefind(1:size(adjusted_data,1));

freq_data=fft(aesd,2^10,2);
sf_data=fftshift(freq_data);

figure(3)
imagesc(fqdata,range,abs(sf_data).^1)
% ylim([0 1.5e8])
% xlim([0 1300])
% plot(tcdata,max(adjusted_data(loc,:))-adjusted_data(loc,:),'b',tcdata_es,aesd,'r')