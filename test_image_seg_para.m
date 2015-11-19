function mask = test_image_seg_para(q_file,o_file,K,sample_num,win_size,IsSaveVec,IsCol)
% Input: q_file ����֮���ͼƬ
%        o_file ԭʼ��ͼƬ
%        K      �����Ŀ
%        sample_num ������ĸ�����Ĭ��ֵΪ100��
%        win_size Ĭ�ϴ��ڴ�С  ��Ĭ��ֵΪ7��
%Output: mask���루������ÿ��λ�ô����������.
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
    IsSaveVec = 1;
end
if nargin < 7
    IsCol = 1;
end
win_size = int32(win_size);
%imagefile = 'q_newTestPic copy.png';
im = imread(q_file);

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
im = imread(o_file);
%�������ʹ�õ���self-tuning����Ĵ������ı߽�
% %save([o_file '.mat'],'mask');
% %im_mask = display_clust_image_2(im,mask);
% toc
% fprintf('done.\n');
% figure;
% 
% imshow(im_mask);
%��������sobel���ӽ��б�Ե���
im_mask = edge(mask,'sobel');
figure;
imshow(im_mask);
print(gcf,'-depsc',[o_file '.eps']);
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
    %���������ڴ�,Ӧ���к������Ե��ã�����ط����ò���
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