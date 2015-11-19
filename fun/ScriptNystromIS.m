function [IDX NMI CR] = ScriptNystromIS(datafile,group_num,m,delta,Normalized)
%function[IDX,NMI,CR]=ScriptNystromSI(datafile,group_num,m,delta,IsShowSample)
%参数：
% datafile：测试的数据文件（可以包含路径)；
% group_num:聚类数目；
% m；抽样数目；
% noise: 噪声点的个数
% delta: 控制高斯核函数；

% 输出：
% IDX：聚类的类标号；
% NMI: 假设真实的类标号在数据的第一列出现！
% CR:正确率

if nargin < 5
    Normalized = 0;
end
DEBUG_MATLAB = -1;
dataset = 0;
load(datafile);
truelabel = dataset(:,1);
[rows cols] = size(dataset);
perm = randperm(rows);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
%首先随机选择两个数据点，然后剩下的数据点按照(方差最小)的原则选择
sample_idx = perm(1:2);
sample_all = true(rows,1);
sample_all(sample_idx) = false;
dist_un = dist2(data(sample_idx,:),data(sample_all,:));
B = exp(-dist_un/(2*delta^2));
for i = 3:m
    var_b = var(B);
    [val,idx] = min(var_b);
    idx_t = 0;
    for j = 1:rows
        if(sample_all(j))
            idx_t = idx_t + 1;
        end
        if idx_t == idx
            break;
        end
    end
    sample_idx(i) = j;
    sample_all(j) = false;
    B(:,idx) = [];
    B(end+1,:) = exp(-(dist2(data(j,:),data(sample_all,:)))/(2*delta^2));
end

dist = dist2(data(sample_idx,:),data(sample_idx,:));%'euclidean');
%dist = squareform(dist);
A = exp(-dist/(2*delta^2));
clear dist ;
evec = Nystrom_Original(A,B,group_num,Normalized);
if DEBUG_MATLAB > 0
    figure;
   % plot(evec(:,1),evec(:,2),'.');
    plot(dataset(:,2),dataset(:,3),'r.');
    hold on;
    plot(dataset(idx_noise,2),dataset(idx_noise,3),'b.');
    axis equal;
    grid on;
end
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end
%同时也需要修改truelabel的值
IDX_p(sample_idx) = IDX(1:m);
IDX_p(sample_all) = IDX(m+1:rows);
clear IDX;
IDX = IDX_p;
if nargout >= 2 %计算NMI
    NMI = nmi(truelabel,IDX_p');
end
if nargout >= 3
    lablesnum = unique(truelabel);
    IDX_p = lablesnum(IDX_p);
    [assignment CR] = renumber(IDX_p,truelabel);
end
end
