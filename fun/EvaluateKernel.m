function G = EvaluateKernel(dataset,I,delta)
%������dataset:���ݼ�
%      I �������ݵ��index
%�����G
dist = dist2(dataset(I,:),dataset(I,:));
G = exp(-dist/(2*delta^2));
end