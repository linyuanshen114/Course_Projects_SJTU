function E=TestDSTPS(N)
% ���� DSTPS.m
% ���� ������ N
% ��� ������E ,����ʱ��

tic
U=DSTPS(N);
toc

h=1/N;x=h:h:1-h;
[X,Y]=meshgrid(x,x);
Uexact=(1-X).*(1-Y).*sin(2*pi*X.*Y);

E=norm(U-Uexact,'fro')/norm(Uexact,'fro');