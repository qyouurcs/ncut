function mask = test_image_seg_para_rw_folder(folder,K,sample_num,win_size,steps,IsSaveVec)
% Input: folder: 要进行分割的文件夹
%        K      类的数目
%        sample_num 抽样点的个数（默认值为100）
%        win_size 默认窗口大小  （默认值为7）
%        steps，默认和win_size相等
%Output: mask掩码（包含了每个位置处所属的类别）.
debug = 0;
if nargin < 3
    sample_num = 100;
    win_size = 7;
end
if  nargin < 4
    win_size = 7;
end
if nargin < 5
    steps = win_size;
end
if nargin < 6
    IsSaveVec = 1;
end
win_size = int32(win_size);
%imagefile = 'q_newTestPic copy.png';
% 
% Initializes matlab paths to subfolders
% Timothee Cour, Stella Yu, Jianbo Shi, 2004.

addpath('./improved_nystrom');
addpath('./fun');
files = dir(folder);
for i=1:length(files)
    if ~files(i).isdir && strncmp(files(i).name,'o',1) %&& strcmp(files(i).name,'.') == 0  && strcmp(files(i).name,'..') == 0
        %addpath([cd '/' files(i).name]);
        q_file =[folder '/' files(i).name];
        o_file =[folder '/' files(i).name(3:length(files(i).name))];
        if ~(exist(q_file,'file') && exist(o_file,'file'))
            fprintf('file %s and file %s should appear in pair\n',q_file,o_file);
            continue;
        end
        fprintf('Seg pic %s\n',o_file);
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
        tao_dist = exp(1).^(-tao_dist);
        %clear tao_dist;
        %A = W(:,perm(1:sample_num));
        %B = W(:,perm((sample_num+1):pixles_num));
        A = tao_dist(:,1:sample_num);
        B = tao_dist(:,(sample_num+1):pixles_num);
        clear tao_dist;
        S_A = 1./(sum(A)+eps);%按照列求和
        N_A = A*diag(S_A);
        N_A = N_A^steps;
        fprintf('begin to execute nystrom extension\n');
        tic;
        B = N_A'*B;
        A = A*N_A;
        clear N_A;
        vec = Nystrom_2(A,B,K);
        clear A B;
        toc
        fprintf('done\n');

        fprintf('begin to execute k-means\n');
        tic;

        IDX = k_means(vec,[],K,100);
        %保存特征向量

        if debug == 1
            save tmp_vec.mat vec IDX;
        end
        toc
        fprintf('done\n');
        %mask = IDX(perm);
        mask = perm_transform(IDX,int32(perm));
  %      clear perm;
        mask = reshape(mask,rows,columns);
        fprintf('begin to display image\n');
        tic;
        im = imread(o_file);
        %save([o_file '.mat'],'mask');
        im_mask = display_clust_image_2(im,mask);
        toc
        fprintf('done.\n');
        %figure;
        %figure;
        %imshow(im_mask);
        print(gcf,'-depsc',[o_file '.eps']);
        clear im mask;        
        if IsSaveVec ~=0
            vec_o = perm_transform(vec,int32(perm));
            vec_o = abs(vec_o);
            for sd = 1:K
                imagesc(reshape(vec_o(:,sd),rows,columns));
                print(gcf,'-depsc',[ o_file  num2str(sd) 'vec' '.eps']);
            end
        end
    end
    close all;
end
end
