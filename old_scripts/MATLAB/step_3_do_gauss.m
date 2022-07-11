function [np,pk_f_freq,gtmaxv,gtminv,loc]=step_3_do_gauss(wind,positive_data,lower_bound,upper_bound,fn,data,manual_insects,n,pks)
        g=gaussmf(1:length(positive_data),[(upper_bound-lower_bound)/2,mean([upper_bound lower_bound])]);
        np=g.*positive_data;
        gtmaxv=movmax(np,wind);
        gtminv=movmin(np,wind);
        
        sg=unique(sort(gtmaxv));
        fsg=sg(end-pks:end);
        int=0;
        for f=fsg
            int=int+1;
            loc(int)=find(np==f);
        end
        pk_f_freq=abs(1/mean(diff(data.(fn{:})(manual_insects(n).y).time(loc))));