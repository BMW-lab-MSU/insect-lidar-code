close all;
% for imageNum = 1:numel(adjusted_data_decembercal)
for imageNum = 76:100

    figure;
    imagesc(adjusted_data_decembercal(imageNum).normalized_data);
    title(['image ' num2str(imageNum)])

    Fs = 1/mean(diff(adjusted_data_decembercal(imageNum).time));
    f = linspace(-Fs/2, Fs/2, 1024);

%     for rowNum = 58:64
%         figure;
%         x = adjusted_data_decembercal(imageNum).normalized_data(rowNum,:);
%         subplot(211); plot(x);
%         subplot(212); plot(f, fftshift(abs(fft(x - mean(x)))));
%         suptitle(['image ' num2str(imageNum) ' row ' num2str(rowNum)])
%     end
end