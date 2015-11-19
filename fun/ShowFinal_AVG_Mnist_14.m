function ShowFinal_AVG_Mnist_14(Option,IsShowDataSet)
%参数是只显示NMI,或者是CR，或者是All
if nargin < 1
    Option = 'all';
end
if nargin < 2
    IsShowDataSet = -1;
end
for i = 1:3
    result = ['Final_AVG_mnist_14_' num2str(i) '.mat'];
    load(result);
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
    x_axis = 5:5:200;
    %x_axis = x_axis/500;
    xlabel_n  = 'sample rate';
    if IsShowDataSet > 0
        subplot(1,2,2);
    end
    switch lower(Option)
        case 'nmi'
            plot(x_axis,result(:,1),'-go');
            hold on;
            plot(x_axis,result(:,4),'-r+');
            legend('RW','RandomSampling','location','best');
            xlabel(xlabel_n);
            ylabel('NMI value');
        case 'cr'
            plot(x_axis,result(:,2),'-go');
            hold on;
            plot(x_axis,result(:,5),'-r+');
            legend('RW','RandomSampling','location','Best');
            xlabel(xlabel_n);
            ylabel('CR value');
        otherwise
            plot(x_axis,result(:,1),'-bo');
            hold on;
            plot(x_axis,result(:,4),'-r+');
            plot(x_axis,result(:,2),'-gv');
            plot(x_axis,result(:,5),'--cs');
            legend('RW\_NMI','RandomSampling\_NMI','RW\_CR','RandomSampling\_CR','Location','Best');
            xlabel(xlabel_n);
            ylabel('Value');
    end
    title('total points 11769');
end
end