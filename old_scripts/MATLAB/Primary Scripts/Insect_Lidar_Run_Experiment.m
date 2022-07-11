%% Insect_Lidar_Run_Experiment
% Martin Tauc | 2016_02_18

clear all

QPT130_connect;
GAGE_CS14200_connect;
type='scan';
pause_time=0.12; %
wb=waitbar(0,'please wait...');

if strcmp('scan',type)
    tl=50;
    tld=tl;
    start_pan=-1000; %2000; % 100*degrees
    end_pan=1000; %2000;   % 100*degrees
    pan_s_e=[start_pan end_pan];
    delta_pan=50; % 100*degrees
    delta_tilt=10; % 100*degrees
    tilt_final=800; % 100*degrees
    nor=((-start_pan+end_pan)./delta_pan)*((-tld+tilt_final+1)./delta_tilt);
    q=0;
    n=0;
    nn=1;
    
    while tld<tilt_final;
        % move to absolute coordinate
        
        n=n+1;
        
        tic
        oc=0;
        
        
        check=false;
        out(1)=uint8(15);
        while check~=true || out(1)~=uint8(06);
            fwrite(QPT130,char(LRC_out([uint8(hex2dec('33')),QPT_int2hex(pan_s_e(nn)),QPT_int2hex(tl)])));
            %         fwrite(QPT130,char(LRC_out(['33,',QPT_int2hex(-4500),QPT_int2hex(tl)])));
            pause(pause_time)
            if QPT130.BytesAvailable > 0
                out=fread(QPT130,QPT130.BytesAvailable);
                check=LRC_in(out');
                oc=oc+1;
                raw_output{n,oc}=out';
                if check==true
                    output{n,oc}=Remove_ESC_Char(out');
                    pause(pause_time)
                end
            end
        end
        check=false;
        out(1)=uint8(15);
        while check~=true || out(1)~=uint8(06);
            fwrite(QPT130,jog);
            pause(pause_time)
            if QPT130.BytesAvailable > 0
                out=fread(QPT130,QPT130.BytesAvailable);
                check=LRC_in(out');
                oc=oc+1;
                raw_output{n,oc}=out';
                if check == true
                    output{n,oc}=Remove_ESC_Char(out');
                    pause(pause_time)
                end
            end
        end
        check=false;
        out(1)=uint8(15);
        k=1;
        while isequal(output{n,k},output{n,k+1})==0 || check~=true || out(1)~=uint8(06)
            fwrite(QPT130,jog);
            pause(pause_time)
            if QPT130.BytesAvailable > 0
                out=fread(QPT130,QPT130.BytesAvailable);
                check=LRC_in(out');
                raw_output{n,k+2}=out';
                if check==true;
                    k=k+1;
                    output{n,k+1}=Remove_ESC_Char(out');
                    pause(pause_time)
                end
            end
        end
        oc=k+1;
        cur_loc=output{n,oc};
        [pld,pli]=QPT_hex2int(cur_loc(3),cur_loc(4));
        [tld,tli]=QPT_hex2int(cur_loc(5),cur_loc(6));
        panloc=pld/100;
        tiltloc=tld/100;
        %     panloc=QPT_hex2int(cur_loc(3),cur_loc(4))./100;
        %     tiltloc=QPT_hex2int(cur_loc(5),cur_loc(6))/100;
        disp(['Pan location is ', sprintf('%4.2f',panloc), ' degrees'])
        disp(['Tilt location is ', sprintf('%4.2f',tiltloc),' degrees'])
        fdm=0;
        %     fdy=transfer.Segment;
        q=q+1;
        GageContinuousRecord_Tauc;
        tt=toc;
        nn=nn+(-1)^(n+1);
        %     [fdx,fdy]=size(full_data);
        
        
        %% Move QPT through entire sequence moving x degrees at a time
        %     while (-1)^(n+1)*panloc<(end_pan/100);
        while (-1)^(n+1)*pld<(-1)^(n+1)*pan_s_e(nn)
            fdm=fdm+1;
            tic
            check=false;
            out(1)=uint8(15);
            while check~=true || out(1)~=uint8(06);
                fwrite(QPT130,char(LRC_out([uint8(hex2dec('34')),QPT_int2hex((-1)^(n+1)*delta_pan),QPT_int2hex(0000)])));
                pause(pause_time)
                if QPT130.BytesAvailable > 0
                    out=fread(QPT130,QPT130.BytesAvailable);
                    check=LRC_in(out');
                    raw_output{n,oc+1}=out';
                    if check == true
                        output{n,oc+1}=Remove_ESC_Char(out');
                        oc=oc+1;
                        pause(pause_time)
                    end
                end
            end
            
            
            
            check=false;
            out(1)=uint8(15);
            %         m=size(output,2)-1;
            m=oc-1;
            while isequal(output{n,m},output{n,m+1})==0 || check~=true || out(1)~=uint8(06)
                fwrite(QPT130,jog);
                pause(pause_time)
                if QPT130.BytesAvailable > 0
                    out=fread(QPT130,QPT130.BytesAvailable);
                    check=LRC_in(out');
                    raw_output{n,m+2}=out';
                    if check==true;
                        m=m+1;
                        output{n,m+1}=Remove_ESC_Char(out');
                        pause(pause_time)
                    end
                end
            end
            oc=m+1;
            clear cur_loc panloc tiltloc
            cur_loc=output{n,oc};
            [pld,pli]=QPT_hex2int(cur_loc(3),cur_loc(4));
            [tld,tli]=QPT_hex2int(cur_loc(5),cur_loc(6));
            panloc=pld/100;
            tiltloc=tld/100;
            
            %         panloc=QPT_hex2int(cur_loc(3),cur_loc(4))/100;
            %         tiltloc=QPT_hex2int(cur_loc(5),cur_loc(6))/100;
            disp(['Pan location is ', sprintf('%4.2f',panloc), ' degrees'])
            disp(['Tilt location is ', sprintf('%4.2f',tiltloc),' degrees'])
            q=q+1;
            GageContinuousRecord_Tauc;
            %         [fdx,fdy]=size(full_data);
            tt=toc;
            waitbar(q/nor,wb,['estimated time remaining is ',sprintf('%4.1f',tt*(nor-q)/60),' minutes'])
            
        end
        tl=tl+delta_tilt;
        % %     last_row=(fdm+1)*acqInfo.SegmentCount;
        % %     full_data{(2*n)-1,last_row+1}=['Tilt location in degrees'];
        % %     full_data{2*n,last_row+1}=tiltloc;
        % %         full_data=1;
    end
else
    q=0;
    tic
    oc=0;
    res=20;
    xx=1:(res*2)+1;
    rr=2:-.5:.5;
    nor=length(xx)*length(rr);
    for r=rr
        pan_coor=r.*sin(xx*pi/res);
        tilt_coor=r.*cos(xx*pi/res);
        plot(pan_coor,tilt_coor)
        for x=xx;
            tic;
            q=q+1;
            check=false;
            out(1)=uint8(15);
            while check~=true || out(1)~=uint8(06);
                fwrite(QPT130,char(LRC_out([uint8(hex2dec('33')),QPT_int2hex(pan_coor(x)*100),QPT_int2hex(tilt_coor(x)*100)])));
                %         fwrite(QPT130,char(LRC_out(['33,',QPT_int2hex(-4500),QPT_int2hex(tl)])));
                pause(pause_time)
                if QPT130.BytesAvailable > 0
                    out=fread(QPT130,QPT130.BytesAvailable);
                    check=LRC_in(out');
                    oc=oc+1;
                    raw_output{n,oc}=out';
                    if check==true
                        output{n,oc}=Remove_ESC_Char(out');
                        pause(pause_time)
                    end
                end
            end
            check=false;
            out(1)=uint8(15);
            while check~=true || out(1)~=uint8(06);
                fwrite(QPT130,jog);
                pause(pause_time)
                if QPT130.BytesAvailable > 0
                    out=fread(QPT130,QPT130.BytesAvailable);
                    check=LRC_in(out');
                    oc=oc+1;
                    raw_output{n,oc}=out';
                    if check == true
                        output{n,oc}=Remove_ESC_Char(out');
                        pause(pause_time)
                    end
                end
            end
            check=false;
            out(1)=uint8(15);
            k=1;
            while isequal(output{n,k},output{n,k+1})==0 || check~=true || out(1)~=uint8(06)
                fwrite(QPT130,jog);
                pause(pause_time)
                if QPT130.BytesAvailable > 0
                    out=fread(QPT130,QPT130.BytesAvailable);
                    check=LRC_in(out');
                    raw_output{n,k+2}=out';
                    if check==true;
                        k=k+1;
                        output{n,k+1}=Remove_ESC_Char(out');
                        pause(pause_time)
                    end
                end
            end
            oc=k+1;
            cur_loc=output{n,oc};
            [pld,pli]=QPT_hex2int(cur_loc(3),cur_loc(4));
            [tld,tli]=QPT_hex2int(cur_loc(5),cur_loc(6));
            panloc=pld/100;
            tiltloc=tld/100;
            %     panloc=QPT_hex2int(cur_loc(3),cur_loc(4))./100;
            %     tiltloc=QPT_hex2int(cur_loc(5),cur_loc(6))/100;
            disp(['Pan location is ', sprintf('%4.2f',panloc), ' degrees'])
            disp(['Tilt location is ', sprintf('%4.2f',tiltloc),' degrees'])
            fdm=0;
            %     fdy=transfer.Segment;
            GageContinuousRecord_Tauc;
            tt=toc;
            waitbar(q/nor,wb,['estimaged wait time is ' sprintf('%4.1f',tt*(nor-q)/60) ' minutes'])
            
        end
    end
end
datestamp=datestr(now,30);
filename = sprintf(['Insect_Lidar_',datestamp, '.mat']);
tempgage='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\Stored Data\Temp Gage Storage';
save(fullfile(tempgage,filename),'insect_lidar')

ret = CsMl_FreeSystem(handle);
fclose(QPT130);
delete(QPT130);
delete(wb);
clear