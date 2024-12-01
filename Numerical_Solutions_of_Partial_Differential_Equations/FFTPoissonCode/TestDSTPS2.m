function E=TestDSTPS2(N1,N2)
% 测试 DSTPS2.m
% 输入 划分数 N1,N2
% 输出 相对误差 E

U=DSTPS2(N1,N2);

h1=1/N1;x=h1:h1:1-h1;
h2=1/N2;y=h2:h2:1-h2;
[X,Y]=meshgrid(x,y);
Uexact=sin(pi*X).*sin(pi*Y);Uexact=Uexact';

E=norm(U-Uexact,'fro')/norm(Uexact,'fro');