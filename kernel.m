 
function K = kernel(X,Y,type,rbf_sig)
    switch type
    case 'linear'
        K = X*Y';
    case 'rbf' 
%         [N,~]=size(X);
%         [M,~]=size(Y);
%         K =zeros(N,M);
%         for i=1:N
%             for j=1:M
%                 K(i,j)=exp(-(sum(X(i,:))-sum(Y(j,:))).^2/rbf_sig);
%             end
%         end

        rbf_sig = rbf_sig*rbf_sig;
        XX = sum(X.*X,2);
        YY = sum(Y.*Y,2);
        XY = X*Y';
        K = abs(repmat(XX,[1 size(YY,1)]) + repmat(YY',[size(XX,1) 1]) - 2*XY);
        K = exp(-K./rbf_sig);
    end

    % 判断矩阵m是正定、半正定还是负定

%     if issymmetric(K) % 检查矩阵是否对称
%         % disp('矩阵对称');
%         d = eig(K); % 计算矩阵特征值
%         if all(d > 0)
%             disp('矩阵正定');
%         elseif all(d >= 0)
%             disp('矩阵半正定');
%         else
%             disp('矩阵负定');
%             d
%         end
%     else
%         disp('矩阵不对称');
%     end
end