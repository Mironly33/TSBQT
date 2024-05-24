clc;
clear;
path0='./data/';
namelist={
'syn.mat'
    };  %data name


save_path = './results/';           %results save path
result_path=strcat('./RESULT.csv');
resultarr=[];


for i =1:length(namelist)
    data_path=strcat(path0,namelist(i));       %data path
    
    string = cell2mat(namelist(i));
    data_name = string(1:end-4);

    
    [result] = table_run(data_path,save_path,data_name);
    resultarr=[resultarr;result];
    csvwrite(result_path,resultarr);
end







