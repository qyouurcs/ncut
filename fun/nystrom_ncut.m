function [V,ss]=nystrom_ncut(A,B)
% [V,ss]=nystrom_ncut(A,B);

Nsamples = size(A,1);
Nothers = size(B,2);
Npix = Nsamples + Nothers;

% compute total connection weight 
fprintf(1,'computing total connection weight...');
d1 = sum([A;B'],1);
d2 = sum(B,1) + sum(B',1)*inv(A)*B;
d = [d1 d2]';
disp('done.')

% normalize
fprintf(1,'normalizing...');
v = sqrt(1./d);
A = A.*(v(1:Nsamples)*v(1:Nsamples)');
B = B.*(v(1:Nsamples)*v(Nsamples+(1:Nothers))');
disp('done.')

% find eigenvectors via PCA/nystrom trick
fprintf(1,'computing eigenvectors...')
Asi=sqrtm(inv(A));
Q=A+Asi*B*B'*Asi;
[U,L,junk]=svd(Q);
V=[A;B']*Asi*U*inv(sqrt(L));
disp('done.')

%ss=diag(1-diag(L)); % convert to (D-W)x=lambda Dx form
ss = L;

end