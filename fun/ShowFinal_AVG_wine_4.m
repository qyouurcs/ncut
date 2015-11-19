function ShowFinal_AVG_wine_4(Option,IsShowDataSet)
%参数是只显示NMI,或者是CR，或者是All
if nargin < 1
    Option = 'CR';
end
if nargin < 2
    IsShowDataSet = -1;
end
load Final_AVG_wine_4.mat;
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
x_axis = 5:5:100;
x_axis = x_axis/178;
xlabel_n  = 'Wine Dataset sample rate';
switch lower(Option)
    case 'nmi'
        
        plot(x_axis,result(:,1),'-go');
        hold on;
        plot(x_axis,result(:,3),'-r+');
        legend('SI','RandomSampling','location','best');
        xlabel(xlabel_n);
        ylabel('NMI value');
    case 'cr'
        plot(x_axis,result(:,2),'-go');
        hold on;
        plot(x_axis,result(:,4),'-r+');
        legend('SI','RandomSampling','location','Best');
        xlabel(xlabel_n);
        ylabel('CR value');
    otherwise
        plot(x_axis,result(:,1),'-bo');
        hold on;
        plot(x_axis,result(:,3),'-r+');
        plot(x_axis,result(:,2),'-kv');
        plot(x_axis,result(:,4),'--cs');
        legend('SI\_NMI','RandomSampling\_NMI','SI\_CR','RandomSampling\_CR','Location','Best');
        xlabel(xlabel_n);
        ylabel('Value');
end
end