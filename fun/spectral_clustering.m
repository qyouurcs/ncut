function [cluster_labels, NMI]=spectral_clustering(datafile, delta)
%  data
%  truelable:the true lable of data
%  k:the number of cluster
%  delta:using in the kernel matrix
%  miter:the max iterator time of k_means

dataset = 0;
load(datafile);
truelabel = dataset(:,1);
[~, cols] = size(dataset);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));

k = length(unique(truelabel));
[m,n]=size(data);
%claculate kernel matrix
dist_un = dist2(data,data);
W = exp(-dist_un/(2*delta^2));
D = sum(W,1);
D = 1./sqrt(D);
W = diag(D) * W * diag(D);
[V1 ,d ,u] = svd(W);
V=V1(:,1:k);
V=V./repmat(sum(V.*V,2).^(1/2),1,k);
V=V(:,2:k);
% [cluster_labels]=k_means(V, [], k,miter);
[cluster_labels]=kmeans(V,k,'Replicate',10,'emptyaction','singleton');

if length(truelabel) == length(cluster_labels) 
    NMI = nmi(truelabel,cluster_labels);
else
    NMI = 0;
end