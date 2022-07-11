%% Insect_Lidar_fix_cell_struct | Martin Tauc | 2017-02-01
function [adjusted_data,tcdata_es,range]=Insect_Lidar_fix_cell_struct(full_data,start_address,tsdata,old_data);
% old data is false unless the data is from before 2015 (typically)
if nargin<4
    old_data=false;
end

% start full_data at proper start_address
for n = 1:size(full_data,2)
    adjusted_data(1:length(full_data(:,n))+1+start_address(n),n) = ...
        full_data(-start_address(n):end,n);
end
% remove the final 10 range bins (start address vary between 3 and 13)
adjusted_data=adjusted_data(1:end-10,:);
% number of points
nop=size(adjusted_data,2);
% convert from microseconds to seconds
tcdata=(tsdata-tsdata(1))./1e6;
% create a uniform time vector
dt=diff(tcdata);
tcdata_es=mean(dt)*(0:nop-1);
% sinc interpolate for a uniform time spacing
for n = 1:size(adjusted_data,1)
    adjusted_data(n,:) = interpsinc(tcdata,double(adjusted_data(n,:)),mean(dt),1);
end
% remove the first 8 points (they correspond to negative range values)
adjusted_data=adjusted_data(8:end,:);
range=rangefind(8:size(adjusted_data,1)+7);
