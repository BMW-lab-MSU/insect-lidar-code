slide_length=2^4;
slide_indx=1:slide_length:length(statistics.insect(1).data);

int=0;
for n=slide_indx;
    int=int+1;
    temp_min(int)=min(statistics.insect(1).data(1,n:n+slide_length-1));
    temp_max(int)=max(statistics.insect(1).data(1,n:n+slide_length-1));
end
for n=1:size(slide_indx,2)
    slide_min(1,slide_indx(n):slide_indx(n)+slide_length-1)=repmat(temp_min(n),[1,slide_length]);
    slide_max(1,slide_indx(n):slide_indx(n)+slide_length-1)=repmat(temp_max(n),[1,slide_length]);
end
plot(statistics.insect(1).time,statistics.insect(1).data,'b',statistics.insect(1).time,slide_min,'r--',statistics.insect(1).time,slide_max,'m--')
