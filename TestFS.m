%Times = 1;%实验的次数
%function [IDX,NMI,CR]=ScriptNystrom(datafile,group_num,sample_num,delta)
%datafile = './data/iris_data.mat';delta = 0.16;
%datafile = './data/three_circle.mat';delta = 0.06;
%datafile = './data/two_moon.mat';delta = 0.07;
%datafile = './data/17.mat';delta = 3.1;
%datafile = './data/wine.mat';delta = 0.055;step = 4;
%datafile = './data/wpdc.mat';delta = 0.04;step = 3;
%[IDX,NMI,CR] = ScriptNystromWithRandomSampling(datafile,ClusterNum,m,delta,0);
datafile = './data/smile.mat';delta = 0.06;
%datafile = './data/89.mat';delta = 3.1;
%datafile = './data/mnist_68.mat';delta = 2.7;step = 1;
%datafile='./data/08.mat';delta = 3;step = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ClusterNum = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_s = 80;
Times =10;
%load (datafile);
%[rows,cols] = size(dataset);
%%%%%%%%%%%%%%%%%%%%%%
%下面的方案用来提前计算整个相似度矩阵！小型的数据集可以将下面的语句注释掉！同时在调用Script。。。的时候最后一个参数传递为0或者空即可
%clear dis data dataset;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step =1;
%clear dataset;
%delta = 0.045;
fid = fopen('./result/iris_mul_A.txt','w+');
%for delta =0.1    
    for m =10:10:max_s%70:5:200%2005:5:200%5:5:150%208%10:5:max_s
        tic;
        fprintf(fid,'delta = %f, m = %d\n',delta,m);
        for i = 1:Times
%            perm = randperm(rows);
            tic;
            [IDX,NMI,CR] = ScriptNystromFS(datafile,ClusterNum,m,delta);
            t=toc;
            fprintf(fid,'%f\t%f\t%f\t',NMI,CR,t);
            fprintf('%f\t%f\t%f\t',NMI,CR,t);
            tic;
            [IDX,NMI,CR] = ScriptNystromWithRandomSampling(datafile,ClusterNum,m,delta);
            t = toc;
            fprintf(fid,'%f\t%f\t%f\n',NMI,CR,t);
            fprintf('%f\t%f\t%f\t',NMI,CR,t);
            fprintf('delta = %f, m = %d, i = %d\n',delta,m,i);
        end
        toc;
    end
%end
fclose(fid);