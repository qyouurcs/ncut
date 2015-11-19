function [IDX NMI CR] = ScriptNystromWithRandomSampling(datafile,group_num,m,delta,Normalized)
%function[IDX,NMI,CR]=ScriptNystromSI(datafile,group_num,m,delta,IsShowSample)
%参数：
% datafile：测试的数据文件（可以包含路径)；
% group_num:聚类数目；
% sample_num；抽样数目；
% delta: 控制高斯核函数；
% ShowSample:控制是否显示抽样结果；
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
perm = randperm(rows);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
sample_IDX = perm(1:m);
dist = dist2(data(sample_IDX,:),data(sample_IDX,:));%'euclidean');
%dist = squareform(dist);
A = exp(-dist/(2*delta^2));
dist = dist2(data(sample_IDX,:),data(perm((m+1):rows),:));
B = exp(-dist/(2*delta^2));
clear dist ;

evec = Nystrom_Original(A,B,group_num,Normalized);
if DEBUG_MATLAB > 0
    plot(evec(:,1),evec(:,2),'.');
    axis equal;
    grid on;
end
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end

IDX = perm_transform(IDX,int32(perm));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示聚类结果：
if DEBUG_MATLAB > 0
    ShowDataSet(datafile,group_num,gap,IDX);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
