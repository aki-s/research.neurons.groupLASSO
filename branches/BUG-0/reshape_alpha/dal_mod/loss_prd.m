% loss_lrd - conjugate poisson loss function
% 
% Syntax:
% [floss, gloss, hloss, hmin]=loss_prd(aa, yy)
%
% 2011 Shigeyuki Oba

function varargout = loss_prd(aa, yy)

ya = yy - aa;
lya = log( ya );
floss = sum( ya .*( lya - 1 ) );
gloss = -lya;

hmin  = 1/max(ya); 
% ^-- ??? \gamma in the JMLR paper?
%  minimum value in Hessian?

if nargout<=3
  varargout={floss, gloss, hmin};
else
  hloss = spdiag(1./ya);
  varargout={floss, gloss, hloss, hmin};
end


