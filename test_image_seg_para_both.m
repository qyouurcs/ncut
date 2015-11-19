function mask = test_image_seg_para_both(q_file,o_file,K,sample_num,win_size,IsSaveVec,IsCol,steps)
% 实现了对于Nystrom以及基于随机游走的Nystrom方法的运行，以及最终结果的实现
% Input: q_file 量化之后的图片
%        o_file 原始的图片
%        K      类的数目
%        sample_num 抽样点的个数（默认值为100）
%        win_size 默认窗口大小  （默认值为7）
%Output: mask掩码（包含了每个位置处所属的类别）.
debug = 0;
colors = [0 0 1; 0 1 0; 1 0 0; 0.5 0.5 0.5];
if nargin < 4
    sample_num = 100;
end
if  nargin < 5
    win_size = 7;
end
if nargin < 6
    IsSaveVec = 1;
end
if nargin < 7
    IsCol = 1;
end
if nargin < 8
    steps = win_size;
end
win_size = int32(win_size);
%imagefile = 'q_newTestPic copy.png';
im = imread(q_file);
figure;
set(gcf,'position',[0 0 1280 399]);
axis equal;
%%%%%%%%%%%%%%%%%%%%%%%
hold on;
subplot(2,4,5);
imshow(im);
%%%%%%%%%%%%%%%%%%%%%%%
im_gray = rgb2gray(im);
clear im;
[rows columns] = size(im_gray);
pixles_num = numel(im_gray);
perm = randperm(pixles_num);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%进行Nystrom算法的一些计算
fprintf('begin to execute nystrom extension\n');
tic;
vec = Nystrom_2(A,B,K);
%clear A B;
toc
fprintf('done\n');

fprintf('begin to execute k-means\n');
tic;

IDX = k_means(vec,[],K,100);
toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%进行随机游走的相关数据的计算
S_A = 1./(sum(A)+eps);%按照列求和
N_A = A*diag(S_A);
N_A = N_A^steps;
fprintf('begin to execute nystrom extension with random walk\n');
tic;
B = (B'*N_A)';
A = A*N_A;
clear N_A;
vec_rw = Nystrom_2(A,B,K);
clear A B;
toc
fprintf('done\n');

fprintf('begin to execute k-means with rw\n');
tic;
IDX_RW = k_means(vec_rw,[],K,100);
toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('done\n');
%mask = IDX(perm);
mask = perm_transform(IDX,int32(perm));
mask_rw = perm_transform(IDX_RW,int32(perm));
%clear perm;
mask = reshape(mask,rows,columns);
mask_rw = reshape(mask_rw,rows,columns);
fprintf('begin to display image\n');
tic;
im = imread(o_file);
%save([o_file '.mat'],'mask');
%im_mask = display_clust_image_2(im,mask);
toc
fprintf('done.\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,4,1);
imshow(im);
hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%imshow(im_mask);
%print(gcf,'-depsc',[o_file '.eps']);
%clear im mask;
if IsSaveVec ~=0
    
    vec_o = perm_transform(vec,int32(perm));
    vec_rw = perm_transform(vec_rw,int32(perm));
    vec_o = abs(vec_o);
    vec_rw = abs(vec_rw);
%    for sd = 1:K
%        figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,4,2);
    imagesc(reshape(vec_o(:,1),rows,columns));
    axis equal;
    axis([0 481 0 321]);
    
    subplot(2,4,3);
    imagesc(reshape(vec_o(:,2),rows,columns));
    axis equal;
    axis([0 481 0 321]);
    
    subplot(2,4,6);
    imagesc(reshape(vec_rw(:,1),rows,columns));
    axis equal;
    axis([0 481 0 321]);
    
    subplot(2,4,7);
    imagesc(reshape(vec_rw(:,2),rows,columns));
    axis equal;
    axis([0 481 0 321]);
end
if IsCol ~= 0
    %首先申请内存,应该有函数可以调用，这个地方懒得查了
    r = zeros(size(mask));
    g = r;
    b = g;
    r_rw = r;
    g_rw = g;
    b_rw = b;
    %index = logical(zeros(size(rgb_pic)));
    for col = 1:K
        index = mask == col;
        index_rw = mask_rw == col;
        r(index) = colors(col,1);
        g(index) = colors(col,2);
        b(index) = colors(col,3);
        r_rw(index_rw) = colors(col,1);
        g_rw(index_rw) = colors(col,2);
        b_rw(index_rw) = colors(col,3);
    end
    rgb_pic(:,:,1) = r;
    rgb_pic(:,:,2) = g;
    rgb_pic(:,:,3) = b;
    rgb_pic_rw(:,:,1) = r_rw;
    rgb_pic_rw(:,:,2) = g_rw;
    rgb_pic_rw(:,:,3) = b_rw;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,4,4);
    imshow(rgb_pic);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,4,8);
    imshow(rgb_pic_rw);
    print(gcf,'-depsc',[o_file '_' 'all.eps']);
end
if nargout ~= 1
    clear;
    mask =[];
end

end