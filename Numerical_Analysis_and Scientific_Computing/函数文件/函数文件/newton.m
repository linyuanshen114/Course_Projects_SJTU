function r=newton(f,x0,tol,m)
format long;
syms x;
if nargin<4
    m=1;
end
df=diff(f,x);
x1=vpa(x0-m*subs(f,x0)./subs(df,x0));
d=abs(x1-x0)./max(1,x1);
while d>=tol&&vpa(subs(df,x1))~=0
    x0=x1;
    x1=vpa(x0-m*subs(f,x0)./subs(df,x0));
    d=abs(x1-x0)./max(1,x0);
end
r=x1;

end