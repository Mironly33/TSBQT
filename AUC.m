function [auc]=AUC(testlabel,predictlabel) 
% INPUTS
%  output      - 分类器对测试集的分类结果
%  test_targets - 测试集的正确标签,这里只考虑二分类，即0和1
% OUTPUTS
%  auc            - 返回ROC曲线的曲线下的面积

%初始点为（1.0, 1.0）
x = 1.0;
y = 1.0;

%首先对predict中的分类器输出值按照从小到大排列得到index I
[A,I]=sort(predictlabel); 
testlabel=testlabel(I);

M=0;N=0; 
% 计算实际的正负样本数
for i=1:length(predictlabel) 
    if(testlabel(i)==1) 
        M=M+1;%正类样本数
    else 
        N=N+1;  %负类样本数
    end 
end 
%根据该数目可以计算出沿x轴或者y轴的步长
x_step = 1.0/N;
y_step = 1.0/M;

for i=1:length(testlabel)
    if testlabel(i) == 1
        y = y - y_step;
    else
        x = x - x_step;
    end
    X(i)=x;
    Y(i)=y;
end
%画出图像
% plot(X,Y,'-ro','LineWidth',2,'MarkerSize',3);
% xlabel('虚报概率');
% ylabel('击中概率');
% title('ROC曲线图');
% %计算小矩形的面积,返回auc
auc = -trapz(X,Y);



% sigma=0; 
% for i=M+N:-1:1 
%     if(test_targets(I(i))==1) 
%         sigma=sigma+i;%正类样本rank相加 
%     end 
% end
% result=(sigma-(M+1)*M/2)/(M*N); 