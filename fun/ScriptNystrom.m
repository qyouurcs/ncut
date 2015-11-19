function [IDX,NMI,CR]=ScriptNystrom(datafile,group_num,m,delta,IsShowSample)
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
load(datafile);
truelabel = dataset(:,1);%���ݼ�����һ��dataset�ı���������ŵ�
[rows cols] = size(dataset);
%neighbor_num = 15;
%colors = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
data = dataset(:,2:cols);

%������������ݣ�
perm = sample_according_to_row_sum(data,m,delta);
data_perm = data(int32(perm),:);
data_sample = data_perm(1:m,:);
dist = pdist(data_sample,'euclidean');
dist = squareform(dist);
A = exp(-dist/(2*delta^2));
dist = dist2(data_perm(1:m,:),data_perm((m+1):rows,:));
B = exp(-dist/(2*delta^2));
clear dist data_perm;
evec = Nystrom_Original(A,B,group_num);
IDX = k_means(evec,[],group_num,100);
%����perm�ظ���ԭ��˳����Ǹ�IDX,�������C++д��
if IsShowSample ~= 0
    ShowSample(data,truelabel,perm(1:m),group_num);
end
IDX = perm_transform(IDX,int32(perm));
if nargout >= 2 %����NMI
    NMI = nmi(truelabel,IDX);
end
if nargout >= 3
    lablesnum = unique(truelabel);
    IDX = lablesnum(IDX);
    [assignment CR] = renumber(IDX,truelabel);
end
end