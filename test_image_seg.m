clear
clc
addpath('./improved_nystrom');
addpath('./fun');
debug = 0;
imagefiles = {'q54082_8.png','q304034_8.png','q253027_8.png','q163085_8.png','q108082_8.png','q103070_8.png','q86016_8.png','q14037_8.png'};
files = {'q54082_8','q304034_8','q253027_8','q163085_8','q108082_8','q103070_8','q86016_8','q14037_8'};
showfiles = {'54082.jpg','304034.jpg','253027.jpg','163085.jpg','108082.jpg','103070.jpg','86016.jpg','14037.jpg'};
cluster_num = [5,2,2,3,3,4,3,2];
ii = 1;
for sample_num = 100:1:200
for ii = 1:8
K  = cluster_num(ii);
imagefile=imagefiles{ii};
win_size = int32(7);
%imagefile = 'q_newTestPic copy.png';
im = imread(['./image/' imagefile]);

im_gray = rgb2gray(im);
clear im;
[rows columns] = size(im_gray);
pixles_num = numel(im_gray);
perm = randperm(pixles_num);
%pixles_sample = perm(1:sample_num);
%生成抽样点的坐标矩阵

sample_posB = int32(ones(pixles_num,2));
for i = 1:pixles_num
    sample_posB(i,1) = int32(mod(perm(i),rows));
    sample_posB(i,2) = int32(floor((perm(i)-1)/rows));
end
sample_posA = int32(sample_posB(1:sample_num,:));
color_board = unique(sort(im_gray));
fprintf('begin to compute tao_distance\n');
tic;
tao_dist = tao_distance_3(im_gray,sample_posA,sample_posB,win_size,color_board);
clear sample_posA sample_posB;
fprintf('done');
toc
fprintf('\n');
W = exp(1).^(-tao_dist);
clear tao_dist;
%A = W(:,perm(1:sample_num));
%B = W(:,perm((sample_num+1):pixles_num));
A = W(:,1:sample_num);
B = W(:,(sample_num+1):pixles_num);
clear W;
fprintf('begin to execute nystrom extension\n');
tic;
vec = Nystrom_2(A,B,K);
clear A B;
toc
fprintf('done\n');

fprintf('begin to execute k-means\n');
tic;

IDX = k_means(vec,[],K,100);
if debug == 1
    save tmp_vec.mat vec IDX;
end
toc
fprintf('done\n');
%mask = IDX(perm);
mask = perm_transform(IDX,int32(perm));
clear perm;
mask = reshape(mask,rows,columns);
fprintf('begin to display image\n');
tic;
im = imread(['./image/' showfiles{ii}]);
im_mask = display_clust_image_2(im,mask);
toc
fprintf('done.\n');
figure;
save(['./image/' files{ii}],'im_mask');
imshow(im_mask);
print(gcf,'-depsc',['./image/' files{ii} '.eps']);
clear im mask;
end
end
