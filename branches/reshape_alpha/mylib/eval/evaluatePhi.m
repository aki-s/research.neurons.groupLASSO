function [recn, recr, thresh0, auc] = evaluatePhi( Phi, Answer )
[N,dum] = size(Phi);

% Omit diagonal elements
Phi = Phi + eye(N)*1e100;
idx = find( Phi(:) < 1e90 );
Phi = Phi( idx );
Answer = Answer( idx );
switch 'V3'
   case 'V1'
   tmp = std( abs( Phi(:) ) );
   thresh0 = tmp * (1:1000)/100;
   case 'V2'
   tmp = [min(abs(Phi(:))), max(abs(Phi(:)))]
   thresh0 = tmp(1):( (tmp(2)-tmp(1))/1000 ):tmp(2);
   case 'V3'
   thresh0 = sort(abs(Phi(:))-eps);
   thresh0 = [-Inf,thresh0',Inf];
end
N0 = sum( Answer == 0 );
Np = sum( Answer == 1 );
Nn = sum( Answer == -1 );
recn = zeros( length(thresh0), 4 );
recr = recn;
for t1 = 1:length(thresh0)
   thresh = thresh0( t1 );
   TP0 = sum( abs(Phi) < thresh & Answer == 0);
   FP0 = sum( abs(Phi) < thresh & Answer == 1);
   TPp = sum( Phi > thresh & Answer == 1);
   TPn = sum( Phi < thresh & Answer == -1);
   TPtotal = TP0 + TPp + TPn;
   %  (FalsePositive,TruePositive)= (1-specificity, sencitivity)
   recFPTP( t1, : ) = [FP0/(Np+Nn), TP0/N0]; 
   % fprintf(1,'%d',FP0/(Np+Nn), TP0/N0);
   recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
   recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(Phi)];
end
[dum, idx] = max( recn(:,4) );

recn = recn(idx,:);
recr = recr(idx,:);

auc = fptp2auc( recFPTP );
%recr = [recr,auc];
