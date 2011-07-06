% loss_prp - poisson loss function
%
% 2011 Shigeyuki Oba
function [floss, gloss]=loss_prp(zz, yy)






ez = exp( zz );
floss = sum( ez - zz.*yy );
gloss = ez - yy;

