function [recn, recr, thresh0, auc] = evalRFIntensity( RFIntensity, Answer )
%% make 1 column matrix
RFIntensity = RFIntensity(:);
Answer      = Answer(:);
%%
DEBUG = 0;
%%
cnumMat = size(RFIntensity,1);
if 1== 1 %% fast
%%++bug?: this sort of threshold decision cause different AUC and
%%'threshold0' for the same correct rate (recr)?
%% get maximum threshold0?
thresh0 = sort(unique(abs(RFIntensity(:)))+eps)';
thresh0 = [0;thresh0'];
%thresh0 = [0;thresh0(1)-eps;thresh0'];
else%% though this is a bit slow
%% get minimum threshold0?
threshM = max(abs(RFIntensity(:)));
thresh0 = (0:0.001:threshM)';
end

N0 = sum( Answer ==  0 );
Np = sum( Answer == +1 );
Nn = sum( Answer == -1 );
lenT0 = length(thresh0);
recn = zeros( lenT0, 4 ); % correct ans num
recr = recn; % correct ans rate
%% set FalsePositive and TruePositive based on +/- or 0
recFPTP = zeros( lenT0, 2);
for t1 = 1:lenT0
  thresh = thresh0( t1 );
  TP0 = sum( abs(RFIntensity) <= thresh & Answer == 0);
  FP0 = sum( abs(RFIntensity) <= thresh & Answer ~= 0);
  TPp = sum( RFIntensity > +thresh & Answer == +1);
  TPn = sum( RFIntensity < -thresh & Answer == -1);
  TPtotal = TP0 + TPp + TPn;
  %  (FalsePositive,TruePositive)= (1-specificity, sencitivity)
  %% if (Np+Nn) == 0 ?
  recFPTP( t1, : ) = [FP0/(Np+Nn), TP0/N0];
  %   fprintf(1,'%d _%d _%d %d _%d\n',FP0, Np, Nn, TP0,N0)
  recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
  recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/cnumMat];
end

if DEBUG > 0 
  fprintf(1,'%s DEBUG:%s %s\n',repmat('=',[1 30]), mfilename, repmat('=',[1 30]) )
  fprintf(1,'idx: 0 +1 -1 Total: FP0 TP0: threshold\n')
cat(2,(1:lenT0)', recr, recFPTP, thresh0)
end

%% AUC about no-connection
%
%%    |np              | 0
%%---------------------------------------
%% np |  sencitivity   |
%%---------------------------------------
%% 0  |          (FP0) | specificity (TP0)|
recFPTP = [0,0;recFPTP;1,1];
auc = fptp2auc( recFPTP );
[dum, idx] = max( recn(:,4) );

if DEBUG > 0 
  %%  plot ROC curve
  figure
  plot(recFPTP(:,1),recFPTP(:,2))
  xlabel('FP0')
  ylabel('TP0')
  title(sprintf('idx:%d %5f<=thresh<%f-eps',idx,thresh0(idx),thresh0(idx+1)))
  set(gcf, 'Color', 'White', 'Position',[200,700,400,400])
end

recn = recn(idx,:);
recr = recr(idx,:);
thresh0 = thresh0(idx);
