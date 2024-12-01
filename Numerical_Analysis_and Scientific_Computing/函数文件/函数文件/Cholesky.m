function R=Cholesky(A)
format long
[m,n]=size(A);
for i=1:n
    if A(i,i)<0
        break;
    end
    R(i,i)=sqrt(A(i,i));
    u=(A(i,i+1:n)./R(i,i))';
    R(i,i+1:n)=u';
    A(i+1:n,i+1:n)=A(i+1:n,i+1:n)-u*(u');
end