function PermuteData(dataset)
% input:string of the dataset
%       while I found this is not going to work well..... 
%       anyway it is specialised for the Data.mat 
% date: 2010.4.20
if( nargin ==0)
    dataset = 'Data.mat';
end
load(dataset);
len = numel(XX);
for i = 1:len
    data =XX{i};
    perm = randperm(size(data,1));
    XX{i} = data(int32(perm),:);
end
save permData  XX group_num;
end