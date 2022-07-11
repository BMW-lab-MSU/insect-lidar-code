for m = 23:3:50
    for n=91:1:95
        clearvars -except m n
        close all
        clc
        Insect_Lidar_Event_Search('2016-06-07',n,m);
    end
end