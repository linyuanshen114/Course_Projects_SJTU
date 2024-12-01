function E=TestDSTPS(N)
% 测试 DSTPS.m
% 输入 划分数 N
% 输出 相对误差E ,计算时间

tic
U=DSTPS(N);
toc

h=1/N;x=h:h:1-h;
[X,Y]=meshgrid(x,x);
Uexact=(1-X).*(1-Y).*sin(2*pi*X.*Y);

E=norm(U-Uexact,'fro')/norm(Uexact,'fro');