

function [full_data] = temp_data_fix(rd)

 for n = 1:size(rd.full_data,2)
    full_data.data(:,n) = rd.full_data(n).data;
    
    full_data.info.Start(n) = rd.full_data(n).info.Start;
    full_data.info.SampleSize(n) = rd.full_data(n).info.SampleSize;
    full_data.info.Length(n) = rd.full_data(n).info.Length;
    full_data.info.SampleResolution(n) = rd.full_data(n).info.SampleResolution;
    
    full_data.info.SampleOffset(n) = rd.full_data(n).info.SampleOffset;
    full_data.info.InputRange(n) = rd.full_data(n).info.InputRange;
    full_data.info.DcOffset(n) = rd.full_data(n).info.DcOffset;
    full_data.info.SegmentCount(n) = rd.full_data(n).info.SegmentCount;
    
    full_data.info.SegmentNumber(n) = rd.full_data(n).info.SegmentNumber;
    full_data.info.TimeStamp(n) = rd.full_data(n).info.TimeStamp;
    full_data.info.Pan(n) = rd.full_data(n).info.Pan;
    full_data.info.Tilt(n) = rd.full_data(n).info.Tilt;
    full_data.info.Date(n) = datetime(rd.full_data(n).info.Date,'TimeZone','America/Denver');
    full_data.info.Date.TimeZone = 'UTC';

 end

end

