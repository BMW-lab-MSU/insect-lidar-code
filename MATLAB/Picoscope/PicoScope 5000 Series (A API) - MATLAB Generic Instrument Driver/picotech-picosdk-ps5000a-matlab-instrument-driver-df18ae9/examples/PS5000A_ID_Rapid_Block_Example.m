%% PicoScope 5000 Series Instrument Driver Oscilloscope Rapid Block Data Capture Example
%  
%   This is a modified version of the machine generated representation of 
%   an instrument control session using a device object. The instrument 
%   control session comprises  all the steps you are likely to take when 
%   communicating with your instrument. These steps are:
%       
%       1. Create a device object   
%       2. Connect to the instrument 
%       3. Configure properties 
%       4. Invoke functions 
%       5. Disconnect from the instrument 
%  
%   To run the instrument control session, type the name of the file,
%   PS5000A_ID_Rapid_Block_Example, at the MATLAB command prompt.
% 
%   The file, PS5000A_ID_RAPID_BLOCK_EXAMPLE.M must be on your MATLAB PATH. For additional information
%   on setting your MATLAB PATH, type 'help addpath' at the MATLAB command
%   prompt.
%
%   Example:
%       PS5000A_ID_Rapid_Block_Example;
%
%   Description:
%   Demonstrates how to call functions in order to capture rapid block
%   data from a PicoScope 5000 series oscilloscope.
%
%   See also ICDEVICE.
%
%   Copyright: (c) 2013 - 2017 Pico Technology Ltd. See LICENSE file for terms.
%
%   Author: HSM
%
%   Device used to generated example: PicoScope 5242A

%   Creation time: 12-Jul-2013 09:44:48 

%% LOAD CONFIGURATION INFORMATION

PS5000aConfig;

%% DEVICE CONNECTION

% Create a device object. 
ps5000aDeviceObj = icdevice('picotech_ps5000a_generic.mdd');

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

[chA, chB, chC, chD, numSamples, overflow] = invoke(ps5000aDeviceObj, 'getRapidBlockData', 1024, 1, 0);

%Trigger info
[status, segmentindex, timestamp] = invoke(ps5000aDeviceObj, 'ps5000aGetTriggerInfoBulk', 0, 5);

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

% Channel B
figure;
plot(timeNs, chB);
title('Channel B - Rapid Block Capture');
xlabel('Time (ns)');
ylabel('Voltage (mV)')

%% DEVICE DISCONNECTION

%Disconnect device object from hardware.
disconnect(ps5000aDeviceObj);

