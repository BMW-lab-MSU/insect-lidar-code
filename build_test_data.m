%  Build test data

fols=dir(fullfile(pwd));
fols=fols(~ismember({fols.name},{'.','..','events'}));

load('I:\Data_Test\2016-06-08\processed_data\events\manual_final_insect');
insects = manual_final_insect.very_likely;


for m = 1:length(insects)
    filefol = insects(m).x;
    itnum = insects(m).y;
    rangenum = insects(m).z;
    data = load(fullfile(pwd,fols(filefol).name)); 
    fn=fieldnames(data);
    indata = data.(fn{1})(itnum).normalized_data(rangenum,:);
    nonorm_indata = data.(fn{1})(itnum).data(rangenum,:);
    testdata(m).normalized_data = indata;
    testdata(m).data = nonorm_indata;
    testdata(m).time = data.(fn{1})(itnum).time;
    testdata(m).picdata = data.(fn{1})(itnum).data;
    testdata(m).picnormdata = data.(fn{1})(itnum).normalized_data;
    save('testdata');
end
%save('testdata');

% for xx=1:size(fols,1)
%     clear data fn
%     
%     % load vector
%     data=load(fullfile(pwd,fols(xx).name));
%     % determine filenames
%     fn=fieldnames(data);
%     for y=1:size(data.(fn{1}),2)
