base_dir = 'C:\Users\orsl\Downloads';

FP = csvread(fullfile(base_dir,'FalsePositives.csv'));
names = {'prediction value','max peak','max amp','kurtosis','peak deviation','peak ratio','number of peaks','harmonic measurement'};
for n = 2:7
    figure(n-1)
    scatter(FP(:,1),FP(:,n))
    xlabel(names{1})
    ylabel(names{n})
    title(names{n})
end
