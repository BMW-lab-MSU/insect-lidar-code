%WAVETEST Example Matlab script for WAVELET, using NINO3 SST dataset
%
% See "http://paos.colorado.edu/research/wavelets/"
% Written January 1998 by C. Torrence
%
% Modified Oct 1999, changed Global Wavelet Spectrum (GWS) to be sideways,
%   changed all "log" to "log2", changed logarithmic axis on GWS to
%   a normal axis.

% load 'sst_nino3.dat'   % input SST time series
% load(fullfile('C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\Temp Gage Storage','Insect_Lidar_20160604T195146.mat'));
% fix_cell_struct;
% t_vec='20160604T195146';
clear all
full_dir='C:\Users\mjtau\Documents\Research\Insect Lidar\Field Tests\Stored Data\2016-06-05';
d=dir(full_dir);
% testx1=[84 125 127 128 130 136 139 145 164 181 218 242 244];
% testx1=[145];
for p=3:length(d)
% for p=3;
    file_dir=[full_dir,'\',d(p).name];
    
    current_files=dir(file_dir);
    
    % for x1=1:length(insect_lidar)%17;
    % x1l=[91 93 117 139 140 144 145 159 194 199 203 225 232 234 235 236 255 260 ...
    %     265 266 267 282 296 303 337 359 387 401 402 409 417 444 447 462 476 ...
    %     506 528 583 605 619 667 684 691 704 709 714 777 816 822 840]
    % % x1l=91;
    % x2l=71;
    
    x1l=3:length(current_files);
    x3=1;
    clear processed_data
        for x1=x1l;
%     for x1=testx1;
        load(fullfile(file_dir,current_files(x1).name));
        fix_cell_struct;
        x2l=1:size(adjusted_data,1);

        tic
        for x2=x2l;
            
            
            sst = adjusted_data(x2,:);
            %------------------------------------------------------ Computation
            
            % normalize by standard deviation (not necessary, but makes it easier
            % to compare with plot on Interactive Wavelet page, at
            % "http://paos.colorado.edu/research/wavelets/plot/"
            variance = std(sst)^2;
            sst = (sst - mean(sst))/sqrt(variance) ;
            
            
            %         time = (insect_lidar(x1).time_stamp-insect_lidar(x1).time_stamp(1))./1e6;
%             time=(tsdata-tsdata(1))/1e6;
            time=tcdata_es;
            dt = mean(diff(time));
            n = length(sst);
            % dt = time_end/length(sst) ;
            % time = [0:length(sst)-1]*dt + 1871.0 ;  % construct time array
            xlim = [0,max(time)];  % plotting range
            pad = 1;      % pad the time series with zeroes (recommended)
            dj = .05; %0.25;    % this will do 4 sub-octaves per octave
            s0 = 14*dt;    % this says start at a scale of 6 months
            j1 = 6/dj;    % this says do 7 powers-of-two with dj sub-octaves each
            lag1=0; % lag1 = 0.72;  % lag-1 autocorrelation for red noise background
            mother = 'Morlet';
            
            % Wavelet transform:
            [wave,period,scale,coi] = wavelet(sst,dt,pad,dj,s0,j1,mother);
            power = (abs(wave)).^2 ;        % compute wavelet power spectrum
            
            % Significance levels: (variance=1 for the normalized SST)
            [signif,fft_theor] = wave_signif(variance,dt,scale,0,lag1,-1,-1,mother);
            sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
            sig95 = power ./ sig95;         % where ratio > 1, power is significant
            
            % Global wavelet spectrum & significance levels:
            %             global_ws = variance*(sum(power')/n);   % time-average over all times
            %             dof = n - scale;  % the -scale corrects for padding at edges
            %             global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);
            
            % % Scale-average between El Nino periods of 2--8 years
            
            % avg = find((scale >= 2) & (scale < 8));
            % Cdelta = 0.776;   % this is for the MORLET wavelet
            % scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
            % scale_avg = power ./ scale_avg;   % [Eqn(24)]
            % scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
            % scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,-1,[2,7.9],mother);
            
            %         whos;
            
            %         %------------------------------------------------------ Plotting
%                     close all
%                     %--- Plot time series
%                     subplot('position',[0.1 0.75 0.65 0.2])
%                     plot(time,sst)
%                     set(gca,'XLim',xlim(:))
%                     set(gca,'YLim',[-50 50])
%                     xlabel('Time (\mus)')
%                     ylabel('detected signal (arb)')
%                     title([sprintf('%i',x1),'-',sprintf('%i',       x2)])
%                     hold off
%             
%                     %--- Contour plot wavelet power spectrum
%                     subplot('position',[0.1 0.37 0.65 0.28])
%                     levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
%                     Yticks = 2.^(log2(fix(1./max(period))):log2(fix(1./min(period))));
%                     contour(time,log2(1./period),log2(power),log2(levels))%,log2(levels));  %*** or use 'contourfill'
%                     colorbar
%                     % imagesc(time,log2(period),log2(power));  %*** uncomment for 'image' plot
%                     xlabel('Time (\mus)')
%                     ylabel('Period')
%                     % title('b) NINO3 SST Wavelet Power Spectrum')
%                     set(gca,'XLim',xlim(:))
%                     set(gca,'YLim',log2(1./([max(period),min(period)])), ...
%                         'YDir','normal', ...
%                         'YTick',log2(Yticks(:)), ...
%                         'YTickLabel',Yticks)
%                     % 95% significance contour, levels at -99 (fake) and 1 (95% signif)
%                     hold on
%                     contour(time,log2(period),sig95,[-99,1],'k');
%                     hold on
%                     % cone-of-influence, anything "below" is dubious
%                     plot(time,(coi),'k')
%                     hold off
%             
%                     %--- Plot global wavelet spectrum
%                     subplot('position',[0.77 0.37 0.2 0.28])
%                     plot(global_ws,log2(period))
%                     hold on
%                     plot(global_signif,log2(period),'--')
%                     hold off
%                     % xlabel('Power (degC^2)')
%                     % title('c) Global Wavelet Spectrum')
%                     % set(gca,'YLim',log2([max(1./period),min(1./period)]), ...
%                     % 	'YDir','reverse', ...
%                     % 	'YTick',log2(Yticks(:)), ...
%                     % 	'YTickLabel','')
%                     % set(gca,'XLim',[0,1.25*max(global_ws)])
            %
            %         % %--- Plot 2--8 yr scale-average time series
            %         % subplot('position',[0.1 0.07 0.65 0.2])
            %         % plot(time,scale_avg)
            %         % set(gca,'XLim',xlim(:))
            %         % xlabel('Time (year)')
            %         % ylabel('Avg variance (degC^2)')
            %         % title('d) 2-8 yr Scale-average Time Series')
            %         % hold on
            %         % plot(xlim,scaleavg_signif+[0,0],'--')
            %         % hold off
            %
            %         % end of code
            [r,c,v]=find(log2(power)>4);
            clear freq pan tilt range
            %         disp([x1 x2 x3])
            if ~isempty(r) && 1/period(max(unique(r)))>50;
                freq=1./period(unique(r));
                %             pan=insect_lidar(x1).pan_location;
                %             tilt=insect_lidar(x1).tilt_location;
                pan=panloc;
                tilt=tiltloc;
                range=rangefind(x2);
                processed_data(x3).frequency=freq;
                processed_data(x3).pan_location=pan;
                processed_data(x3).tilt_location=tilt;
                processed_data(x3).range=range;
                processed_data(x3).data=adjusted_data(x2,:);
                processed_data(x3).data_2d=adjusted_data;
                processed_data(x3).time=time;
                processed_data(x3).period=period;
                processed_data(x3).power=power;
                processed_data(x3).index=[x1 x2 x3];
                processed_data(x3).filename=current_files(x1).name;
                x3=x3+1;
                disp('processed')
            end
        end
        
        disp([p x1 x2 x3])
        toc
    end
    if exist('processed_data','var')
        save(fullfile(file_dir,'processed_data'),'processed_data')
    else
        disp('no insects found');
    end
end
% fulldir='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data';
% if exist(fullfile(file_dir,t_vec),'dir')==7;
%     save(fullfile(strcat(file_dir,'\',t_vec),'processed_data'),'processed_data')
% else
%     mkdir(fullfile(file_dir),t_vec);
%     save(fullfile(strcat(fulldir,'\',t_vec),'processed_data'),'processed_data')
% end
