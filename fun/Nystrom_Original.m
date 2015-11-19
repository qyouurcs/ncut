function [KVec] = Nystrom_Original(A,B,k,Normalized)

if nargin < 4
    Normalized = 0;
end
%下面的代码是根据论文Spectral Grouping Using the Nystrom method中的伪代码写的
m = size(A,1);
d1 = sum([A;B'],1);
d2 = sum(B,1) + sum(B',1)*pinv(A)* B;
dhat = sqrt(1./[d1 d2]);
dhat = dhat';
A = A.*(dhat(1:m)*dhat(1:m)');
B = B.*(dhat(1:m)*dhat(m+(1:size(d2,2)))');
Asi = sqrtm(pinv(A));
Q = A + Asi * B * B' * Asi;
[U,L,T] = svd(Q);
V = [A;B'] * Asi * U * pinv(sqrt(L));
KVec = V(:,1:k);
if Normalized ~=0
    rows = size(KVec,1);
    KVec = ones(rows,k-1);
    for i = 2:k
        KVec(:,i-1) = V(:,i)./V(:,1);
    end
end
clear A B Asi Q U L T d1 d2 dhat;
end