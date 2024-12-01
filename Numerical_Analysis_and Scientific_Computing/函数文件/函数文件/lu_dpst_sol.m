function x=lu_dpst_sol(A,b)
[nX,~]=size(A);
[L,U]=lu_dpst(A);
c(1)=b(1);
for i=2:nX
    for j=1:i-1
        b(i)=b(i)-L(i,j)*c(j);
    end
    c(i)=b(i)/L(i,i);
end
x(nX)=c(nX)/U(nX,nX);
for i=nX-1:-1:1
    for j=i+1:nX
        c(i)=c(i)-U(i,j)*x(j);
    end
    x(i)=c(i)/U(i,i);
end
end