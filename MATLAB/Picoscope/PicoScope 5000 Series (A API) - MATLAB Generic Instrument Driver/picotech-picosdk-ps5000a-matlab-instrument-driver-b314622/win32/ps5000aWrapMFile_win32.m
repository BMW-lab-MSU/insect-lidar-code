function [methodinfo,structs,enuminfo,ThunkLibName]=ps5000aWrapMFile_win32
%PS5000AWRAPMFILE_WIN32 Create structures to define interfaces found in 'ps5000aWrap'.

%This function was generated by loadlibrary.m parser version  on Wed Aug 22 15:49:02 2018
%perl options:'ps5000aWrap.i -outfile=ps5000aWrapMFile_win32.m'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival);
ThunkLibName=[];
% extern PICO_STATUS _stdcall RunBlock ( int16_t handle , int32_t preTriggerSamples , int32_t postTriggerSamples , uint32_t timebase , uint32_t segmentIndex ); 
fcns.name{fcnNum}='RunBlock'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32', 'int32', 'uint32', 'uint32'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall GetStreamingLatestValues ( int16_t handle ); 
fcns.name{fcnNum}='GetStreamingLatestValues'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% extern uint32_t _stdcall AvailableData ( int16_t handle , uint32_t * startIndex ); 
fcns.name{fcnNum}='AvailableData'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% extern int16_t _stdcall AutoStopped ( int16_t handle ); 
fcns.name{fcnNum}='AutoStopped'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int16'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% extern int16_t _stdcall IsReady ( int16_t handle ); 
fcns.name{fcnNum}='IsReady'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int16'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% extern int16_t _stdcall IsTriggerReady ( int16_t handle , uint32_t * triggeredAt ); 
fcns.name{fcnNum}='IsTriggerReady'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='int16'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall ClearTriggerReady ( int16_t handle ); 
fcns.name{fcnNum}='ClearTriggerReady'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerConditions ( int16_t handle , int32_t * conditionsArray , int16_t nConditions ); 
fcns.name{fcnNum}='SetTriggerConditions'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerProperties ( int16_t handle , int32_t * propertiesArray , int16_t nProperties , int32_t autoTrig ); 
fcns.name{fcnNum}='SetTriggerProperties'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16', 'int32'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetPulseWidthQualifier ( int16_t handle , int32_t * pwqConditionsArray , int16_t nConditions , int32_t direction , uint32_t lower , uint32_t upper , int32_t type ); 
fcns.name{fcnNum}='SetPulseWidthQualifier'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16', 'int32', 'uint32', 'uint32', 'int32'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall setChannelCount ( int16_t handle , int16_t channelCount ); 
fcns.name{fcnNum}='setChannelCount'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall setEnabledChannels ( int16_t handle , int16_t * enabledChannels ); 
fcns.name{fcnNum}='setEnabledChannels'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall setAppAndDriverBuffers ( int16_t handle , PS5000A_CHANNEL channel , int16_t * appBuffer , int16_t * driverBuffer , uint32_t bufferLength ); 
fcns.name{fcnNum}='setAppAndDriverBuffers'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS5000AChannel', 'int16Ptr', 'int16Ptr', 'uint32'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall setMaxMinAppAndDriverBuffers ( int16_t handle , PS5000A_CHANNEL channel , int16_t * appMaxBuffer , int16_t * appMinBuffer , int16_t * driverMaxBuffer , int16_t * driverMinBuffer , uint32_t bufferLength ); 
fcns.name{fcnNum}='setMaxMinAppAndDriverBuffers'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS5000AChannel', 'int16Ptr', 'int16Ptr', 'int16Ptr', 'int16Ptr', 'uint32'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall setEnabledDigitalPorts ( int16_t handle , int16_t * enabledDigitalPorts ); 
fcns.name{fcnNum}='setEnabledDigitalPorts'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall getOverflow ( int16_t handle , int16_t * overflow ); 
fcns.name{fcnNum}='getOverflow'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerConditionsV2 ( int16_t handle , int32_t * conditionsArray , int16_t nConditions , PS5000A_CONDITIONS_INFO info ); 
fcns.name{fcnNum}='SetTriggerConditionsV2'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16', 'enPS5000AConditionsInfo'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerDirectionsV2 ( int16_t handle , int32_t * directions , int16_t nDirections ); 
fcns.name{fcnNum}='SetTriggerDirectionsV2'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerPropertiesV2 ( int16_t handle , int32_t * propertiesArray , int16_t nProperties ); 
fcns.name{fcnNum}='SetTriggerPropertiesV2'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetTriggerDigitalPortProperties ( int16_t handle , int32_t * digitalDirections , int16_t nDirections ); 
fcns.name{fcnNum}='SetTriggerDigitalPortProperties'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetPulseWidthQualifierConditions ( int16_t handle , int32_t * pwqConditionsArray , int16_t nConditions , PS5000A_CONDITIONS_INFO info ); 
fcns.name{fcnNum}='SetPulseWidthQualifierConditions'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16', 'enPS5000AConditionsInfo'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetPulseWidthQualifierDirections ( int16_t handle , int32_t * pwqDirectionsArray , int16_t nDirections ); 
fcns.name{fcnNum}='SetPulseWidthQualifierDirections'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
% extern PICO_STATUS _stdcall SetPulseWidthDigitalPortProperties ( int16_t handle , int32_t * pwqDigitalDirections , int16_t nDirections ); 
fcns.name{fcnNum}='SetPulseWidthDigitalPortProperties'; fcns.calltype{fcnNum}='stdcall'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32Ptr', 'int16'};fcnNum=fcnNum+1;
structs.tWrapBufferInfo.members=struct('driverBuffers', 'int16PtrPtr', 'appBuffers', 'int16PtrPtr', 'bufferLengths', 'uint32#4', 'driverDigiBuffers', 'int16PtrPtr', 'appDigiBuffers', 'int16PtrPtr', 'digiBufferLengths', 'uint32#4');
enuminfo.enPS5000AConditionsInfo=struct('PS5000A_CLEAR',1,'PS5000A_ADD',2);
enuminfo.enPS5000AWrapDigitalPortIndex=struct('PS5000A_WRAP_DIGITAL_PORT0',0,'PS5000A_WRAP_DIGITAL_PORT1',1);
enuminfo.enPS5000AChannel=struct('PS5000A_CHANNEL_A',0,'PS5000A_CHANNEL_B',1,'PS5000A_CHANNEL_C',2,'PS5000A_CHANNEL_D',3,'PS5000A_EXTERNAL',4,'PS5000A_MAX_CHANNELS',4,'PS5000A_TRIGGER_AUX',5,'PS5000A_MAX_TRIGGER_SOURCES',6,'PS5000A_DIGITAL_PORT0',128,'PS5000A_DIGITAL_PORT1',129,'PS5000A_DIGITAL_PORT2',130,'PS5000A_DIGITAL_PORT3',131,'PS5000A_PULSE_WIDTH_SOURCE',268435456);
methodinfo=fcns;