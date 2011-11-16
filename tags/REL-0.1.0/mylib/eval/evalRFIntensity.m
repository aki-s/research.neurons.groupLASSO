function [recn, recr, thresh0, auc] = evalRFIntensity( RFIntensity, Answer )
[N,dum] = size(RFIntensity);

%% Omit diagonal elements
idx = ~logical(eye(N));
RFIntensity = RFIntensity( idx );
Answer = Answer( idx );
switch 'V3'
   case 'V1'
   tmp = std( abs( RFIntensity(:) ) );
   thresh0 = tmp * (1:1000)/100;
   case 'V2'
   tmp = [min(abs(RFIntensity(:))), max(abs(RFIntensity(:)))]
   thresh0 = tmp(1):( (tmp(2)-tmp(1))/1000 ):tmp(2);
   case 'V3'
     %   thresh0 = sort(abs(RFIntensity(:))-eps);% there may be duplicate
   thresh0 = sort(unique(abs(RFIntensity(:)))-eps);
   thresh0 = [-Inf,thresh0',Inf];
end
N0 = sum( Answer == 0 );
Np = sum( Answer == 1 );
Nn = sum( Answer == -1 );
recn = zeros( length(thresh0), 4 ); % correct ans num
recr = recn; % correct ans rate
lenT0 = length(thresh0);
%% set FalsePositive and TruePositive based on +/- or 0
recFPTP = zeros( lenT0, 2);
for t1 = 1:lenT0
   thresh = thresh0( t1 );
   TP0 = sum( abs(RFIntensity) < thresh & Answer == 0);
   FP0 = sum( abs(RFIntensity) < thresh & Answer == 1);
   TPp = sum( RFIntensity > thresh & Answer == 1);
   TPn = sum( RFIntensity < thresh & Answer == -1);
   TPtotal = TP0 + TPp + TPn;
   %  (FalsePositive,TruePositive)= (1-specificity, sencitivity)
   recFPTP( t1, : ) = [FP0/(Np+Nn), TP0/N0]; 
   % fprintf(1,'%d',FP0/(Np+Nn), TP0/N0);
   recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
   recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(RFIntensity)];
end
recFPTP = [0,0;recFPTP;1,1];
[dum, idx] = max( recn(:,4) );

recn = recn(idx,:);
recr = recr(idx,:);

%% AUC about no-connection
%
%%    |np             | 0
%%---------------------------------------
%% np | specificity   |
%%---------------------------------------
%% 0  |          (FP0)| sencitivity (TP0)|
auc = fptp2auc( recFPTP );

if strcmp('DEBUG','DEBUG_')
  %%  plot ROC curve
  fprintf(1,'DEBUG:%s\n',mfilename)
  figure
  plot(recFPTP(:,1),recFPTP(:,2))
  xlabel('FP')
  ylabel('TP')
  title('')
  set(gcf, 'Color', 'White', 'Position',[200,700,400,400])
end
