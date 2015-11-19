function [sample_idx,G_S] = metropolis(dataset,k,T,delta)
% dataset:数据集
% k：dimension of the approximation(number of samples)
% T: 迭代的次数
n = size(dataset,1);
perm = randperm(n);
sample_idx = perm(1:k);
sample_ind = false(n,1);
test_counter = 0;
G_S = EvaluateKernel(dataset,sample_idx,delta);
fprintf('det(G_S) = %d',det(G_S));
for i = 1:T
    s = randperm(k);
    sample_ind(sample_idx) = true;
    s = s(1);
    perm = randperm(n);
    sample_ind = sample_ind(perm);
    for j = 1:n
        if ~sample_ind(j)
            break;
        end
    end
    sample_idx_n = sample_idx;
    sample_idx_n(s) = perm(j);
    G_N = EvaluateKernel(dataset,sample_idx_n,delta);
    y = 0;
    if det(G_N) < det(G_S) && det(G_S) > 0 && det(G_N) > 0
%        sample_idx_n = sample_idx;
        y = randsample(2,1,true,[det(G_N) det(G_S) ]);
    end
    if y ==1 || det(G_N) >= det(G_S)
        sample_idx = sample_idx_n;
        G_S = G_N;
        test_counter = test_counter + 1;
    end
    sample_ind(1:n) = false;
end
fprintf('det(G_N) = %d\t test counter = %d, T - test_counter = %d\n',det(G_N),test_counter,T - test_counter);
end