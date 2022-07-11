clear
close all
ylx=1500;%325;%500;%1000;%1575;%2050;
ns=1;
sbpb=0;
sv=2;
for nfvv=[2 4 6]
    sbpb=sbpb+1;
    sbpa=-1;
    for user_def=2:2:10
        sbpa=sbpa+1;
        nfv=0;%(nfvv/10);
        pkv=0;%(nfvv/10);
        tnl=-2;%-4;
        tnh=2;%4;
        snl=-1;%-1;
        snh=nfvv;%4;
        noise=rand(1,1024)*nfv;
        %     noise_string='nnftnsn';
        noise_string='full_page_figs\gauss_tj_sj';
        set_plot_defaults
        %     close all
        % user_def=3;
        od=fullfile('C:\Users\user\OneDrive\Documents\Martin\Research\Thesis Paper\Drafts\figures\sim_figs',noise_string);
        ld=fullfile('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Figures\Thesis Figures\sim_figs',noise_string);
        time=linspace(0,.25,1024);
        nvec=(0:1023);
        peaks=zeros(size(nvec));
        indx_spc=20;
        indx_mul=[];
        %     peaks=zeros(size(time));
        %     indx_spc=find(time<=(1/200),1,'last');
        %     indx_mul=[];
        for n=1:user_def
            indx_mul=[indx_mul (n*indx_spc)+randi([tnl tnh],1)];
            sp=gaussmf(nvec,[sv+randi([snl snh],1),indx_mul(n)+200]);
            peaks=peaks+sp;
        end
        for n=1:size(nvec,2)
            if peaks(n)<=0.1
                peaks(n)=peaks(n)+noise(n);
            else
                            peaks(n)=peaks(n)-rand(1)*pkv;
            end
        end
        % indx_mul=indx_mul+200;
        % sp=gaussmf(time,[time(3),time(indx_mul(1)+200)]);
        % peaks=peaks+sp;
        sig=sprintf('%i',sv);
        %     figure('outerposition',[1923 233 576 513])
        figure(1);
        %     peaks=peaks/(max(peaks));
        subplot(5,3,sbpb+(sbpa*3))
        plot(nvec,peaks,'b');
        grid off
        t=sprintf('signal with %i peaks spaced by %i s}',user_def, indx_spc);
        r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);
        s=sprintf('simulated with gaussian peaks, %s = %s s}','$$\sigma$$',sig);
        ti=['\makebox[4in][c]{',t];
        th=['\makebox[4in][c]{',r];
        tj=['\makebox[4in][c]{',s];
        xticks([])
        yticks([])
        xlim([0 1023])
        ylim([0 1.1])
        grid on
        %     xlabel('time (s)')
        %     ylabel('return signal (arb)')
        % set(gcf,'outerposition',[1923 233 576 513])
        % set(gcf,'outerposition',[1923+576 233 576 513])
        if (sbpb+(sbpa*3))==1 || (sbpb+(sbpa*3))==2 || (sbpb+(sbpa*3))==3
            iftitle=sprintf('%s noise=-1 to %i s','$$\sigma$$',nfvv);
            title({'\makebox[0in][c]{',iftitle,'}'},'interpreter','latex')
        end
        
        
        if (sbpb+(sbpa*3))==1 || (sbpb+(sbpa*3))==4 || (sbpb+(sbpa*3))==7 || (sbpb+(sbpa*3))==10 || (sbpb+(sbpa*3))==13
            %     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
            %         ri,ti},'interpreter','latex')
            ylabel('signal')
            yticks([0 1/4 1/2 3/4 1])
            yticklabels({num2str(0),'','1/2','',num2str(1)})
        else
            yticks([0 1/4 1/2 3/4 1])
            yticklabels({'','','','',''})
        end
        if (sbpb+(sbpa*3))==3 || (sbpb+(sbpa*3))==6 || (sbpb+(sbpa*3))==9 || (sbpb+(sbpa*3))==12 || (sbpb+(sbpa*3))==15
            ifylab=(sprintf('%i peaks',user_def));
            set(gca,'Yaxislocation','right')
            ylab=ylabel(ifylab);
            set(get(gca,'ylabel'),'rotation',0);
            set(ylab,'pos',[1145 3/4 0])
        end
        if (sbpb+(sbpa*3))==15 || (sbpb+(sbpa*3))==14 || (sbpb+(sbpa*3))==13
            %     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
            %         ri,ti},'interpreter','latex')
            xlabel('time (s)')
            %             xticks([0.05 .1 .15 .2 .25 .3 .35 .4 .45 .5])
            %             xticklabels({'','0.1','','0.2','','0.3','','0.4','','0.5'})
        else
            %             xticks([0.05 .1 .15 .2 .25 .3 .35 .4 .45 .5])
            %             xticklabels({'','','','','','','','','',''})
        end
        

        %%
        nop=size(peaks,2);
        %     delta_t=mean(diff(time));
        delta_t=1;
        max_freq=1./(2*delta_t);
        %     delta_f=1/time(end);
        delta_f=1/1024;
        fqdata=(-nop/2:nop/2-1).*delta_f;
        freq_data=fftshift(fft(peaks,nop,2),2);
        
        %         figure('outerposition',[1923+563 233 576 513])
        figure(2);
        
        subplot(5,3,sbpb+(sbpa*3))
        plot(fqdata,abs(freq_data).^2,'b');
        xlim([0,max_freq])
        ylim([0,ylx])
        grid on
        t=sprintf('with %i peaks spaced by %i s}',user_def, indx_spc);
        r=sprintf('nf=[0 %2.0f], pn=[0 %2.0f], tn=[%i %i] s, sn=[%i %i] s}',nfv*100,pkv*100,tnl,tnh,snl,snh);
        %
        %         ti=['\makebox[4in][c]{',t];
        %         ri=['\makebox[4in][c]{',r];
        
        if (sbpb+(sbpa*3))==1 || (sbpb+(sbpa*3))==2 || (sbpb+(sbpa*3))==3
            iftitle=sprintf('%s noise=-1 to %i s','$$\sigma$$',nfvv);
            title({'\makebox[0in][c]{',iftitle,'}'},'interpreter','latex')
        end
        
        
        if (sbpb+(sbpa*3))==1 || (sbpb+(sbpa*3))==4 || (sbpb+(sbpa*3))==7 || (sbpb+(sbpa*3))==10 || (sbpb+(sbpa*3))==13
            %     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
            %         ri,ti},'interpreter','latex')
            ylabel('power')
            yticks([0 ylx/4 ylx/2 3*ylx/4 ylx])
            yticklabels({num2str(0),'',num2str(ylx/2),'',num2str(ylx)})
        else
            yticks([0 ylx/4 ylx/2 3*ylx/4 ylx])
            yticklabels({'','','','',''})
        end
        if (sbpb+(sbpa*3))==3 || (sbpb+(sbpa*3))==6 || (sbpb+(sbpa*3))==9 || (sbpb+(sbpa*3))==12 || (sbpb+(sbpa*3))==15
            ifylab=(sprintf('%i peaks',user_def));
            set(gca,'Yaxislocation','right')
            ylab=ylabel(ifylab);
            set(get(gca,'ylabel'),'rotation',0);
            set(ylab,'pos',[.6 ylx*(3/4) 0])
        end
        if (sbpb+(sbpa*3))==15 || (sbpb+(sbpa*3))==14 || (sbpb+(sbpa*3))==13
            %     title({'\makebox[4in][c]{FFT algorithm performed on signal}',...
            %         ri,ti},'interpreter','latex')
            xlabel('frequency (Hz)')
            xticks([0.05 .1 .15 .2 .25 .3 .35 .4 .45 .5])
            xticklabels({'','0.1','','0.2','','0.3','','0.4','','0.5'})
        else
            xticks([0.05 .1 .15 .2 .25 .3 .35 .4 .45 .5])
            xticklabels({'','','','','','','','','',''})
        end
        %     yticks([])
        
        %     xlabel('frequency (Hz)')
        %     ylabel('power')
        
        %     pause(1)
    end
end
figure(1);
set(gcf,'outerposition',[-7 33 1696 1026])

sig(sig=='.')='_';
ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
savefig(fullfile(od,[ft, '.fig']));
saveas(gcf,fullfile(od,[ft,'.png']));
savefig(fullfile(ld,[ft, '.fig']));
saveas(gcf,fullfile(ld,[ft,'.png']));
figure(2)
set(gcf,'outerposition',[-7 33 1696 1026])
ft=sprintf('pk%i_sg%s_nfv%02.0f_pkv%02.0f_tnl%i_tnh%i_snl%i_snh%i_fft',user_def,sig,nfv*100,pkv*100,tnl,tnh,snl,snh);
savefig(fullfile(od,[ft, '.fig']));
saveas(gcf,fullfile(od,[ft,'.png']));
savefig(fullfile(ld,[ft, '.fig']));
saveas(gcf,fullfile(ld,[ft,'.png']));
close all