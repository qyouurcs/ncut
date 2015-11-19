function knnindex = knn(D,k,knnstruct)
%���룺D����(�д�������)��k�ǿ��ǵ�����ڵĸ���
%     knnstruct ��һ��struct�ṹ�����б������method��para��������
%     method Ŀǰ������ŷʽ���루Euclidean ����Ҳ�����Ǹ�˹����(Gaussian)
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
        sim_struc.delta = knnstruct.para;%��ʱĬ�ϵ��Ǹ�para���Ծ���delta�������㷨�еĲ������õ�ʱ������չ
        distance = 1./calc_similarity(D,D,sim_struc);
end
[distance,dist_index ] = sort(distance,2);
knnindex = zeros(rows,rows);
for i= 1:rows
    knnindex(i,dist_index(i,1:k)) = 1;
end
clear distance dist_index;
end