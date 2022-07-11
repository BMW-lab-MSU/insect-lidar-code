function [positive_data,fn,data]=step_3_load_data(filename,fols,n,manual_insects)
    data=load(fullfile(filename,fols(manual_insects(n).x).name));
    fn=fieldnames(data);
    positive_data=abs(data.(fn{:})(manual_insects(n).y).normalized_data(manual_insects(n).z,:)...
        -max(data.(fn{:})(manual_insects(n).y).normalized_data(manual_insects(n).z,:)));