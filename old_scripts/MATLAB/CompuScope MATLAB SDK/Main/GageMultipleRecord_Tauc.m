% GageMultipleRecord.m sample progam
% This sample program demonstrates how to do a multiple record capture. The
% system's acquistion, channel and trigger parameters are set. The data is
% captured and retrieved and the data for each channel and multiple segment
% is saved to a separate file.

clearvars -except panloc tiltloc QPT130 jog output tl raw_output;
% clearvars -except panloc tiltloc QPT130 jog output tl systems ret handle sysinfo s acqInfo full_data;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

datestamp=datestr(now,30);
% datestamp='20160218T134259';

[ret, sysinfo] = CsMl_GetSystemInfo(handle);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

Setup(handle);

CsMl_ResetTimeStamp(handle);

ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
end
% Get timestamp information
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
    
        % Adjust the size so only the actual length of data is saved to the
        % file
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;                
        % Get channel info for file header    
        [ret, chanInfo] = CsMl_QueryChannel(handle, channel);            
        CsMl_ErrorHandler(ret, 1, handle);
        % Get information for ASCII file header
        info.Start = actual.ActualStart;
        full_info(1)=info.Start;
        info.Length = actual.ActualLength;
        full_info(2)=info.Length;
        info.SampleSize = acqInfo.SampleSize;
        full_info(3)=info.SampleSize;
        info.SampleRes = acqInfo.SampleResolution;
        full_info(4)=info.SampleRes;
        info.SampleOffset = acqInfo.SampleOffset;
        full_info(5)=info.SampleOffset;
        info.InputRange = chanInfo.InputRange;
        full_info(6)=info.InputRange;
        info.DcOffset = chanInfo.DcOffset;
        full_info(7)=info.DcOffset;
        info.SegmentCount = acqInfo.SegmentCount;
        full_info(8)=info.SegmentCount;
        info.SegmentNumber = i;
        full_info(9)=info.SegmentNumber;
        info.TimeStamp = tsdata(i);
        full_info(10)=info.TimeStamp;
        % added pan and tilt location from mount
        info.Pan=panloc;
        full_info(11)=info.Pan;
        info.Tilt=tiltloc;
        full_info(12)=info.Tilt;

%         year=str2num(datestr(now,'yyyy'));
%         month=str2num(datestr(now,'mm'));
%         day=str2num(datestr(now,'dd'));
%         hour=str2num(datestr(now,'HH'));
%         minute=str2num(datestr(now,'MM'));
%         second=str2num(datestr(now,'SS'));        
%         milisecond=str2num(datestr(now,'FFF'));

        year=str2num(datestamp(1:4));
        month=str2num(datestamp(5:6));
        day=str2num(datestamp(7:8));
        hour=str2num(datestamp(10:11));
        minute=str2num(datestamp(12:13));
        second=str2num(datestamp(14:15));
        full_info(13)=year;
        full_info(14)=month;
        full_info(15)=day;
        full_info(16)=hour;
        full_info(17)=minute;
        full_info(18)=second;
%         full_info(19)=milisecond;
        
        filename = sprintf(format_string, 'MulRec', transfer.Channel, i);
        full_data{1,i}=data';
        full_data{2,i}=full_info';

%         full_data{1:200,i}=data';
%         full_data{201:212,i}=full_info';
%         full_data{213,i}=year;
%         full_data{214,i}=month;
%         full_data{215,i}=day;
%         full_data{216,i}=hour;
%         full_data{217,i}=minute;
%         full_data{218,i}=second;
%         full_data{219,i}=milisecond;

        

%         CsMl_SaveFile_Tauc(filename, data, info);
    end;
end;
% tempgage='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\Temp Gage Storage';
% save(fullfile(tempgage,filename),'full_data')
% ret = CsMl_FreeSystem(handle);

