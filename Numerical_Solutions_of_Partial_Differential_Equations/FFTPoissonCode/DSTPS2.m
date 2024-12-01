function U=DSTPS2(N1,N2)
% �������ұ任���Poisson����,�������[0,1]^2
% ����:x���򻮷��� N1,y���򻮷��� N2
% ���:��ֵ�� U(������ʽ)

h1=1/N1;
h2=1/N2;
x=h1*(1:N1-1);
y=h2*(1:N2-1);
[X,Y]=meshgrid(x,y);
F=Funf(X,Y);F=F';
lambda=sin(pi*x/2);
lambda=4*lambda.*lambda/h1/h1;
mu=sin(pi*y/2);
mu=4*mu.*mu/h2/h2;

T=dst(dst(F)')';

V=zeros(N1-1,N2-1);
for i=1:N1-1
    for j=1:N2-1
        V(i,j)=T(i,j)/(lambda(i)+mu(j));
    end
end
V=4*h1*h2*V;

U=dst(dst(V)')';