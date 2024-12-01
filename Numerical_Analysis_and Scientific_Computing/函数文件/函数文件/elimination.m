function X=elimination(X,i,j)
[nX,mX]=size(X);
a=X(i,j);
X(i,:)=X(i,:)/a;
for k=1:nX
    if k==i
        continue
    end
    X(k,:)=X(k,:)-X(i,:)*X(k,j);
end