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