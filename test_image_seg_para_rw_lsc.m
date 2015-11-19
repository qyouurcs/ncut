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
        clear im;
        [rows columns] = size(im_gray);
        pixles_num = numel(im_gray);
        perm = randperm(pixles_num);

        sample_posB = int32(ones(pixles_num,2));
        for i = 1:pixles_num
            sample_posB(i,1) = int32(mod(perm(i),rows));
            sample_posB(i,2) = int32(floor((perm(i)-1)/rows));
        end
        sample_posA = int32(sample_posB(1:sample_num,:)); % same with the indSmp
        color_board = unique(sort(im_gray));
        fprintf('begin to compute tao_distance\n');
        tic;
        tao_dist = tao_distance_3(im_gray,sample_posA,sample_posB,win_size,color_board);
        clear sample_posA sample_posB;
		
		D = tao_dist';
		
		clear tao_dist;
        fprintf('done');
        toc
        fprintf('\n');
		% copy from the LSC.m file
        %sigma = mean(mean(D));
		nSmp=pixles_num;
		r = 5;
		p = sample_num;
		dump = zeros(nSmp,r);
		idx = dump;
		for i = 1:r
			[dump(:,i),idx(:,i)] = min(D,[],2);
			temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
			D(temp) = 1e100; 
		end

		%dump = exp(-dump/(2*sigma^2));
		dump = exp(1).^(-dump);
        dump = exp(-dump);
		sumD = sum(dump,2);
		Gsdx = bsxfun(@rdivide,dump,sumD);
		Gidx = repmat([1:nSmp]',1,r);
		Gjdx = idx;
		Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,p);

		% Graph decomposition
		feaSum = full(sqrt(sum(Z,1)));
		feaSum = max(feaSum, 1e-12);
		Z = Z./feaSum(ones(size(Z,1),1),:);
		k = K;
		U = mySVD(Z,k+1);
		U(:,1) = [];

		U=U./repmat(sqrt(sum(U.^2,2)),1,k);
		vec = U;

        IDX = k_means(vec,[],K,100);

        if debug == 1
            save tmp_vec.mat vec IDX;
        end
        toc
        fprintf('done\n');
        %mask = IDX(perm);
        mask = perm_transform(IDX,int32(perm));
        mask = reshape(mask,rows,columns);
        fprintf('begin to display image\n');
        tic;
        im = imread(o_file);
        %save([o_file '.mat'],'mask');
        im_mask = edge(mask,'sobel');
        %figure;
        %imshow(im_mask);
        [~,bn,~] = fileparts(o_file);
        save_fn = fullfile(save_dir, [bn '.bmp']);
        %im_mask = display_clust_image_2(im,mask, -1);
        %save_fn = fullfile(save_dir, [bn '.bmp']);
        imwrite(im_mask, save_fn);
    end
    close all;
    if nargout < 1
        clear mask;
    end
end
end
