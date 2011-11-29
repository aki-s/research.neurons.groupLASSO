function [recn, recr, thresh0, auc] = evalRFIntensity( RFIntensity, Answer )

[cnum1,cnum2] = size(RFIntensity);
cnumMat = cnum1*cnum2;
thresh0 = sort(unique(abs(RFIntensity(:)))-eps);
thresh0 = [0,thresh0',thresh0(end)+eps];

N0 = sum( Answer == 0 );
Np = sum( Answer == 1 );
Nn = sum( Answer == -1 );
lenT0 = length(thresh0);
recn = zeros( lenT0, 4 ); % correct ans num
recr = recn; % correct ans rate
%% set FalsePositive and TruePositive based on +/- or 0
recFPTP = zeros( lenT0, 2);
for t1 = 1:lenT0
  thresh = thresh0( t1 );
  TP0 = sum( abs(RFIntensity) <= thresh & Answer == 0);
  FP0 = sum( abs(RFIntensity) <= thresh & Answer == 1);
  TPp = sum( RFIntensity > +thresh & Answer == 1);
  TPn = sum( RFIntensity < -thresh & Answer == -1);
  TPtotal = TP0 + TPp + TPn;
  %  (FalsePositive,TruePositive)= (1-specificity, sencitivity)
  %% if (Np+Nn) == 0 ?
  recFPTP( t1, : ) = [FP0/(Np+Nn), TP0/N0]; 
  %   fprintf(1,'%d _%d _%d %d _%d\n',FP0, Np, Nn, TP0,N0);
  recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
  recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/cnumMat];
end
recFPTP = [0,0;recFPTP;1,1];
[dum, idx] = max( recn(:,4) );

recn = recn(idx,:);
recr = recr(idx,:);
thresh0 = thresh0(idx);
%% AUC about no-connection
%
%%    |np              | 0
%%---------------------------------------
%% np |  sencitivity   |
%%---------------------------------------
%% 0  |          (FP0) | specificity (TP0)|
auc = fptp2auc( recFPTP );

if strcmp('DEBUG','DEBUG')
  %%  plot ROC curve
  fprintf(1,'DEBUG:%s\n',mfilename)
  figure
  plot(recFPTP(:,1),recFPTP(:,2))
  xlabel('FP')
  ylabel('TP')
  title('')
  set(gcf, 'Color', 'White', 'Position',[200,700,400,400])
end
