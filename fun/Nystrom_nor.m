function [Kvec] = Nystrom_nor(Similarity,m,k)
m = double(m);
[rows,cols] = size(Similarity);
if(m >rows)
    warning('抽样点数目不能大于数据数目');
    KVec = [];
    return;
end
A = Similarity(1:m,1:m);
B = Similarity(1:m,m+1:rows);
[U S V] = svd(A);
U_E = B'*U*inv(S);
Kvec =[ U;U_E];
end