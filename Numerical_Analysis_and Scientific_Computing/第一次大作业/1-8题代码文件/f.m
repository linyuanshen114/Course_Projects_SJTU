function out=f(theta)%为了求得theta,构造f(theta)=0所需f
format long;
L1=input('L1=');
L2=input('L2=');
L3=input('L3=');
g=input('gamma(rad)=') ;
p1=input('p1=');
p2=input('p2=');
p3=input('p3=');
x1=input('x1=');
x2=input('x2=');
y2=input('y2=');%输入需要的固定的参数
A2=L3.*cos(theta)-x1;
B2=L3.*sin(theta);
A3=L2.*(cos(theta).*cos(g)-sin(theta).*sin(g))-x2;
B3=L2.*(cos(theta).*sin(g)+sin(theta).*cos(g))-y2;
D=2.*(A2.*B3-B2.*A3);
M1=p2.^2-p1.^2-A2.^2-B2.^2;
M2=p3.^2-p1.^2-A3.^2-B3.^2;
N1=B3.*M1-B2.*M2;
N2=-A3.*M1+A2.*M2;%按照上述数学公式推导，计算所需关系式
out=N1.^2+N2.^2-p1.^2*D.^2;%输出函数
end