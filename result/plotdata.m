load three_circle.mat;
result = Time;
style = {'-b+','--cs','-gs','-ro','-cx','-bd','-g^','-bv','-c+','-go','-g+','-gv'};
figure;
% index = 1 : 8;
index = 1:size(Result, 1)
x_axis = result(index,1);
xlabel_n  = 'Number of Landmark Points';

% set (gcf,'Position',[100,100,600,400], 'color','w')
hold on;
plot(x_axis,result(index,2),'-bv','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,3),'-r+','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,5),'-go','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,4),'-cx','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,6),'-ms','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,7),'-*','Color',[0.1 0.5 0.7],'LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,8),'-kp','LineWidth',2.5,'MarkerSize',12);
plot(x_axis,result(index,9),'Color',[0.68 0.2 0.4],'LineWidth',2,'MarkerSize',12);
legend('IS','LS','KS','WS','RS','LSC','KASP','SC','location','best');
xlabel(xlabel_n);

ylabel('NMI value');
% ylabel('CPU time (seconds)');
set(gca,'Fontsize',15)
set(gca,'xtick',x_axis);
set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',15);
grid on;
axis tight;
set(gca,'box','on')
