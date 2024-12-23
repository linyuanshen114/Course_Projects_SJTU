function E=TestIPS(N)
% 测试 IPS.m
% 输入 划分数 N
% 输出 相对误差E ,计算时间

tic
U=IPS(N);
toc

h=1/N;x=h:h:1-h;
[X,Y]=meshgrid(x,x);
Uexact=sin(pi*X).*sin(pi*Y);

E=norm(U-Uexact,'fro')/norm(Uexact,'fro');