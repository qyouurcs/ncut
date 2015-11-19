function mask = test_image_seg_para_rw_lsc(folder,K,sample_num,win_size,steps,IsSaveVec)

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
mode = 'kmeans';
save_dir = 'LSC_SEG';
if ~isdir(save_dir)
    mkdir(save_dir);
end
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
        %im = imread(q_file);
        [im, map] = imread(q_file);
        im = ind2rgb(im, map);
        im_gray = rgb2gray(im);
        im_gray = im2uint8(im_gray);
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
        sample_idx = perm(1);
        sample_all = true(pixles_num,1);
        sample_all(sample_idx) = false;
        tao_dist = tao_distance_3(im_gray,sample_posB(sample_idx, :),sample_posB(sample_all, :),win_size,color_board);
        B = exp(1).^(-tao_dist);
        for i = 2:sample_num
            var_b = var(B);
            [val,idx] = min(var_b);
            if i == 2
                [~, idx] = min(B);
            else
                iidx = max(B);
                [~, idx] = min(iidx);
            end
            j = idx;
            sample_idx(i) = j;
            sample_all(j) = false;
            B(:,idx) = [];
            tao_dist = tao_distance_3(im_gray,sample_posB(j, :),sample_posB(sample_all, :),win_size,color_board);
            B(end+1,:) = exp(1).^(-tao_dist);
        end
        tao_dist = tao_distance_3(im_gray,sample_posB(sample_idx, :),sample_posB(sample_idx, :),win_size,color_board);
        A = exp(1).^(-tao_dist);
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
        im_mask = edge(mask,'sobel');
    end
    close all;
    if nargout < 1
        clear mask;
    end
end
end
