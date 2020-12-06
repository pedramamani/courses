function pxn = barycentric(xn, fn, xm)
N = size(xn, 2);
M = size(xm, 2);

xnMat = repmat(xn', 1, M);
fnMat = repmat(fn', 1, M);
wnMat = repmat(weights(xn)', 1, M);
xmMat = repmat(xm, N, 1);

denom = wnMat ./ (xmMat - xnMat);
numer = denom .* fnMat;
pxn = sum(numer, 1) ./ sum(denom, 1);
end


function wn = weights(xn)
N = size(xn, 2);
xnMat = repmat(xn, N, 1);
wnMat = xnMat - xnMat' + eye(N);
wn = 1 ./ prod(wnMat, 1);
end