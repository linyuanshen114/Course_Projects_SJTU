function w=myDST(v)
% ��������������v����������ɢ���ұ任w
m=size(v,1);
w=v;
for i=1:m
    w(i,:)=sin((1:m)*i*pi/(m+1))*v;
end