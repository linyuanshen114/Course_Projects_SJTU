function U=DSTPSDiag(N)
% 快速正弦变换求解Poisson方程
% 求解区域[0,1]^2
% 采用对角化的方法
h=1/N;
x=h*(1:N-1);
[X,Y]=meshgrid(x,x);
F=Funf(X,Y);
lambda=sin(pi*x/2);
lambda=4*lambda.*lambda;

G=DST(F);
G=DST(G')';
G=2*h*G;

X=zeros(N-1);
for j=1:N-1
    for k=1:N-1
        X(j,k)=G(j,k)/(lambda(j)+lambda(k));
    end
end
X=h*h*X;

U=DST(X);
U=DST(U')';
U=2*h*U;