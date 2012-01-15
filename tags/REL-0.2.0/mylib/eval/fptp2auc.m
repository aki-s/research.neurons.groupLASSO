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

[M,dum] = size(FPTP);
FP = FPTP(:,1);
TP = FPTP(:,2);
AUC = 0;
for i=1:M-1   
  % calc area with trapezoid method
  AUC = AUC + ( TP(i+1) + TP(i) ) * ( FP(i+1) - FP(i) ) * 0.5;
end

%% TP 
%% / \      ....
%%  | ..........
%%  |...........
%%  |...........  |
%%  ---------------> FP
