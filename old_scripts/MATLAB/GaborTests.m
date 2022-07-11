% a=sym('a');
% [lim]=double(solve(exp(-pi*a^2)==.1,a));
sigma=0.0067;
x=pt;
G=(1/(sqrt(2*pi*sigma.^2))*exp(-(x-1).^1/(2*sigma^1)));
Gnorm=(G/max(G));
plot(pt,Gnorm,'b',pt,data,'.k')
for m=length(data)
    G(m,:) =(1/(sqrt(2*pi*sigma.^2))*exp(-(x-pt(m)).^1/(2*sigma^1)));
    Gnorm(m,:)=(G(m,:)/max(G(m,:)));
    GT(m,:)=Gnorm(m,:).*data;
end
