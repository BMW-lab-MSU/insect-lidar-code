function imageLabels = createImageLabelVector(csvFile, nImages)

    labelTable = readtable(csvFile);

    imageLabels = false(1, nImages);

    nInsects = height(labelTable);

    for insectNum = 1:nInsects
        insect = labelTable(insectNum, :);

        imageLabels(insect.imageNum) = true;
    end
end



    