function U=DSTPS(N)
% �������ұ任���Poisson����,�������[0,1]^2
% ����:������ N
% ���:��ֵ�� U(������ʽ)

h=1/N;
x=h*(1:N-1);
[X,Y]=meshgrid(x,x);
F=Funf(X,Y);
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