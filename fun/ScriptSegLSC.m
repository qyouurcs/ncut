function mask = ScriptSegLSC(q_file,o_file,K,sample_num,win_size,IsSaveVec,IsCol, opts)
% mask = ScriptSegLSC(q_file,o_file,K,sample_num,win_size,IsSaveVec,IsCol, opts)

fprintf('begin to segment iamge %s ',o_file);
debug = 0;
colors = [0 0 1; 0 1 0; 1 0 0; 0.5 0.5 0.5];
if nargin < 4
    sample_num = 100;
    win_size = 7;
end
if  nargin < 5
    win_size = 7;
end
if nargin < 6
    IsSaveVec = 0;
end
if nargin < 7
    IsCol = 0;
end
if (~exist('opts','var'))
   opts = [];
end


p = 1000;
if isfield(opts,'p')
    p = opts.p;
end

r = 5;
if isfield(opts,'r')
    r = opts.r;
end

maxIter = 100;
if isfield(opts,'maxIter')
    maxIter = opts.maxIter;
end

numRep = 10;
if isfield(opts,'numRep')
    numRep = opts.numRep;
end

mode = 'random';
if isfield(opts,'mode')
    mode = opts.mode;
end


win_size = int32(win_size);
im = imread(['./image/' q_file]);
im_gray = rgb2gray(im);
color_board = unique(sort(im_gray));
clear im;
[rows columns] = size(im_gray);
pixles_num = numel(im_gray);
perm = randperm(pixles_num);
sample_posB = int32(ones(pixles_num,2));
for i = 1:pixles_num
    sample_posB(i,1) = int32(mod(perm(i),rows));
    sample_posB(i,2) = int32(floor((perm(i)-1)/rows));
end
sample_idx = perm(1:2);
sample_all = true(pixles_num,1);
sample_all(sample_idx) = false;
tao_dist = tao_distance_3(im_gray,sample_posB(sample_idx, :),sample_posB(sample_all, :),win_size,color_board);

% Z construction
%D = EuDist2(data,marks,0);
D = tao_dist';

if isfield(opts,'sigma')
    sigma = opts.sigma;
else
    sigma = mean(mean(D));
end

dump = zeros(nSmp,r);
idx = dump;
for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
    D(temp) = 1e100; 
end

dump = exp(-dump/(2*sigma^2));
sumD = sum(dump,2);
Gsdx = bsxfun(@rdivide,dump,sumD);
Gidx = repmat([1:nSmp]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,p);

% Graph decomposition
feaSum = full(sqrt(sum(Z,1)));
feaSum = max(feaSum, 1e-12);
Z = Z./feaSum(ones(size(Z,1),1),:);
U = mySVD(Z,K+1);
U(:,1) = [];

U=U./repmat(sqrt(sum(U.^2,2)),1,K);

% Final kmeans
label=litekmeans(U,K,'MaxIter',maxIter,'Replicates',numRep);
NMI = nmi(truelabel,label);
