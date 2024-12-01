%fpi.m – fixed point iteration
function xc=fpi(g, x0, tol)
X(1)=x0;
i=1;
t=1;
while t>=tol
X(i+1)=g(X(i));
t=abs(X(i+1)-X(i))./(max(abs(X(i+1)),1));
i=i+1;
end
xc=X(i);
syms x;
u=diff(g(x));
S=vpa(abs(subs(u,x,xc)))
if S<1
    disp '收敛'
else
    disp '发散'
end
e(1)=abs(X(1)-xc);
i=1;
t=1;
E(1)=0;
while t>=tol
X(i+1)=g(X(i));
e(i+1)=abs(X(i+1)-xc);
E(i+1)=(e(i+1)/e(i));
t=abs(X(i+1)-X(i))./(max(abs(X(i+1)),1));
i=i+1;
end
n=[0:1:(i-1)];
n=n';
X=X';
e=e';
E=E';
table(n,X,e,E,'VariableNames',{'i','x_{i}','e_{i}','e_{i}/e_{i-1}'})
end
