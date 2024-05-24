function [acc,gmean,fscore,auc_arr,recall,spec,func]=predict(modela,test_x1,test_y,rbf)
[n,~] = size(test_x1);
test_x1 = kernel(test_x1,modela.x,'rbf',rbf);
func = test_x1*modela.w; 



label_predict=zeros(n,1);  
for i=1:n
    if func(i)>=0
        label_predict(i)=1;
    else
        label_predict(i)=-1;
    end
end

    %%% acc,gmean,fscore
TP = 0; FN = 0;TN = 0; FP = 0;

for i=1:n
    if test_y(i)==1 && label_predict(i)==1
        TP=TP+1;
    elseif test_y(i)==1 && label_predict(i)==-1
        FN=FN+1;
    elseif test_y(i)==-1 && label_predict(i)==1
        FP=FP+1;
    else
        TN=TN+1;
    end
end
    acc = (TP+TN)/(TP+TN+FP+FN);
    pre = TP/(TP+FP);
    recall = TP/(TP+FN);
    spec = TN/(TN+FP);
    gmean = (recall*spec)^0.5;
    fscore = 2*pre*recall/(pre+recall);
    auc_arr=AUC(test_y,func);

end