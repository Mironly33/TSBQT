function [viewa] = Crossvalidation(data,para,sig,tau,stop,nag,dataname)

%     y = data(:,1);
%     x = data(:,2:end);
    y = data.y;
    x = data.x;
    xt = mapminmax(x',0,1);   
    x = xt';

    %缩减样本量的随机抽样
% 	index = randperm(size(y,1),2000);
%     x1 = x1(index,:);
%     x2 = x2(index,:);
%     y = y(index,:);
    
    [n,~] = size(x);
    x = [x,ones(n,1)];

    RESULT =[];
    Metric=[];

    [viewa.acc,viewa.gmean,viewa.f1,viewa.auc,viewa.recall,viewa.spec]...
                = deal(0,0,0,0,0,0);
    [viewa.accstd,viewa.gmeanstd,viewa.f1std,viewa.aucstd,viewa.recallstd,viewa.specstd]...
                = deal(0,0,0,0,0,0);



        %% 交叉验证训练w，b    
        [M,N]=size(y);
        M_next = [];
       
        indices=crossvalind('Kfold',y(1:M,N),3);

        
        for k=1:3
            test = (indices == k); 
            train = ~test;
            train_x=x(train,:);
            train_y=y(train,:);
            test_x=x(test,:);
            test_y=y(test,:);
            % n0 represents the number of train_x
            [n0,~] = size(train_x);
            
            for t=1:2
                if t == 1   % t = 1 BQT model first stage m = (1,1,1,...,1)
                    m = ones(n0,1);
                    fprintf(' ############ model %d begins runnning ############ ',t);
                    [model] = ADMM(train_x,m,train_y,para,sig,tau,stop,nag,k,dataname,t);
                    if isnan(norm(model.w))==1
                        disp(' !!!Exploding!!! ');  break;   %爆炸
                    end
                    % get the m of train_x to train next stage
                    fprintf('--------model %d is generating the weight m for next model %d-------\n',t,t+1);
                    [m_next] = gen_m(model,train_x,train_y,para.rbf);

                else        % t = 2 The second stage TSRBQT
                    m = m_next;
                    [model] = ADMM(train_x,m,train_y,para,sig,tau,stop,nag,k,dataname,t);
                    fprintf(' ############ model %d ends running ############ \n',t);
                end  

            end

            [acc0,gmean0,fscore0,auc_arr0,recall0,spec0] = predict(model,test_x,test_y,para.rbf);%纯A
        
            acc(k) = [acc0];
            gmean(k) = [gmean0];
            fscore(k) = [fscore0];        
            auc(k) = [auc_arr0];
            recall(k)=[recall0];
            spec(k)=[spec0];
        end

            [viewa.acc,viewa.gmean,viewa.f1,viewa.auc,viewa.recall,viewa.spec]...
                = deal(nanmean(acc),nanmean(gmean),nanmean(fscore),nanmean(auc),nanmean(recall),nanmean(spec));
            [viewa.accstd,viewa.gmeanstd,viewa.f1std,viewa.aucstd,viewa.recallstd,viewa.specstd]...
                = deal(nanstd(acc),nanstd(gmean),nanstd(fscore),nanstd(auc),nanstd(recall),nanstd(spec));
            

end

