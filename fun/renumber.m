function [assignment correct] = renumber(clabels,labels)

%**************��k-means�������еĿ���ȥ�����硾1 2 4����ɡ�1 2 3��
labelsnum = unique(clabels);
labels_num = unique(labels);
cc = zeros(length(clabels),1);
for i = 1:length(labelsnum)
    index = find(clabels == labelsnum(i));
    cc(index) = i;
end
%*********************************
L = perms(1:length(labelsnum)); % here c must be less than 15,n!��,ÿ����һ�ֿ��ܵ�����
L = labelsnum(L);
for i = 1:size(L,1)
    tmp = (L(i,:))';
    correct(i) = mean(tmp(cc) == labels);
end
[correct,index] = max(correct);
tmp = (L(index,:))';
assignment = tmp(cc);
% for i=1:c
%     index{i} = find(clabels==labelsnum(i));
% end
% for s = 1:size(L,1)
%  for t =1:c
%      clabels(index{t}) = L(s,t);
%  end
%  tempcorrect(s) = mean(labels==clabels);
% end
% [correct,ind] = max(tempcorrect);
% for t =1:c
%     clabels(index{t}) = L(ind,t);
% end
% assignment = clabels;