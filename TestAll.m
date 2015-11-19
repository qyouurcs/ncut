%加入路径
clear
clc
addpath('./improved nystrom');
addpath('./fun');

%Times = 1;%实验的次数
% function [IDX,NMI,CR]=ScriptNystrom(datafile,group_num,sample_num,delta)
%datafile = './dataset/small/iris_data.mat';delta = 0.26;ClusterNum = 3; Times = 50; i_begin = 10;max_s = 40;step = 2;resultfile = './result/2015_10_iris_data.txt';Normalized = 0;
%datafile = './dataset/small/wine.mat';delta = 0.055;i_begin = 5;ClusterNum = 3;Times = 50;max_s = 30; step = 2; resultfile = './result/2015_10_wine.txt';Normalized = 0;
% datafile = './dataset/small/glass.mat';delta = 0.4;i_begin = 10;ClusterNum = 6;max_s = 46;Times = 50;step = 4; resultfile = './result/2015_10_glass.txt';Normalized = 0;
% datafile = './dataset/small/ecoli.mat';delta = 0.46;i_begin = 10;ClusterNum =8;max_s = 100;Times = 50;step = 5; resultfile = './result/2015_10_ecoli.txt'; Normalized = 0;
% datafile = './dataset/small/seeds.mat';delta = 0.8;i_begin = 4;step = 2;ClusterNum = 3;Times = 50;max_s = 20;resultfile = './result/2015_10_seeds_1.txt';Normalized = 0;
% datafile = './dataset/small/monks.mat';delta = 0.8;i_begin = 6;step = 3;ClusterNum = 3;Times = 50;max_s = 30;resultfile = './result/2015_10_monks.txt';Normalized = 0;

%  datafile = './dataset/large/mnist_test.mat';delta = 0.4; ClusterNum = 10; Times = 50;i_begin = 30; max_s = 90; step = 10; resultfile = './result/2015_10_mnist_test.txt';Normalized = 1;
%  datafile = './dataset/large/a7a.mat';delta = 3; ClusterNum = 2; Times = 50;i_begin = 10; step = 10; max_s = 100; resultfile = './result/2015_10_a7a.txt';Normalized = 0;
%datafile = './dataset/large/aloi.mat'; delta = 3.1; ClusterNum = 1000; Times = 20;i_begin = 1100; max_s = 2000; step = 100; resultfile = './result/2015_10_aloi.txt';Normalized = 1;
%datafile = './dataset/large/satimage.mat'; delta = 2.9; i_begin = 30; ClusterNum = 6; Times = 50; max_s = 120; step = 10; resultfile = './result/2015_10_satimage.txt';Normalized = 1; %deta =1.7|1.8|1.9;
%  datafile = './dataset/large/segmentation.mat'; delta = 1.9; i_begin = 30; ClusterNum = 7; Times = 50; max_s = 90; step = 10; resultfile = './result/2015_10_segmentation.txt';Normalized = 1; %deta =1.7|1.8|1.9;
% datafile = './dataset/large/shuttle_test.mat';delta = 0.4; ClusterNum = 7; Times = 50;i_begin = 30; max_s = 200; step = 10; resultfile = './result/2015_10_shuttle_test.txt';Normalized = 1;
%  datafile = './dataset/large/poker-hand-training.mat';delta = 0.4; ClusterNum = 10; Times = 50;i_begin = 30; max_s = 90; step = 10; resultfile = './result/2015_10_poker-hand-training.txt';Normalized = 1;
%datafile = './dataset/large/TDT2_all.mat';delta = 0.4; ClusterNum = 96; Times = 50;i_begin = 30; max_s = 90; step = 10; resultfile = './result/2015_10_TDT2_all.txt';Normalized = 1;
%   datafile = './dataset/large/covtype.mat';delta = 0.6; ClusterNum = 7; Times = 20;i_begin = 30; max_s = 90; step = 10; resultfile = './result/2015_10_covtype.txt';Normalized = 1;
%   datafile = './dataset/large/pendigits.mat';delta = 1.15; ClusterNum = 10; Times = 20;i_begin = 20; max_s = 100; step = 5; resultfile = './result/2015_10_pendigits.txt';Normalized = 0;
%  datafile = './dataset/large/SensIT-Vehicle-combined.mat';delta = 0.4; ClusterNum = 3; Times = 50;i_begin = 30; max_s = 90; step = 10; resultfile = './result/2015_10_SensIT-Vehicle-combined.txt';Normalized = 1;
%  datafile = './dataset/large/letter_all.mat';delta = 1.15; ClusterNum = 26; Times = 20;i_begin = 30; max_s = 150; step = 20; resultfile = './result/2015_10_letter.txt';Normalized = 0;
%  datafile = './dataset/large/ijcnn1.mat';delta = 0.9; ClusterNum = 2; Times = 50;i_begin = 30; max_s = 150; step = 10; resultfile = './result/2015_10_ijcnn1.txt';Normalized = 1;

