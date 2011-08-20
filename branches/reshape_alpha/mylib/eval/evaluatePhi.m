function [recn, recr, thresh0] = evaluatePhi( Phi, Answer )

[N,dum] = size(Phi);

% Omit diagonal elements
Phi = Phi + eye(N)*1e100;
idx = find( Phi(:) < 1e90 );
Phi = Phi( idx );
Answer = Answer( idx );
tmp = std( abs( Phi(:) ) );
thresh0 = tmp * (1:1000)/100;

N0 = sum( Answer == 0 );
Np = sum( Answer == 1 );
Nn = sum( Answer == -1 );
recn = zeros( length(thresh0), 4 );
recr = recn;
for t1 = 1:length(thresh0)
    thresh = thresh0( t1 );
    TP0 = sum( abs(Phi) < thresh & Answer == 0);
    TPp = sum( Phi > thresh & Answer == 1);
    TPn = sum( Phi < thresh & Answer == -1);
    TPtotal = TP0 + TPp + TPn;
    recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
    recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(Phi)];
end

[dum, idx] = max( recn(:,4) );

recn = recn(idx,:);
recr = recr(idx,:);
