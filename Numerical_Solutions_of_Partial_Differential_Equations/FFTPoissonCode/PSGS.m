function U=PSGS(N)
% G-S迭代法求解Poisson方程

tol=10^-6;%容许误差

h=1/N;x=h*(0:N);
[X,Y]=meshgrid(x,x);
F=h*h*Funf(X,Y);

U=zeros(N+1);V=U;flag=1;
while flag>tol
    for i=2:N
        for j=2:N
            V(i,j)=(V(i-1,j)+U(i+1,j)+V(i,j-1)+U(i,j+1)+F(i,j))/4;
        end
    end
    flag=norm(V-U,'fro');
    U=V;
end