
%This is for 29.9m test done on 4th floor Cobleigh
disp('Place Cover on Telesope then press "Enter"')
pause
GageMultipleRecord_Tauc;
ADC_TESTS_CollectData;
pedestal=mean(data,2);
[valuep,indp]=max(abs(pedestal));
save('pedestal','pedestal','indp');
disp('Remove Cover and Shoot to wall')
pause
GageMultipleRecord_Tauc;
ADC_TESTS_CollectData;
pedestal=load('pedestal');
mcal=mean(data,2);

samples=linspace(0,depth-pedestal.indp-1,depth-pedestal.indp);
range=samples.*.75;

mpcal=mcal-pedestal.pedestal;

plot(range,mpcal(1:(depth-pedestal.indp)))

