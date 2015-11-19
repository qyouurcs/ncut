data = normrnd(0,1,500,3); % a toy data example;
b = stdv(data); % average distance (between data points and the center)
kernel = struct('type', 'rbf', 'para', b); % construct the kernel
m = 10; % number of landmark points

% kernel PCA
V = INys_KPCA(data, kernel, m); 
figure, plot(V(:,1),V(:,2),'b.');

% sepctral embedding
V = INys_SpectrEmbed(data, kernel, m);
figure, plot(V(:,2),V(:,3),'b.');
 
% multidimensional scaling
V = INys_MDS(data, m); 
figure, plot(V(:,1),V(:,2),'b.');