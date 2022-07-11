nc=0;
for n=2:2:length(VarName1)
    nc=nc+1;
    if isnan(VarName3(n))
        pop(nc)=str2num(sprintf('%.0f%03.0f',VarName1(n),VarName2(n)));
    else
        pop(nc)=str2num(sprintf('%.0f%03.0f%03.0f',VarName1(n),VarName2(n),VarName3(n)));
    end
end
