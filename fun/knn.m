function knnindex = knn(D,k,knnstruct)
%输入：D数据(列代表属性)，k是考虑的最近邻的个数
%     knnstruct 是一个struct结构，其中必须包含method和para两个参数
%     method 目前可以是欧式距离（Euclidean ），也可以是高斯距离(Gaussian)
%  create time:2009.12.14
%last modified:
if(nargin < 2)
    error('Not enough para provided');
end
[rows,cols] = size(D);
if(k >=rows)
    knnindex = ones(rows,rows);
    return;
end
switch lower(knnstruct.method)
    case 'euclidean'
        distance = dist2(D,D);
    case 'gaussian'
        sim_struc.method = 'gaussian_kernel';
        sim_struc.delta = knnstruct.para;%此时默认的那个para属性就是delta，其他算法中的参数等用到时候在扩展
        distance = 1./calc_similarity(D,D,sim_struc);
end
[distance,dist_index ] = sort(distance,2);
knnindex = zeros(rows,rows);
for i= 1:rows
    knnindex(i,dist_index(i,1:k)) = 1;
end
clear distance dist_index;
end