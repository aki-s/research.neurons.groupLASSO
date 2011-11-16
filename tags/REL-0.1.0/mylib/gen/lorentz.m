function [L] = lorentz(r,hnum)

DEBUG = 1;
if DEBUG == 1
  hold on
end


cent = floor(hnum/2)
W = ((1:hnum)/hnum);
W = 1:hnum;
%L = zeros(1,hnum);
%L(1:hnum) = 1./ ( pi*r*(1+((W)/r).^2) );
L = 1./ ( pi*r*(1+((W -cent)/r).^2) );
plot(L);
