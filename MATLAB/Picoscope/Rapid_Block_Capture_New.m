%% Rapid Block Capture with new Programmer's Guide

%open oscilloscope 
%% LOAD CONFIGURATION INFORMATION

PS5000aConfig;

%% DEVICE CONNECTION

% Create a device object. 
%ps5000aDeviceObj = icdevice('picotech_ps5000a_generic.mdd');
ps5000aDeviceObj = icdevice('picotech_ps5000a_generic','');

% Connect device object to hardware.
connect(ps5000aDeviceObj);

%% SET CHANNELS

% Default driver settings used - use ps5000aSetChannel to turn channels on
% or off and set voltage ranges, coupling, as well as analogue offset.

invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 0, 1, 1, 8, 0.0); %Channel A  
invoke(ps5000aDeviceObj, 'ps5000aSetChannel', 1, 1, 1, 4, 0.0); %Channel B
%% SET DEVICE RESOLUTION

% resolution : 12bits

[status, resolution] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution', 12);

%% GET TIMEBASE

% Use ps5000aGetTimebase or ps5000aGetTimebase2 to query the driver as to 
% suitability of using a particular timebase index then set the 'timebase' 
% property if required.

% timebase      : 4 (16ns at 12-bit resolution)
% segment index : 0

[status, timeIntNs, maxSamples] = invoke(ps5000aDeviceObj, 'ps5000aGetTimebase', 2, 0);

% If status is ok, set the timebase property, otherwise query
% ps5000aGetTimebase with another timebase index. In the case above, the 
% status code 0 is returned (PICO_OK).

set(ps5000aDeviceObj, 'timebase', 2);

%% SET SIMPLE TRIGGER

% Channel     : 0 (PS5000A_CHANNEL_A)
% Threshold   : 500 (mV)
% Direction   : 2 (Rising)
% Delay       : 0
% Auto trigger: 0 (wait indefinitely)

[status] = invoke(ps5000aDeviceObj, 'setSimpleTrigger', 1, -50, 3, 0, 10000);

%% SET UP RAPID BLOCK PARAMETERS AND CAPTURE DATA

% Configure number of memory segments, ideally a power of 2, query
% ps5000aGetMaxSegments to find the maximum number of segments for the
% device.

[status, nMaxSamples] = invoke(ps5000aDeviceObj, 'ps5000aMemorySegments', 1024);

% Set number of captures - can be less than or equal to the number of
% segments.

[status] = invoke(ps5000aDeviceObj, 'ps5000aSetNoOfCaptures', 1024);

% Set number of samples to collect pre- and post-trigger. Ensure that the
% total does not exceeed nMaxSamples above.

set(ps5000aDeviceObj, 'numPreTriggerSamples', 16);
set(ps5000aDeviceObj, 'numPostTriggerSamples', 256);


% Capture a block of data:
%
% segment index: 0

[status, timeIndisposedMs] = invoke(ps5000aDeviceObj, 'runBlock', 0);

% Retrieve rapid block data values:
%
% numCaptures       : 8
% downsampling ratio: 1
% downsampling mode : 0 (PS5000A_RATIO_MODE_NONE)

[chA, chB, numSamples, overflow] = invoke(ps5000aDeviceObj, 'getRapidBlockData', 1024, 1, 0);

%trigger info
% typedef struct tPS5000ATriggerInfo
% {
% PICO_STATUS status;
% uint32_t segmentIndex;
% uint32_t triggerIndex;
% int64_t triggerTime;
% int16_t timeUnits;
% int16_t reserved0;
% uint64_t timeStampCounter;
% } 

%[picostatus, a,s,d,f,g,timestamp] = invoke(ps5000aTriggerInfo);

[timestamp] = invoke(ps5000aDeviceObj,'ps5000aGetTriggerInfoBulk'); 

% Stop the device
[status] = invoke(ps5000aDeviceObj, 'ps5000aStop');

%% PROCESS DATA

% Plot data values.

% Calculate time (nanoseconds) and convert to milliseconds
% Use timeIntervalNanoSeconds output from ps5000aGetTimebase or
% ps5000aGetTimebase2 or calculate from Programmer's Guide.

timeNs = double(timeIntNs) * double([0:numSamples - 1]);

% Channel A
figure;
plot(timeNs, chA);
title('Channel A - Rapid Block Capture');
xlabel('Time (ns)');
ylabel('Voltage (mV)');

%% Disconnect device
% Disconnect device object from hardware.

disconnect(ps5000aDeviceObj);
delete(ps5000aDeviceObj);

