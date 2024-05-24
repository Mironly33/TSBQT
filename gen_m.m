function [m]=gen_m(model,x,y,rbf)
    [n,~] = size(x);
    x = kernel(x,model.x,'rbf',rbf);
    f = y.*(x*model.w); 

    P = sum(y==1);
    N = sum(y==-1);


  % exp projector  h(.)  bata>0,越大对ep mis等惩罚越大
    beta = 0.6;   
    m = 2./(1+exp(beta*(f-1)));

    % 保证mi不能为0
    for i=1:length(m)
        if m(i)<0.0001
            m(i)=0.0001;
        end
    end
   

end
