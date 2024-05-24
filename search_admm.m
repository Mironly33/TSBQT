function [result,save_view]=search_admm(data,errorsave,dataname)
    [max_acc.value,max_gmean.value,max_fscore.value,max_auc.value,max_recall.value,max_spec.value] = deal(0);
    [max_acc.std,max_gmean.std,max_fscore.std,max_auc.std,max_recall.std,max_spec.std] = deal(0);
    [max_acc.para,max_gmean.para,max_fscore.para,max_auc.para,max_recall.para,max_spec.para] = deal(0);
    [max_acc.t,max_gmean.t,max_fscore.t,max_auc.t,max_recall.t,max_spec.t] = deal(0);



    save_view = [];
    result = deal(zeros(1,42));

 % 不等约束转等式约束后的系数   
    sig = 3.8*1e-5;
    tau = 1.618;
    tol = 1e-4;%需要减小截停条件
    eta = 0.01;
     %赋值
    [stop.iter1,stop.iter2,stop.tol,stop.tol2] = deal(200,400,tol,0.001);%需要扩大admm最大迭代次数iter1
    [nag.eta,nag.r] = deal(eta);
    
    for ia = 1
        para.a = 10^(ia-3);
        for ib = 1
            para.b = 10^(ib-3);
            for ic =7
                para.c =10^(ic-3);
                for i=3
                    para.rbf = 10^(i-4);
                    %参数储存
                    parameter = [para.a,para.b,para.c,para.rbf];
                    para4loss = [sig,tau,tol,eta];
                    dlmwrite(errorsave,[parameter,para4loss],'delimiter',',','-append');   % 写到errorsave里
                    try
                        [viewa] = Crossvalidation(data,para,sig,tau,stop,nag,dataname);
                        
                        save_viewa_temp = [parameter,...
                            viewa.acc,viewa.accstd,viewa.gmean,viewa.gmeanstd,viewa.f1,viewa.f1std,viewa.auc,viewa.aucstd,...
                            viewa.recall,viewa.recallstd,viewa.spec,viewa.specstd];
                        save_view = [save_view;save_viewa_temp];   % 写在grid里
                    catch
                        fprintf('Data $%s$ a:%.2f b:%.2f c:%.2f  try_catch errors happen',dataname,para.a,para.b,para.c);
                        dlmwrite(errorsave,[para,para4loss,zeros(1,2)],'delimiter',',','-append');%重复出错参数并后缀0
                        [max_acc.value,max_gmean.value,max_fscore.value,max_auc.value,max_recall.value,max_spec.value] = deal(0);
                        [viewa.acc,viewa.gmean,viewa.f1,viewa.auc,viewa.recall,viewa.spec,...
                            viewa.accstd,viewa.gmeanstd,viewa.f1std,viewa.aucstd,viewa.recallstd,viewa.specstd] = deal(0);
                    end
%% 
                        [max_acc.value,max_gmean.value,max_fscore.value,max_auc.value,max_recall.value,max_spec.value]...
                            = deal(result(1,1),result(1,8),result(1,15),result(1,22),result(1,29),result(1,36));
                        [max_acc.std,max_gmean.std,max_fscore.std,max_auc.std,max_recall.std,max_spec.std]...
                            = deal(result(1,2),result(1,9),result(1,16),result(1,23),result(1,30),result(1,37));
                        [max_acc.para,max_gmean.para,max_fscore.para,max_auc.para,max_recall.para,max_spec.para]...
                            = deal(result(1,3:6),result(1,10:13),result(1,17:20),result(1,24:27),result(1,31:34),result(1,38:41));
                        [max_acc.t,max_gmean.t,max_fscore.t,max_auc.t,max_recall.t,max_spec.t]...
                            = deal(result(1,7),result(1,14),result(1,21),result(1,28),result(1,35),result(1,42));
%                                                       
                        result = viewresult(viewa,max_acc,max_gmean,max_fscore,max_auc,max_recall,max_spec,parameter);
                 end
             end
         end
     end
  
end
    