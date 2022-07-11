%% Insect_Lidar_GAGE_CS14200_connect | Martin Tauc | 2017-01-30
% connect with the ADC card
% the following commands are borrowed from the SDK
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);
[ret, sysinfo] = CsMl_GetSystemInfo(handle);
s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);
Setup(handle);
CsMl_ResetTimeStamp(handle);
ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);