dataDir = '/vol/data/research/afrl/data/insect-lidar/Data_2022/2022-06-24';

processedDataFiles = dir([dataDir filesep '*/adjusted_data_junecal.mat']);

for folderNum = 1:numel(processedDataFiles)
    cd(processedDataFiles(folderNum).folder);

    folders = split(processedDataFiles(folderNum).folder, filesep);
    folderName = folders{end};

    imageHandle = figure('Visible', 'off');

    load(processedDataFiles(folderNum).name);
    
    parfor imageNum = 1:numel(adjusted_data_junecal)
        imagesc(adjusted_data_junecal(imageNum).normalized_data);
        colorbar

        exportgraphics(imageHandle, [folderName '-image' num2str(imageNum), '.png']);
    end
end