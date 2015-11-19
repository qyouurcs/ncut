function S = calc_similarity(data1,data2,similarity_function)
%本函数根据数据点计算相似度,目前仅支持'Gaussian_Kernel'
%第二个参数方便以后扩充
%input:data1,data2数据点 (列表示属性)
%similarity_function是一个struct,包含了method属性是一个字符串表示的是相似度函数
%的名称，以及相关的参数
% function        |  Para_Name     | Class
% gaussian_kernel |  method        | string
%                 |  delta         | double
%output:形似度矩阵 S
delta = 0.22;
if(nargin < 2)
    similarity_function.method  = 'gaussian_kernel';
    similarity_function.delta = delta;
end

switch lower(similarity_function.method)
    case 'gaussian_kernel'
        delta = similarity_function.delta;
        distance = dist2(data1,data2);
        S = exp(-distance/delta);
end
    
end