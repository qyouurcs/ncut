function n2 = dist2_mod(x, c, x_sq, c_sq)
%DIST2	Calculates squared distance between two sets of points.
%
%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.
%   D(i,j) = norm(X(i,:)-C(j,:)).^2;
%
%	See also
%	GMMACTIV, KMEANS, RBFFWD
%

%	Copyright (c) Christopher M Bishop, Ian T Nabney (1996, 1997)

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end
if nargin < 3
n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  		ones(ndata, 1) * sum((c.^2)',1) - ...
  		2.*(x*(c'));
    return;
end
if nargin < 4
    n2 = (ones(ncentres, 1) * sum(x_sq', 1))' + ...
  		ones(ndata, 1) * sum((c.^2)',1) - ...
  		2.*(x*(c'));
    return;
end
n2 = (ones(ncentres, 1) * sum((x_sq)', 1))' + ...
  		ones(ndata, 1) * sum((c_sq)',1) - ...
  		2.*(x*(c'));
end