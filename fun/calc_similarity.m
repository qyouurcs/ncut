function S = calc_similarity(data1,data2,similarity_function)
%�������������ݵ�������ƶ�,Ŀǰ��֧��'Gaussian_Kernel'
%�ڶ������������Ժ�����
%input:data1,data2���ݵ� (�б�ʾ����)
%similarity_function��һ��struct,������method������һ���ַ�����ʾ�������ƶȺ���
%�����ƣ��Լ���صĲ���
% function        |  Para_Name     | Class
% gaussian_kernel |  method        | string
%                 |  delta         | double
%output:���ƶȾ��� S
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