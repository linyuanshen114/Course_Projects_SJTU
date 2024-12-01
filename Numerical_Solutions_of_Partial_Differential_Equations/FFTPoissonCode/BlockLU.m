function x=BlockLU(N)
% 分块LU分解求解Poisson方程,求解区域[0,1]^2
% 输入:划分数 N
% 输出:数值解 x(向量形式)

h=1/N;t=h*(1:N-1);
[X,Y]=meshgrid(t,t);
F=h*h*Funf(X,Y);
y=zeros(N-1);
x=zeros(N-1);
U=cell(size(x(:,1)));
L=U;
D=4*eye(N-1)-diag(ones(N-2,1),1)-diag(ones(N-2,1),-1);
U{1}=D;
for i=2:N-1
    L{i}=-inv(U{i-1});
    U{i}=D+L{i};
end
y(:,1)=F(1,:);
for i=2:N-1
    y(:,i)=F(i,:)'-L{i}*y(:,i-1);
end
x(:,N-1)=U{N-1}\y(:,N-1);
for i=N-2:-1:1
    x(:,i)=U{i}\(y(:,i)+x(:,i+1));
end
x=x';