
function [ret] = Setup(handle)
% Set the acquisition, channel and trigger parameters for the system and
% calls ConfigureAcquisition, ConfigureChannel and ConfigureTrigger.

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret, 1, handle);

everyxpulse=1;

acqInfo.SampleRate = 200e6;
acqInfo.ExtClock = 0;
acqInfo.Mode = CsMl_Translate('Single', 'Mode');
acqInfo.SegmentCount = 1e3;
acqInfo.Depth = 2e2;
acqInfo.SegmentSize = 2e2;
acqInfo.TriggerTimeout = 500000;
acqInfo.TriggerHoldoff = 200e6*(everyxpulse*125e-6);
acqInfo.TriggerDelay = 0;
acqInfo.TimeStampConfig = 0;

[ret] = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret, 1, handle);

% Set up all the channels even though
% they might not all be used. For example
% in a 2 board master / slave system, in single channel
% mode only channels 1 and 3 are used.
for i = 1:sysinfo.ChannelCount
    chan(i).Channel = i;
    chan(i).Coupling = CsMl_Translate('DC', 'Coupling');
    chan(i).DiffInput = 0;
    chan(i).InputRange = 2000;
    chan(i).Impedance = 50; %1e6
    chan(i).DcOffset = -500;
    chan(i).DirectAdc = 0;
    chan(i).Filter = 0; 
end;   

[ret] = CsMl_ConfigureChannel(handle, chan);
CsMl_ErrorHandler(ret, 1, handle);

trig.Trigger = 1;
trig.Slope = CsMl_Translate('Negative', 'Slope');
trig.Level = -30;
trig.Source = CsMl_Translate('External','Source');
trig.ExtCoupling = CsMl_Translate('DC', 'ExtCoupling');
trig.ExtRange = 2000;

[ret] = CsMl_ConfigureTrigger(handle, trig);
CsMl_ErrorHandler(ret, 1, handle);

ret = 1;
