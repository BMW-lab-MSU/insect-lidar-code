%FFTforGAGETests
for n=1:100
alldata=data(n,:);
SamplesPerSecond=200000000;
MaxFrequencyOfInterest=250;
SizeOfPoints=size(alldata);
NumberOfPoints=SizeOfPoints(2);
MaxTime=NumberOfPoints*5*(158e-6);
%MaxTime=NumberOfPoints/SamplesPerSecond;
Time=linspace(0,MaxTime,NumberOfPoints);
DeltaTime=MaxTime/NumberOfPoints;
MaxFrequency=1/DeltaTime;
DeltaFrequency=1/(MaxTime/NumberOfPoints);
Frequency=(-NumberOfPoints/2:NumberOfPoints/2-1).*DeltaFrequency./NumberOfPoints;
FourierOfData=fft(alldata);
ShiftedFourierOfData=fftshift(FourierOfData);
figure(1)
plot(Time,alldata)
figure(2)
plot(Frequency,abs(ShiftedFourierOfData)./NumberOfPoints,'Linewidth',2)
title(n)
ylim([0 .6])
xlim([-150 150])
pause()
end