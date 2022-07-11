%% Insect_Lidar_GageMultipleRecord | from GAGE SDK (modified by Martin Tauc) | 2017-01-30
% This sample program demonstrates how to do a multiple record capture. The
% system's acquistion, channel and trigger parameters are set. The data is
% captured and retrieved and the data for each channel and multiple segment
% is saved to a separate file.

% clearvars -except panloc tiltloc QPT130 jog output tl full_data;
clearvars -except panloc tiltloc QPT130 jog output tl systems ret handle...
    raw_output sysinfo s acqInfo full_data fdy fdm n acqInfo.SegmentCount...
    start_pan end_pan delta_pan delta_tilt pause_time oc tilt_final nn pld tld pan_s_e...
    time_dir q pli tli full_data start_address tsdata panloc tiltloc nor wb rangev;

% commented out Liz 07/30/20
% tiltloc =0;
% 
% panloc = 0;

% date stamp current date and time
datestamp=datestr(now,30);
% run SDK scripts
CsMl_ResetTimeStamp(handle);
[ret, acqInfo] = CsMl_QueryAcquisition(handle);
ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);
status = CsMl_QueryStatus(handle);
%disp(status)
while status ~= 0
    
    status = CsMl_QueryStatus(handle);
%    disp(status)
end
% get information from Setup.m
transfer.Channel = 1;
transfer.Mode = CsMl_Translate('TimeStamp', 'TxMode');
transfer.Length = acqInfo.SegmentCount;
transfer.Segment = 1;
[ret, tsdata, tickfr] = CsMl_Transfer(handle, transfer);
transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;

% Regardless  of the Acquisition mode, numbers are assigned to channels in a
% CompuScope system as if they all are in use.
% For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8.
% All modes make use of channel 1. The rest of the channels indices are evenly
% spaced throughout the CompuScope system. To calculate the index increment,
% user must determine the number of channels on one CompuScope board and then
% divide this number by the number of channels currently in use on one board.
% The latter number is lower 12 bits of acquisition mode.

MaskedMode = bitand(acqInfo.Mode, 15);
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;

% Format a string with the number of segments and channels so all filenames
% have the same number of characters.
format_string = sprintf('%d', acqInfo.SegmentCount);
MaxSegmentNumber = length(format_string);
format_string = sprintf('%d', sysinfo.ChannelCount);
MaxChannelNumber = length(format_string);
format_string = sprintf([datestamp, '%%s_CH%%0%dd-%%0%dd.mat'], MaxChannelNumber, MaxSegmentNumber);

 
for channel = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = channel;
    for i = 1:acqInfo.SegmentCount
        transfer.Segment = i;
        [ret, data, actual] = CsMl_Transfer_Tauc(handle, transfer,1);
        CsMl_ErrorHandler(ret, 1, handle);
        
        % Note: to optimize the transfer loop, everything from
        % this point on in the loop could be moved out and done
        % after all the channels are transferred.
        
        % adjust the size so only the actual length of data is saved to the
        % file
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;
        % Get channel info for file header
        [ret, chanInfo] = CsMl_QueryChannel(handle, channel);
        CsMl_ErrorHandler(ret, 1, handle);
  
        
        % date and time
        year=str2num(datestamp(1:4));
        month=str2num(datestamp(5:6));
        day=str2num(datestamp(7:8));
        hour=str2num(datestamp(10:11));
        minute=str2num(datestamp(12:13));
        second=str2num(datestamp(14:15));
        
        
        % save raw data as structure
         

        full_data.data(:,i) = data';
        full_data.info.Start(i) = actual.ActualStart;
        full_data.info.SampleSize =  acqInfo.SampleSize;
        full_data.info.Length = actual.ActualLength;
        full_data.info.SampleResolution= acqInfo.SampleResolution;
        full_data.info.SampleOffset= acqInfo.SampleOffset;
        full_data.info.InputRange= chanInfo.InputRange;
        full_data.info.DcOffset= chanInfo.DcOffset;
        full_data.info.SegmentCount= acqInfo.SegmentCount;
        full_data.info.SegmentNumber= i;
        full_data.info.TimeStamp(i)= tsdata(i);
        full_data.info.Pan=panloc;
        full_data.info.Tilt=tiltloc;
        full_data.info.Date= datetime(year,month,day,hour,minute,second,'TimeZone','America/Denver');
        full_data.info.Date.TimeZone = 'UTC';
        
        full_data.info.Units.TimeZone = 'UTC';
        full_data.info.Units.Input_Range = 'volts';
        full_data.info.Units.DC_Offset = 'milivolts';
        full_data.info.Units.TimeStamp = 'microseconds';
        full_data.info.Units.Pan = 'degrees';
        full_data.info.Units.Tilt = 'degrees';
        full_data.info.Units.Date = 'year-month-day,hour-minute-second';
   
%    
       
    end

end

        
    
        
       