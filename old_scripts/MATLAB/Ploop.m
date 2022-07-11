[py,px]=findpeaks(-data,'MinPeakDistance',2e4);
l=size(px);
for n=1:l(2)-1
    P(n)=px(n+1)-px(n);
end
disp(0.0001574079365)