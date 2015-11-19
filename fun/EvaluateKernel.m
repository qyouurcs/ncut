function G = EvaluateKernel(dataset,I,delta)
%参数：dataset:数据集
%      I 抽样数据点的index
%输出：G
dist = dist2(dataset(I,:),dataset(I,:));
G = exp(-dist/(2*delta^2));
end