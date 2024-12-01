function E=TestBlockLU(N)
% ���� BlockLU.m
% ���� ������ N
% ��� ������E ,����ʱ��

tic
U=BlockLU(N);
toc

h=1/N;x=h:h:1-h;
[X,Y]=meshgrid(x,x);
Uexact=sin(pi*X).*sin(pi*Y);

E=norm(U-Uexact,'fro')/norm(Uexact,'fro');