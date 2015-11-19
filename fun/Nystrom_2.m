function [KVec] = Nystrom_2(A,B,k)
%m = double(m);
%[rows,cols] = size(Similarity);
%^A = Similarity(1:m,1:m);
%B = Similarity(1:m,m+1:rows);

%下面的代码是根据论文Spectral Grouping Using the Nystrom method中的伪代码写的
m = size(A,1);
n = size(B,2);
rows = m+n;
d1 = sum([A;B'],1);
d2 = sum(B,1) + sum(B',1)*pinv(A)* B;
dhat = sqrt(1./[d1 d2]);
dhat = dhat';
A = A.*(dhat(1:m)*dhat(1:m)');
B = B.*(dhat(1:m)*dhat(m+(1:size(d2,2)))');
Asi = sqrtm(pinv(A));
BB = B*B';
Q = A + Asi * BB * Asi;
[U,L,T] = svd(Q);
clear d1 d2 dhat Q I;
VV = Asi * U * pinv(sqrt(L));
VV = VV(:,1:k);
%V = [A;B'] * Asi * U * pinv(sqrt(L));
%下面这行代码一直出现内存问题，所以这个地方将其该掉
%V = [A;B'] * VV;
A = A*VV;
B = B'*VV;
B = B(:,1:k);
A = A(:,1:k);
V = [A;B];
KVec = ones(rows,k);
for i = 2:k
    KVec(:,i-1) = V(:,i)./V(:,1);
end
clear A B Asi U L d1 d2 dhat VV V;
end