function mask = ScriptSegIS(q_file,o_file,K,sample_num,win_size,IsSaveVec,IsCol)
% Input: q_file 量化之后的图片
%        o_file 原始的图片
%        K      类的数目
%        sample_num 抽样点的个数（默认值为100）
%        win_size 默认窗口大小  （默认值为7）
%Output: mask掩码（包含了每个位置处所属的类别）.
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
B = exp(1).^(-tao_dist);
for i = 3:sample_num
    var_b = var(B);
    [val,idx] = min(var_b);
    j = idx;
    sample_idx(i) = j;
    sample_all(j) = false;
    B(:,idx) = [];
    tao_dist = tao_distance_3(im_gray,sample_posB(j, :),sample_posB(sample_all, :),win_size,color_board);
    B(end+1,:) = exp(1).^(-tao_dist);
end
tao_dist = tao_distance_3(im_gray,sample_posB(sample_idx, :),sample_posB(sample_idx, :),win_size,color_board);
A = exp(1).^(-tao_dist);
% sample_posB = int32(ones(pixles_num,2));
% for i = 1:pixles_num
%     sample_posB(i,1) = int32(mod(perm(i),rows));
%     sample_posB(i,2) = int32(floor((perm(i)-1)/rows));
% end
% sample_posA = int32(sample_posB(1:sample_num,:));
% color_board = unique(sort(im_gray));
% fprintf('begin to compute tao_distance\n');
% tic;
% tao_dist = tao_distance_3(im_gray,sample_posA,sample_posB,win_size,color_board);
% clear sample_posA sample_posB;
% fprintf('done');
% toc
% fprintf('\n');
% W = exp(1).^(-tao_dist);
% clear tao_dist;
%A = W(:,perm(1:sample_num));
%B = W(:,perm((sample_num+1):pixles_num));
% A = W(:,1:sample_num);
% B = W(:,(sample_num+1):pixles_num);
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
%clear perm;
mask = reshape(mask,rows,columns);
fprintf('begin to display image\n');
tic;

%上面的是使用的是self-tuning里面的代码计算的边界
% %save([o_file '.mat'],'mask');
% %im_mask = display_clust_image_2(im,mask);
% im = imread(o_file);
% toc
% fprintf('done.\n');
% figure;
% 
% imshow(im_mask);
%这里利用sobel算子进行边缘检测
im_mask = edge(mask,'sobel');
figure;
imshow(im_mask);
print(gcf,'-depsc',[date o_file '.eps']);
print(gcf,'-djpeg90',[date o_file '.jpg']);
%clear im mask;
if IsSaveVec ~=0
    vec_o = perm_transform(vec,int32(perm));
    vec_o = abs(vec_o);
    for sd = 1:K
        figure;
        imagesc(reshape(vec_o(:,sd),rows,columns));
        print(gcf,'-depsc',[ o_file '_' num2str(sd) '_vec' '.eps']);
    end
end
if IsCol ~= 0
    %首先申请内存,应该有函数可以调用，这个地方懒得查了
    r = zeros(size(mask));
    g = r;
    b = g;
    %index = logical(zeros(size(rgb_pic)));
    for col = 1:K
        index = mask == col;
        r(index) = colors(col,1);
        g(index) = colors(col,2);
        b(index) = colors(col,3);
    end
    rgb_pic(:,:,1) = r;
    rgb_pic(:,:,2) = g;
    rgb_pic(:,:,3) = b;
    figure;
    imshow(rgb_pic);
    print(gcf,'-depsc',[o_file '_' 'color.eps']);
end
if nargout ~= 1
    mask =[];
end
end