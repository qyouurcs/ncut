load ./mnist_all.mat;
s = 'test';
dataset = [];
cols = 784;
for i = 0:9
    str = [ s num2str(i)];
    a = eval(str);
    num = size(dataset,1);
    rows = size(a,1);
    dataset(num+1:num+rows,2:cols+1) = a;%��������
    dataset(num+1:num+rows,1) = i+1;%���ţ���Ϊ�����в��ܳ���0���������NMIʱ�����ִ��󣩣�
end
result = [ 'mnist_' s '.mat'];
save(result,'dataset');