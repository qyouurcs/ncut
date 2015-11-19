function [IDX,NMI,CR]=ScriptNystrom(datafile,group_num,m,delta,IsShowSample)
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

%这里不考虑错误了处理，否则代码太冗长了
load(datafile);
truelabel = dataset(:,1);%数据集是在一个dataset的变量里面放着的
[rows cols] = size(dataset);
%neighbor_num = 15;
%colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
data = dataset(:,2:cols);

%计算抽样的数据：
perm = sample_according_to_row_sum(data,m,delta);
data_perm = data(int32(perm),:);
data_sample = data_perm(1:m,:);
dist = pdist(data_sample,'euclidean');
dist = squareform(dist);
A = exp(-dist/(2*delta^2));
dist = dist2(data_perm(1:m,:),data_perm((m+1):rows,:));
B = exp(-dist/(2*delta^2));
clear dist data_perm;
evec = Nystrom_Original(A,B,group_num);
IDX = k_means(evec,[],group_num,100);
%根据perm回复按原来顺序的那个IDX,这个是用C++写的
if IsShowSample ~= 0
    ShowSample(data,truelabel,perm(1:m),group_num);
end
IDX = perm_transform(IDX,int32(perm));
if nargout >= 2 %计算NMI
    NMI = nmi(truelabel,IDX);
end
if nargout >= 3
    lablesnum = unique(truelabel);
    IDX = lablesnum(IDX);
    [assignment CR] = renumber(IDX,truelabel);
end
end