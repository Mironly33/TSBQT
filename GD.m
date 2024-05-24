function [ksi,iter2,grad]=GD(K,Alp,m,ksi,Y,C,pi1,pi2,u1,u2,a,b,sig1,sig2,maxiter2,eta,tol2,one)

% 单视角情况下的GD算法
%t=1;
%while t <=maxiter2
for iter2 = 1:maxiter2
    eta=eta/iter2;
    % 需要更改的地方
    grad = C*b*(2*one+a*m.*ksi.*Y).*m.*m.*ksi.*exp(a*m.*Y.*ksi)./((one+b*m.*m.*ksi.*ksi.*exp(a*m.*Y.*ksi)).^2)....
        +u1+u2+sig1*(ksi+Y.*(K*Alp)-one-pi1)+sig2*(ksi-pi2);
    ksi=ksi-eta*grad;
%         
    stopCond = max(abs(grad));
    %stopCond = norm(grad);
    if (iter2> 50) &&  (stopCond < tol2)   % 前为真才计算后面的
        % disp(' !!!stopped by termination rule!!! ');
        break;
    end
end

end