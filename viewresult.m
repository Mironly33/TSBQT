function result = viewresult(viewa,max_acc,max_gmean,max_fscore,max_auc,max_recall,max_spec,para)
    if viewa.acc>max_acc.value
        max_acc.value = viewa.acc;
        max_acc.std = viewa.accstd;
        max_acc.para = para;
        max_acc.t=2;
        

        
    end

    if viewa.gmean>max_gmean.value
        max_gmean.value = viewa.gmean;
        max_gmean.std = viewa.gmeanstd;
        max_gmean.para = para;
        max_gmean.t=2;
        max_recall.value = viewa.recall;
        max_recall.std = viewa.recallstd;
        max_recall.para = para;
        max_recall.t=2;
        max_spec.value = viewa.spec;
        max_spec.std = viewa.specstd;
        max_spec.para = para;
        max_spec.t=2;

    end

    if viewa.f1>max_fscore.value
        max_fscore.value = viewa.f1;
        max_fscore.std = viewa.f1std;
        max_fscore.para = para;
        max_fscore.t=2;
       

    end

    if viewa.auc>max_auc.value
        max_auc.value = viewa.auc;
        max_auc.std = viewa.aucstd;
        max_auc.para = para;
        max_auc.t=2;
       
    end
    


result = [max_acc.value,max_acc.std,max_acc.para,max_acc.t,...
        max_gmean.value,max_gmean.std,max_gmean.para,max_gmean.t,...
        max_fscore.value,max_fscore.std,max_fscore.para,max_fscore.t,...
        max_auc.value,max_auc.std,max_auc.para,max_auc.t,...
        max_recall.value,max_recall.std,max_recall.para,max_recall.t,...
        max_spec.value,max_spec.std,max_spec.para,max_spec.t];

end