function U=DSTPS_q3(N1,N2,a,b)
% 快速正弦变换求解Poisson方程,求解区域[0,1]^2
% 输入:x方向划分数 N1,y方向划分数 N2
% 输出:数值解 U(矩阵形式)

h1=1/N1;
h2=1/N2;
x=h1*(1:N1-1);
y=h2*(1:N2-1);
[X,Y]=meshgrid(x,y);
Boundry = zeros(N1-1,N2-1);
Boundry(1,:) = (N1/a)^2*Bound(0,b*y);
Boundry(N1-1,:) = (N1/a)^2*Bound(a,b*y);
Boundry(:,1) = (N2/b)^2*Bound((a*x)',0) + Boundry(:,1);
Boundry(:,N2-1) = (N2/b)^2*Bound((a*x)',b) + Boundry(:,N2-1);
F=Funf_q2(a*X,b*Y);F=F'+Boundry ;
lambda=sin(pi*x/2);
lambda=4*lambda.*lambda/(a*h1)/(a*h1);
mu=sin(pi*y/2);
mu=4*mu.*mu/(b*h2)/(b*h2);

T=dst(dst(F)')';

V=zeros(N1-1,N2-1);
for i=1:N1-1
    for j=1:N2-1
        V(i,j)=T(i,j)/(lambda(i)+mu(j));
    end
end
V=4*h1*h2*V;

U=dst(dst(V)')';