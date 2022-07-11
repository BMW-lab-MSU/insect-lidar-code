for n=1:size(processed_data,2)
    subplot(2,2,1)
    contour(processed_data(n).time,1./processed_data(n).period,log2(processed_data(n).power));colorbar
    title(num2str(processed_data(n).index(2)))
    subplot(2,2,2)
    imagesc(processed_data(n).time,rangefind(1:size(processed_data(n).data_2d,1)),processed_data(n).data_2d)
    title(num2str(rangefind(processed_data(n).index(2))))
    subplot(2,2,3)
    plot(processed_data(n).time,processed_data(n).data)
    ylim([0 17000])
    title(num2str(n))
    subplot(2,2,4)
    
%     data=processed_data(n).data;
%     n=52;
%     ogdata=data;
%     data=y(37,:);
%     data=x;
% data=adjusted_data(37,:);
    data=long_data;
    nop=size(data,2);
%     tcdata=tcdata_es;
%     tcdata=processed_data(n).time(1:nop);
    delta_t=mean(diff(tcdata));
    max_freq=1./(2*delta_t);
    delta_f=1/tcdata(end);
    fqdata=(-nop/2:nop/2-1).*delta_f;
    freq_data=fft(data,nop,2);
    sf_data=fftshift(freq_data);
    figure
    plot(fqdata(5:end),(abs(sf_data(:,5:end))./(nop)).^2)
    xlim([0 1500])
    pause
end