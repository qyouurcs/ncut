function [IDX NMI CR] = ScriptNystromIS(datafile,group_num,m,delta,Normalized)
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
dataset = 0;
load(datafile);
truelabel = dataset(:,1);
[rows cols] = size(dataset);
perm = randperm(rows);

data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
%�������ѡ���������ݵ㣬Ȼ��ʣ�µ����ݵ㰴��(������С)��ԭ��ѡ��
sample_idx = perm(1:2);
sample_all = true(rows,1);
sample_all(sample_idx) = false;
dist_un = dist2(data(sample_idx,:),data(sample_all,:));
B = exp(-dist_un/(2*delta^2));
for i = 3:m
    var_b = var(B);
    [val,idx] = min(var_b);
    idx_t = 0;
    for j = 1:rows
        if(sample_all(j))
            idx_t = idx_t + 1;
        end
        if idx_t == idx
            break;
        end
    end
    sample_idx(i) = j;
    sample_all(j) = false;
    B(:,idx) = [];
    B(end+1,:) = exp(-(dist2(data(j,:),data(sample_all,:)))/(2*delta^2));
end

dist = dist2(data(sample_idx,:),data(sample_idx,:));%'euclidean');
%dist = squareform(dist);
A = exp(-dist/(2*delta^2));
clear dist ;
evec = Nystrom_Original(A,B,group_num,Normalized);
if DEBUG_MATLAB > 0
    figure;
   % plot(evec(:,1),evec(:,2),'.');
    plot(dataset(:,2),dataset(:,3),'r.');
    hold on;
    plot(dataset(idx_noise,2),dataset(idx_noise,3),'b.');
    axis equal;
    grid on;
end
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end
%ͬʱҲ��Ҫ�޸�truelabel��ֵ
IDX_p(sample_idx) = IDX(1:m);
IDX_p(sample_all) = IDX(m+1:rows);
clear IDX;
IDX = IDX_p;
if nargout >= 2 %����NMI
    NMI = nmi(truelabel,IDX_p');
end
if nargout >= 3
    lablesnum = unique(truelabel);
    IDX_p = lablesnum(IDX_p);
    [assignment CR] = renumber(IDX_p,truelabel);
end
end
