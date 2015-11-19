function ShowResult(Option,IsShowDataSet)
%参数是只显示NMI,或者是CR，或者是All
if nargin < 1
    Option = 'CR';
end
if nargin < 2
    IsShowDataSet = -1;
end
load ecoli.txt;
result = ecoli;
style = {'-b+','--cs','-gs','-ro','-cx','-bd','-g^','-bv','-c+','-go','-g+','-gv'};
figure;

% if IsShowDataSet > 0
%    subplot(1,2,1);
%    load('../data/two_moon.mat');
%    label = dataset(:,1);
%    plot(dataset(label ==1,2),dataset(label==1,3),'.r');
%    hold on;
%    plot(dataset(label ==2,2),dataset(label==2,3),'.g');
% 
% end
x_axis = 10:5:100;
%x_axis = x_axis/500;
xlabel_n  = 'Number of Sample Points';
if IsShowDataSet > 0
    subplot(1,2,2);
end
switch lower(Option)
    case 'nmi'
        plot(x_axis,result(:,1),'-go','LineWidth',2,'MarkerSize',10);
        hold on;
        plot(x_axis,result(:,4),'-r+','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,7),'-cx','LineWidth',2,'MarkerSize',10);
        legend('FS\_Sampling','k-means','Random','location','best');
        xlabel(xlabel_n);
        
        ylabel('NMI value');
    case 'cr'
        plot(x_axis,result(:,2),'-go','LineWidth',2,'MarkerSize',10);
        hold on;
        plot(x_axis,result(:,5),'-r+','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,8),'-cx','LineWidth',2,'MarkerSize',10);
        legend('FS\_Sampling','k-means','Random','location','best');
        xlabel(xlabel_n);
        ylabel('Correct Rate');
    otherwise
        plot(x_axis,result(:,1),'-bo','LineWidth',2,'MarkerSize',10);
        hold on;
        plot(x_axis,result(:,4),'-r+','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,7),'-cx','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,2),'--gv','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,5),'--ro','LineWidth',2,'MarkerSize',10);
        plot(x_axis,result(:,8),'--cd','LineWidth',2,'MarkerSize',10);
        legend('FS\_NMI','k-means\_NMI','Random\_NMI','FS\_CR','k-means\_CR','Random\_CR','Location','Best');
        xlabel(xlabel_n);
        
        ylabel('Value');
end
set(gca,'xtick',x_axis);
grid on;
title('data set ecoli');
end