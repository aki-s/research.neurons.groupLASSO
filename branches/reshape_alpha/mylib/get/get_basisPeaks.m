function [idx val] = get_basisPeaks(pureBasis)

[val idx] = max( pureBasis,[],1);
idx = unique(idx);

