function [modela] = ADMM(X1,m,Y,para,sig,tau,stop,nag,kfold,dataname,t)

[n, ~] = size(X1);

One = ones(n,1);  %vetor（1）列向量
% K = kernel(X1,X1,'linear',rbf_sig);

%非线性
K = kernel(X1,X1,'rbf',para.rbf);

%% 参数赋值

a = para.a;
b = para.b;
C = para.c;
rbf =para.rbf;

[sig1,sig2] = deal(sig);
[tau] = deal(tau);

maxiter1 = stop.iter1;
maxiter2 = stop.iter2;
tol = stop.tol;
tol2 = stop.tol2;

eta = nag.eta;
r = nag.r;

%% initialize
Alp=zeros(n,1);
ksi=zeros(n,1);

pi1=zeros(n,1);
pi2=zeros(n,1);

u1=zeros(n,1);
u2=zeros(n,1);



%% ADMM更新
stop_i=0;
for iter = 1 : maxiter1
    
    fprintf('\n*****************************model:%d  ADMM iter: %d K: %d Dataset: %s ******************************\n', t,iter',kfold,dataname);
    fprintf('\n********  a: %4.4e b: %4.4e  C: %4.4e  rbf: %4.4e sig: %4.4e tau: %4.4e ********\n',a,b,C,rbf,sig,tau);
    Alp_pre = Alp; ksi_pre = ksi;
    
    % update Alp
    Alp=(K+sig1*K'*K)\(-Y.*(K*u1)+sig1*Y.*(K*(One-ksi+pi1)));
    Alp=Alp/norm(Alp);%防爆炸处理，标准化  norm是二范数
    %Replace inv(A)*b with A\b, Replace b*inv(A) with b/A
    
    % update ksiA
    [ksi,iterA,gradA]=GD(K,Alp,m,ksi,Y,C,pi1,pi2,u1,u2,a,b,sig1,sig2,maxiter2,eta,tol2,One);
    NAG_A.iter = iterA;
    NAG_A.grad = gradA;
%     ksiA = 0.1*ones(n,1);%参数固定

    % update pi1
    pi1=pos(u1/sig1+(Y.*(K*Alp)-One+ksi));  %保证pi12非负变量pos()定义在最后
%     pi1 = 0.5*ones(n,1);%参数固定

    % update pi11
    pi2=pos(u2/sig2+ksi);
    
    % updating multipliers
    % update u1 (multiplier)
    u1=u1+tau*sig1*(Y.*(K*Alp)+ksi-One-pi1);
    % update u3 (multiplier)
    u2=u2+tau*sig2*(ksi-pi2);
    
    

    
    %% 变量打印区域
    cal = [norm(Alp),norm(ksi);...
        norm(pi1),norm(pi2);...
        norm(u1),norm(u2)];
    variablename = ['Alp: %4.4e \n','ksi: %4.4e \n'];
    fprintf(variablename, cal(1,:));
    piname = ['pi1: %4.4e \n','pi2: %4.4e \n'];
    fprintf(piname,cal(2,:));
    uname = ['u1: %4.4e \n','u2: %4.4e \n'];
    fprintf(uname,cal(3,:));
    
    %%% calculate objective value
    value(iter) =(Alp')*K*Alp;
    loss(iter) =One'*(One-One./(One+b*m.*m.*ksi.*ksi.*exp(a*Y.*m.*ksi)));
    fval(iter)=Alp'*K*Alp + C*One'*(One-One./(One+b*m.*m.*ksi.*ksi.*exp(a*m.*Y.*ksi)));
    fprintf('fval: %4.4e \n',fval(iter));
    fprintf('value: %4.4e \n',value(iter));
    fprintf('loss: %4.4e \n',loss(iter));

    
    %% stopCond
    if isnan(norm(Alp))==1
        disp(' !!!ADMM is Exploding!!! ');  break;   %爆炸
    end

    stopCond1 = norm(Alp - Alp_pre)/norm(Alp_pre);
    stopCond2 = norm(ksi- ksi_pre)/norm(ksi_pre);
    stopCond = max([stopCond1 stopCond2]);
    fprintf('stopCound1: %4.4e \n', stopCond1);
    fprintf('stopCound2: %4.4e \n', stopCond2);
    fprintf('ADMM stopFormulaVal: %4.4e \n', stopCond);
    
    if (iter> 10) &&  (stopCond < tol )  
        disp(' !!!stopped by ADMM termination rule!!! ');  break;
    end
    stop_i =stop_i+1;
end


modela.ksi =ksi;
modela.w = Alp;
modela.x = X1;
end