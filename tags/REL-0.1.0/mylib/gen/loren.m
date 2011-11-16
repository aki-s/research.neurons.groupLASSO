function [L] = loren(r,cent,hnum)
%function [L] = loren(r,cent,hnum)
%% r   : parameter which decides kurtosis
%% cent: parameter which decides centroid
%% hnum: 

DEBUG = 0;

if DEBUG == 1
  hold on
end


%cent = floor(hnum/2)
PI2 = pi/2;
pW = PI2*( ((1:hnum)/hnum) -1);
W = 1:hnum;
L = 1./ ( pi*r*(1+abs(((W -cent)/r))) );
L1 = sin(pW)./ ( pi*r*(1+abs(((W -cent)/r))) );

if DEBUG == 1
  plot(sin(pW))
  plot(L);
  plot(L1);
end