%datafile = './data/358.mat';delta =2.6;%后来添加的不知道参数怎么样
%datafile = './dataset/synthetic/three_circle.mat';i_begin = 6;delta = 0.1;ClusterNum =3; Times = 50;max_s = 60; step = 6; resultfile = './result/2014_4_2_three_circle.txt';Normalized = 0;
%datafile = './dataset/synthetic/smile.mat';delta = 0.06;i_begin = 6;ClusterNum = 3;max_s = 24;Times = 50;step = 4;resultfile = './result/2011_4_2_smile.txt';Normalized = 1;
datafile = './dataset/synthetic/circle_points.mat';delta = 0.06;i_begin = 10;ClusterNum = 3;max_s = 60;Times = 50;step = 5; resultfile = './result/2011_4_circle_points2.txt';Normalized = 1;
%datafile = './data/two_moons.mat';delta = 0.07; i_begin = 5;ClusterNum = 2; Times = 50; max_s = 60; step = 5; resultfile = './result/2014_4_2_two_moon.txt';Normalized = 1;
%datafile = './data/17.mat';delta = 3.1;i_begin = 5; Times = 50;ClusterNum = 2;max_s = 40;step = 5;resultfile = './result/17.txt';
%datafile = './data/wpdc.mat';delta = 0.1;i_begin = 6;step = 3;ClusterNum = 2;Times = 50;max_s = 30;resultfile = './result/2011_4_2_wpdc2.txt';Normalized = 1;
%datafile = './data/wpdc.mat';delta = 0.1;i_begin = 6;step = 3;ClusterNum =2;Times = 50;max_s = 30;resultfile = './result/2011_4_2_wpdc2.txt';Normalized = 1;
%datafile = './data/89.mat';delta = 3.1;
%datafile = './data/mnist_68.mat';delta = 2.7;step = 1;
%datafile='./data/08.mat';delta = 3;step = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ClusterNum = 3;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max_s = 60;
% Times =50;
% step =5;
% resultfile = './result/iris.txt';
%load (datafile);
%[rows,cols] = size(dataset);
%%%%%%%%%%%%%%%%%%%%%%
%下面的方案用来提前计算整个相似度矩阵！小型的数据集可以将下面的语句注释掉！同时在调用Script。。。的时候最后一个参数传递为0或者空即可
%clear dis data dataset;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear dataset;
%delta = 0.045;

fid = fopen(resultfile,'w+');
%for delta =0.05:0.01:0.1
Result = [];
Time = [];
% m = 50;
for m =i_begin:step:max_s%2005:5:200%5:5:150%208%10:5:max_s
%  for delta =0.5:0.5:3%2005:5:200%5:5:150%208%10:5:max_s
    tic;
    fprintf(fid,'delta = %f, m = %d\n',delta,m);
    R = [];
    T = [];
    for i = 1:Times
        fprintf('delta = %f, m = %d, i = %d\n',delta,m,i);
        tic;
        [~, NMI] = ScriptNystromIS(datafile,ClusterNum,m,delta,Normalized);
        t = toc;
        fprintf(fid,'%f\t%f\t',NMI,t);
        R(1, i) = NMI;
        T(1, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
        tic;
        [~, NMI] = ScriptNystromLS(datafile,ClusterNum,m,delta,Normalized);
        t = toc;
        fprintf(fid,'%f\t%f\t',NMI,t);
        R(2, i) = NMI;
        T(2, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
        tic;
        [~, NMI] = ScriptNystromKmeans(datafile,ClusterNum,m,delta,Normalized);
        t=toc;
        fprintf(fid,'%f\t%f\t',NMI,t);
        R(4, i) = NMI;
        T(4, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
        tic;
        [~, NMI] = ScriptMetropolis(datafile,ClusterNum,m,delta,0,Normalized);
        t = toc;
        fprintf(fid,'%f\t%f\t',NMI,t);
        R(3, i) = NMI;
        T(3, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
        tic;
        [~, NMI] = ScriptNystromWithRandomSampling(datafile,ClusterNum,m,delta,Normalized);
        t = toc;
        fprintf(fid,'%f\t%f\n',NMI,t);
        R(5, i) = NMI;
        T(5, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
        tic;
        opts.p = m;
        opts.mode = 'random';
        [NMI] = LSC(datafile,ClusterNum,opts);
        t = toc;
        fprintf(fid,'%f\t%f\n',NMI,t);
        R(6, i) = NMI;
        T(6, i) = t;
        %             fprintf('%f\t%f\t%f\t',NMI,CR,t);
%         tic;
%         [NMI] = KASP(datafile,ClusterNum, m, delta);
%         t = toc;
%         fprintf(fid,'%f\t%f\n',NMI,t);
%         R(7, i) = NMI;
%         T(7, i) = t;
    end
    toc;
    Result = [Result; m mean(R, 2)']
    Time = [Time; m mean(T, 2)'];
%     Result = [Result; delta mean(R, 2)']
%     Time = [Time; delta mean(T, 2)'];
    save .\result\circle_points Result Time
end
%end
tic;
[~, NMI] = spectral_clustering(datafile, delta);
t = toc;
fprintf(fid,'%f\t%f\n',NMI,t);
Result = [Result ones(size(Result, 1),1)*NMI];
Time = [Time ones(size(Time, 1),1)*t];
save .\result\circle_points Result Time
fclose(fid);