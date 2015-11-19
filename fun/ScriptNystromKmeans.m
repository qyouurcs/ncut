function [IDX NMI CR] = ScriptNystromKmeans(datafile,group_num,m,delta,Normalized)
%function[IDX,NMI,CR]=ScriptNystromSI(datafile,group_num,m,delta,IsShowSample)
%������
% datafile�����Ե������ļ������԰���·��)��
% group_num:������Ŀ��
% m��������Ŀ��
% noise: ������ĸ���
% delta: ���Ƹ�˹�˺�����

% �����
% IDX����������ţ�
% NMI: ������ʵ�����������ݵĵ�һ�г��֣�
% CR:��ȷ��
if nargin < 5
    Normalized = 0;
end
DEBUG_MATLAB = -1;
load(datafile);
truelabel = dataset(:,1);
[rows cols] = size(dataset);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ǵ����ſ��Ĵ�����ô��Ҫ�õ���������д��룬���������Ļ���Ч���ܲ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%kernel = struct('type', 'rbf', 'para', delta); % construct the kernel
%V = INys_SpectrEmbed(data, kernel, m);
%IDX = k_means(V(:,2:group_num),[],group_num,100);

[idx, center, m] = eff_kmeans(data, m, 10);
dist = dist2(center,center);%'euclidean');
%dist = squareform(dist);
A = exp(-dist/(2*delta^2));
dist = dist2(center,data);
B = exp(-dist/(2*delta^2));
clear dist ;

evec = Nystrom_Original(A,B,group_num,Normalized);
evec = evec((m+1):end,:);
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end
if DEBUG_MATLAB > 0
    plot(evec(:,1),evec(:,2),'.');
    axis equal;
    grid on;
end
if nargout >= 2 %����NMI
    NMI = nmi(truelabel,IDX);
end
if nargout >= 3
%     lablesnum = unique(truelabel);
%     IDX = lablesnum(IDX);
%     [assignment CR] = renumber(IDX,truelabel);
CR = accuracy(truelabel,IDX)/100;
end
end
