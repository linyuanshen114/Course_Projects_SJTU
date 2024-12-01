function [L,U]=lu_dpst(A)
i=1;
[nX,~]=size(A);
L=eye(nX);
U=A;
while i<=nX
    if A(i,i)==0
        disp('Diagonal element zero')
        break;
    end
    a=A(i,i);
    M=A;
    M(i,:)=A(i,:)/a;
    for k=i+1:nX
    L(k,i)=A(k,i)/a;
    A(k,:)=A(k,:)-M(i,:)*A(k,i);
    end
    i=i+1;
    U=A;
end
end