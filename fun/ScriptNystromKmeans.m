function [IDX NMI CR] = ScriptNystromKmeans(datafile,group_num,m,delta,Normalized)
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
load(datafile);
truelabel = dataset(:,1);
[rows cols] = size(dataset);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%若是调用张凯的代码那么需要用到下面的三行代码，但是这样的话，效果很不好
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%kernel = struct('type', 'rbf', 'para', delta); % construct the kernel
%V = INys_SpectrEmbed(data, kernel, m);
%IDX = k_means(V(:,2:group_num),[],group_num,100);

[idx, center, m] = eff_kmeans(data, m, 10);
dist = dist2(center,center);%'euclidean');
%dist = squareform(dist);
A = exp(-dist/(2*delta^2));
dist = dist2(center,data);
B = exp(-dist/(2*delta^2));
clear dist ;

evec = Nystrom_Original(A,B,group_num,Normalized);
evec = evec((m+1):end,:);
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end
if DEBUG_MATLAB > 0
    plot(evec(:,1),evec(:,2),'.');
    axis equal;
    grid on;
end
if nargout >= 2 %计算NMI
    NMI = nmi(truelabel,IDX);
end
if nargout >= 3
%     lablesnum = unique(truelabel);
%     IDX = lablesnum(IDX);
%     [assignment CR] = renumber(IDX,truelabel);
CR = accuracy(truelabel,IDX)/100;
end
end
