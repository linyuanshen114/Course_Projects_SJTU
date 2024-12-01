function w=myDST(v)
% 输入矩阵或列向量v，计算其离散正弦变换w
m=size(v,1);
w=v;
for i=1:m
    w(i,:)=sin((1:m)*i*pi/(m+1))*v;
end