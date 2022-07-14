function dataVolts = convertAdcCountsToVolts(rawData, metadata)
% convertAdcCountsToVolts
%
% Convert raw ADC values from the Gage CS14200 ADC into volts.
%
%   dataVolts = convertAdcCountsToVolts(rawData, metadata)
%   With the way the data is saved during data collection
%   (see Insect_Lidar_GageContinuousRecord.m for details),
%   typical usage will be:
%   dataVolts = convertAdcCountstovolts(full_data.data, full_data.info)


dcOffsetVolts = metadata.DcOffset / 1000;

normalizedAdcCount = (metadata.SampleOffset - double(rawData)) / metadata.SampleResolution;

dataVolts = normalizedAdcCount * (metadata.InputRange / 2000) + dcOffsetVolts;

% dataVolts = (((metadata.SampleOffset - double(rawData)) / metadata.SampleResolution) * (metadata.InputRange / 2000)) + dcOffsetVolts
end