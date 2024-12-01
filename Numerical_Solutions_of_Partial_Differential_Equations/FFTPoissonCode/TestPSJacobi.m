function E=TestPSJacobi(N)
tic
U=PSJacobi(N);
toc
h=1/N;
x=0:h:1;
[X,Y]=meshgrid(x,x);
Uexact=sin(pi*X).*sin(pi*Y);
E=norm(U-Uexact,'fro')/norm(Uexact,'fro');