home_dir = 'D:\Data-Test\2016-06-08\processed_data';

files = dir(fullfile(home_dir,'*.mat'));
n=1;
temp = load(fullfile(home_dir,files(manual_final_insect.very_likely(n).x).name));
fn = fieldnames(temp);
plot(temp.(fn{1})(manual_final_insect.very_likely(n).y).normalized_data(manual_final_insect.very_likely(n).z,:))