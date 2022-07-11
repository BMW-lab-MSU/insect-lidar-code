%FFTforGAGETests
%data=adjusted_data(4).run;
n=36;
m=3;
hold off
close all
%for n=20:60
Start=2.84e4;
End=2.854e4;
alldata=adjusted_data(m).run(n,Start:End);
%alldata=processed_data(1).bee_counts(n).data(Start:End);
%alldata=adjusted_data.run(n,:);
%hold on
%alldata=data(n,:);
%LaserPeriod=0.0001574044331; %in seconds
LaserPeriod=0.0001541; %in seconds
SamplesPerSecond=200000000;
Spacing=2;
NumberOfPoints=length(alldata);
MaxTime=NumberOfPoints*Spacing*LaserPeriod;
DeltaTime=MaxTime/NumberOfPoints;
MaxFrequency=1/DeltaTime;
DeltaFrequency=1/MaxTime;
Time=linspace(0,MaxTime,NumberOfPoints);
Points=linspace(Start,End,End-Start+1);
Range=0.7511.*Points-2.755;
Frequency=(-NumberOfPoints/2:NumberOfPoints/2-1).*DeltaFrequency;
FourierOfData=fft(alldata);
ShiftedFourierOfData=abs(fftshift(FourierOfData)./NumberOfPoints);
figure(1)
plot(Points,alldata)
%title('Range Bin 33 (at 22 m) With Single Bee Count')
title(n)
xlabel('Pulse Number')
ylabel('PMT Voltage Response (V)')
ylim([-0.15 0.01])
%xlim([30 32])
figure(2)
plot(Frequency,ShiftedFourierOfData,'Linewidth',2)
title('FFT of Single Bee Count')
xlabel('Frequency (Hz)')
ylabel('Signal Strength (Arbitrary)')
%ylim([0 10e-4])
xlim([-300 300])
%pause
%end
