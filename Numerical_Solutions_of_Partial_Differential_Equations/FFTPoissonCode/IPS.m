function U=IPS(N)
% Jacobi迭代法(矩阵形式)求解Poisson方程

tol=10^-6;%容许误差
h=1/N;x=h*(1:N-1);
[X,Y]=meshgrid(x,x);
F=Funf(X,Y);

U=zeros(N-1);
B=diag(ones(N-2,1),1);
B=B+B';
flag=1;
while flag>tol
    Unew=(B*U+U*B+h*h*F)/4;
    flag=norm(Unew-U,'fro');
    U=Unew;
end