function AUC = fptp2auc( FPTP )
% calculate AUC from FPTP%
% Input
% FPTP( 1:M, 1:2 )
% where FPTP( m, 1 ) denotes false positive rate in negative
% samples
% at the m-th threshold,
% and FPTP( m, 2 ) denotes true positive rate in positive samples%
% at the m-th threshold.
%


FPTP = [0,0;FPTP;1,1];
[M,dum] = size(FPTP);
FP = FPTP(:,1);
TP = FPTP(:,2);
AUC = 0;
for i=1:M-1   
  AUC = AUC + abs( FP(i+1)-FP(i) ) * TP(i+1);
end

