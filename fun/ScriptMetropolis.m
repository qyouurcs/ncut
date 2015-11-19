function [IDX,NMI,CR]=ScriptMetropolis(datafile,group_num,m,delta,IsShowSample,Normalized)
%������
% datafile�����Ե������ļ������԰���·��)��
% group_num:������Ŀ��
% sample_num��������Ŀ��
% delta: ���Ƹ�˹�˺�����
% ShowSample:�����Ƿ���ʾ���������
% �����
% IDX����������ţ�
% NMI: ������ʵ�����������ݵĵ�һ�г��֣�
% CR:��ȷ��

%���ﲻ���Ǵ����˴����������̫�߳���

if nargin < 6
    Normalized = true;
end
load(datafile);
truelabel = dataset(:,1);%���ݼ�����һ��dataset�ı���������ŵ�
[rows cols] = size(dataset);
%neighbor_num = 15;
%colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
data = dataset(:,2:cols);
data = data - repmat(mean(data),size(data,1),1);
data = data/max(max(abs(data)));
%������������ݣ�
[sample_idx A] = metropolis(data,m,50*m,delta);
sample_ind = true(rows,1);
sample_ind(sample_idx) = false;
dist = dist2(data(sample_idx,:),data(sample_ind,:));
B = exp(-dist/(2*delta^2));
clear dist data_perm;
evec = Nystrom_Original(A,B,group_num,Normalized);
if Normalized == 0
IDX = k_means(evec(:,2:group_num),[],group_num,100);
else
    IDX = k_means(evec,[],group_num,100);
end
%����perm�ظ���ԭ��˳����Ǹ�IDX,�������C++д��
if IsShowSample ~= 0
    ShowSample(data,truelabel,perm(1:m),group_num);
end
IDX_p = IDX;
IDX_p(sample_idx) = IDX(1:m);
IDX_p(sample_ind) = IDX(m+1:end);
IDX = IDX_p;
%IDX = perm_transform(IDX,int32(perm));
if nargout >= 2 %����NMI
    NMI = nmi(truelabel,IDX);
end
if nargout >= 3
    lablesnum = unique(truelabel);
    IDX = lablesnum(IDX);
    [assignment CR] = renumber(IDX,truelabel);
end
end