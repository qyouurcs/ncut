function y = PCA(x,n_y)
%x 数据
%n_y是要降的维数
%中心化数据
x_mean = mean(x);
rows = size(x,1);
x = x-repmat(x_mean,rows,1);
C = x'*x;
[v s u] = svd(C);
v = v(:,1:n_y);
y = x*v;
end