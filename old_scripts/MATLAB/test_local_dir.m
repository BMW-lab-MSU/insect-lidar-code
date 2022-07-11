disp('testing_local_dir')

copyfile('/mnt/lustrefs/store/martin.tauc/MS_Research/Insect_Lidar/stored_data/2016-06-07/AMK_Ranch-094810','/local/AMK_Ranch-094810')
disp('file was copied.')

load('/local/AMK_Ranch-094810/00001_P3900T0153.mat');

save('/mnt/lustrefs/store/martin.tauc/MS_Research/Insect_Lidar/stored_data/2016-06-07/AMK_Ranch-094810/start_address_test.mat','start_address');