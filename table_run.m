function [result] = table_run(datapath,savepath,data_name)
pathsave = savepath; 
fsave = strcat(pathsave,data_name,'_result.csv');
gridsave = strcat(pathsave,data_name,'_grid','.csv');


errorsave = strcat(pathsave,data_name,'_errorsave','.csv');
dlmwrite(errorsave,zeros(1,7),'delimiter',',');  


data = load(cell2mat(datapath));  


[result,save_view]=search_admm(data,errorsave,data_name);

paraNames = {'a','b','c','rbf',...
        'acc','acc_std','gmean','gmean_std','fscore','fscore_std','auc','auc_std','recall','recall_std','spec','spec_std'};
s = save_view;
T_grid = table(s(:,1),s(:,2),s(:,3),s(:,4),s(:,5), s(:,6),s(:,7), ...
    s(:,8),s(:,9),s(:,10),s(:,11),s(:,12),s(:,13),s(:,14),s(:,15),s(:,16),'VariableNames',paraNames);
writetable(T_grid,gridsave);

