function U=PSJacobi(N)
% Jacobi迭代法求解Poisson方程
% 输入:划分数 N
% 输出:数值解 U(矩阵形式)

tol=10^-6;%容许误差

h=1/N;x=h*(0:N);
[X,Y]=meshgrid(x,x);
F=h*h*Funf(X,Y);

U=zeros(N+1);V=U;flag=1;
while flag>tol
    for i=2:N
        for j=2:N
            V(i,j)=(U(i-1,j)+U(i+1,j)+U(i,j-1)+U(i,j+1)+F(i,j))/4;
        end
    end
    flag=norm(V-U,'fro');
    U=V;
end
