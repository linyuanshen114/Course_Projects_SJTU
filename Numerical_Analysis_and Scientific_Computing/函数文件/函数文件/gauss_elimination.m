function C=gauss_elimination(A,B)
i=1;
X=[A B];
[nX,mX]=size(X);
while i<=nX
    if X(i,i)==0
        disp('Diagonal element zero')
        return
    end
    X=elimination(X,i,i);
    i=i+1;
end
C=X(:,mX);

end