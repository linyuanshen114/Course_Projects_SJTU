function U = DSTPS_q2(N)

% 快速正弦变换求解Poisson方程,求解区域[0,1]^2
% 输入:划分数 N
% 输出:数值解 U(矩阵形式)

h=1/N;
x=h*(1:N-1);
[X,Y]=meshgrid(x,x);
Boundry = zeros(N-1,N-1);
Boundry(1,:) = N^2*Bound(0,x);
Boundry(N-1,:) = N^2*Bound(1,x);
Boundry(:,1) = N^2*Bound(x',0) + Boundry(:,1);
Boundry(:,N-1) = N^2*Bound(x',1) + Boundry(:,N-1);
F=Funf_q2(X,Y);
F=F'+Boundry;
lambda=sin(pi*x/2);
lambda=4*lambda.*lambda;

T=dst(dst(F)')';

V=zeros(N-1);
for i=1:N-1
    for j=1:N-1
        V(i,j)=T(i,j)/(lambda(i)+lambda(j));
    end
end
V=4*h^4*V;

U=dst(dst(V)')';