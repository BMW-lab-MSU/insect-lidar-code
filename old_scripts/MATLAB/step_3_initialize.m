function [start_file,filename,fols,inz,inx,inc,inv,inb,n_start,manual_insects]=step_3_initialize(date)
set_plot_defaults
start_file='C:\Users\user\Documents\Research\Insect Lidar\Field Tests\';
% date='2016-06-08';
filename=fullfile(start_file,'Stored Data',date,'processed_data');
load(fullfile(filename,'events','manual_insects.mat'))
fols=dir(filename);
fols=fols(~ismember({fols.name},{'.','..','events'}));
inz=0;
inx=0;
inc=0;
inv=0;
inb=0;
n_start=input('value of n to start? ');