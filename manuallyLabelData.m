function labels = manuallyLabelData(basePath, date, scanName, dataFilename, structName)
    arguments 
        basePath (1,1) string;
        date (1,1) string;
        scanName (1,1) string;
        dataFilename (1,1) string = "adjusted_data_junecal_volts";
        structName (1,1) string = "adjusted_data_junecal"
    end

    % table to store label information
    labels = table();

    dataStruct = load(basePath + filesep + date + filesep + scanName + ...
        filesep + dataFilename);

    nImages = numel(dataStruct.(structName));

    % rename the data structure for convenience
    data = dataStruct.(structName);

    % For each image in the scan
    for imageNum = 1:nImages

        % plot the image for manual inspection;
        % the voltage from the PMT is between -1.5 and 0.5 volts
        imagesc(data(imageNum).data);
        colormap(flipud(colormap('parula')));
        colorbar;

        % pause so the image actually shows 
        % up...
        % for some reason, the figure window was not showing up
        % before the user prompt was reached
        pause(0.00001)
    
        % while there are still potential insects in the image
        while true

            % prompt the user for inect presence
            insectPresent = promptForInsectPresence();

            if insectPresent
                % get insect details (row, start column, end column) from the user
                [startRow, endRow, startCol, endCol] = promptForInsectDetails();

                % look at the fourier transform of the insect to further verify the presence/non-presence of the potential inesct.
                spectrumFigHandle = plotInsectSpectrum(data(imageNum), startRow, endRow, startCol, endCol);

                pause(0.00001);
                
                % prompt the user for their confidence in the potential insect
                confidence = promptForInsectConfidence();

                close(spectrumFigHandle);

                labels = addInsectToLabels(labels, date, scanName, imageNum, startRow, endRow, startCol, endCol, confidence);
            else
                % no more insects are present, so stop the loop
                break;
            end
        end
    end

    writetable(labels, basePath + filesep + date + filesep + scanName + ...
        filesep + "labels.csv");

end

function [startRow, endRow, startCol, endCol] = promptForInsectDetails()
    restart = true;
    while restart
        restart = false;

        while true
            startRow = input("First row of inesct (0 to restart): ");
            if startRow == 0
                restart = true;
                break;
            elseif startRow < 1
                warning("invalid input; must be a positive number");
            else
                break;
            end
        end

        if restart
            continue;
        end;

        while true
            endRow = input("Last row of inesct (0 to restart): ");
            if endRow == 0
                restart = true;
                break;
            elseif endRow < startRow
                warning("invalid input; must be >= first insect row");
            else
                break;
            end
        end

        if restart
            continue;
        end;

        while true
            startCol = input("Starting column for insect (0 to restart): ");
            if startCol == 0
                restart = true;
                break;
            elseif startCol < 1
                warning("invalid input; must be a positive number");
            else
                break;
            end
        end

        if restart
            continue;
        end;

        while true
            endCol = input("Ending column for insect (0 to restart): ");
            if endCol == 0
                restart = true;
                break;
            elseif endCol < startCol
                warning("invalid input; must be >= first insect column");
            else
                break;
            end
        end
    end
end

function insectPresent = promptForInsectPresence()
    inputIsInvalid = true;

    while inputIsInvalid
        userInput = input("Are there any (more) potential insects in this image? ", "s");

        if strcmpi(userInput, "y")
            inputIsInvalid = false;
            insectPresent = true;
        elseif strcmpi(userInput, "n")
            inputIsInvalid = false;
            insectPresent = false;
        else
            warning("invalid input: " + userInput + ". Should be 'y' or 'n'");
        end
    end
end

function confidence = promptForInsectConfidence()
    inputIsInvalid = true;

    while inputIsInvalid
        confidence = input("How likely is this an insect? 0--4: 0 -> not an insect, 4 --> definitely an insect ");

        if 0 <= confidence <= 4
            inputIsInvalid = false;
            insectPresent = true;
        else
            inputIsInvalid = true;
            warning("invalid input: needs to be between 0 and 4");
        end
    end
end

function figHandle = plotInsectSpectrum(data, startRow, endRow, startCol, endCol)

    insectRows = data.data(startRow:endRow, startCol:endCol);

    % sometimes the insects span multiple rows because there's a range bin
    % uncertainty due to the lidar instrument.
    % Add all insect rows together to get better SNR
    insect = sum(insectRows);

    FFT_SIZE = 1024;
%     FFT_SIZE = nextpow2(numel(insect));

    % compute the pulse reptition frequency, i.e. PRF, i.e. sampling frequency
    prf = 1/mean(diff(data.time));


    insectSpectrum = abs(fft(insect, FFT_SIZE)).^2;
    
    % we only need to look at the one-sided spectrum
    insectSpectrum = insectSpectrum(1:end/2);

    f = linspace(0, prf/2, numel(insectSpectrum));

    figHandle = figure;

    subplot(2,1,1)
    plot(data.time(startCol:endCol), insectRows, 'LineWidth', 1.5);
    xlabel('seconds');
    subplot(2,1,2)
    plot(f, insectSpectrum, 'LineWidth', 1.5);
    xlabel('hertz');

end

function labels = addInsectToLabels(labels, date, scanName, imageNum, startRow, endRow, startCol, endCol, confidence)

    labelData.date = date;
    labelData.scanName = scanName;
    labelData.imageNum = imageNum;
    labelData.startRow = startRow;
    labelData.endRow = endRow;
    labelData.startCol = startCol;
    labelData.endCol = endCol;

    if confidence > 0
        labelData.confidence = confidence;
        labels = [labels; struct2table(labelData)];
    else
        % no insect, so don't add a label to the table
    end
end