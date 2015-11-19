function [KVec] = Nystrom_kmeans(Similarity,m,k)
m = double(m);
[rows,cols] = size(Similarity);
if(m >rows)
    warning('��������Ŀ���ܴ���������Ŀ');
    KVec = [];
    return;
end
A = Similarity(1:m,1:m);
B = Similarity(1:m,m+1:rows);

%����Ĵ����Ǹ�������Spectral Grouping Using the Nystrom method�е�α����д��
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
%KVec = ones(rows,k);
% for i = 2:k
%     KVec(:,i-1) = V(:,i)./V(:,1);
% end
clear A B Asi Q U L T d1 d2 dhat;
end