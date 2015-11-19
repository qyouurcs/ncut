load ./mnist_all.mat;
s = 'test';
dataset = [];
cols = 784;
for i = 0:9
    str = [ s num2str(i)];
    a = eval(str);
    num = size(dataset,1);
    rows = size(a,1);
    dataset(num+1:num+rows,2:cols+1) = a;%保存数据
    dataset(num+1:num+rows,1) = i+1;%类标号（因为类标号中不能出现0，否则计算NMI时候会出现错误）；
end
result = [ 'mnist_' s '.mat'];
save(result,'dataset');