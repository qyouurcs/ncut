function [ NMI ] = KASP( datafile,k, m, delta )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
dataset = 0;
load(datafile);
truelabel = dataset(:,1);
[~, cols] = size(dataset);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));

 [~, center] = litekmeans(data, m,'MaxIter', 50,'Replicates', 10);
%[~, center]=kmeans(data, m,'Replicate',10,'emptyaction','singleton');

[re_label] = spectral_clustering(center,delta, truelabel);
dist_un = dist2(center, data);
[~, index] = min(dist_un);
label = zeros(size(truelabel));
for i = 1 : m
    label(index == i) = re_label(i);
end
NMI = nmi(truelabel,label);
end

