function ShowDataSetWithSamples(datafile,K,gap,IDX,IDX_S)
%ShowDataSet(datafile,K,gap)
%
%datafile是数据文件
%K 是簇的个数
%gap是间隔
%IDX是真实的类标号
%IDX_S是抽样的数据点的类标号

    color = [0 1 0; 0 0 1; 1 0 0; 1 0.5 0.5; 0.5 0.5 1];
    load(datafile);    
    if nargin < 4
        IDX = dataset(:,1);
    end
    xmin = min(dataset(:,2));
    xmax = max(dataset(:,2));
    ymin = min(dataset(:,3));
    ymax = max(dataset(:,3));
    data = dataset(:,2:3);
%    IDX = dataset(:,1);
    figure;
    hold on;
    for i = 1:K
        plot(dataset(IDX==i,2),dataset(IDX==i,3),'.','color',color(i,:));
    end
    plot(data(IDX_S,1),data(IDX_S,2),'.','Color',[0 0 0],'MarkerSize',8);
    hold off;
    set(gca,'XTick',[xmin:gap:xmax]);
    set(gca,'YTick',[ymin:gap:ymax]);
    axis([xmin xmax ymin ymax]);
    axis equal;
    grid on;
    drawnow;

end