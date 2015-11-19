function ShowSample(data,IDX,SamplePos,K)
%���룺
% data ���ݼ�
% IDX ���ݼ���Ӧ������
% SampleIDX���������Ӧ��λ��
% ������ĿK
colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
figure;
hold on;
axis equal;
axis([ 0 1 0 1]);
for i = 1:K
    plot(data(IDX==i,1),data(IDX==i,2),'.','Color',colors(i,:),'MarkerSize',7);
%    hold on;
end

plot(data(SamplePos,1),data(SamplePos,2),'.','Color',[0 0 0],'MarkerSize',8);
hold off;
end