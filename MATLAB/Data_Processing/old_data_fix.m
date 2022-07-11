
function [full_data] = old_data_fix(rd)

 for n = 1:size(rd.full_data,2)
     
        full_data.data = rd.full_data;
        full_data.info.Start(n) = rd.start_address(n);
        full_data.info.TimeStamp(n)= rd.tsdata(n);
        full_data.info.Pan=rd.panloc;
        full_data.info.Tilt=rd.tiltloc;
%         full_data.info.Date= datetime(year,month,day,hour,minute,second,'TimeZone','America/Denver');
%         full_data.info.Date.TimeZone = 'UTC';
%         
%         full_data.info.Units.TimeZone = 'UTC';
%         full_data.info.Units.Input_Range = 'volts';
%         full_data.info.Units.DC_Offset = 'milivolts';
%         full_data.info.Units.TimeStamp = 'microseconds';
%         full_data.info.Units.Pan = 'degrees';
%         full_data.info.Units.Tilt = 'degrees';
%         full_data.info.Units.Date = 'year-month-day,hour-minute-second';
%         
 end
 
end