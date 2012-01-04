function [rate0,num0] = calcCorrectRateLax_zero(Tfig,Efig)
% return correct rate of 0
% [rate0,num0] = calcCorrectRateLax(Tfig,Efig)


%[R C] = size(Tfig);

b = (Tfig == 0);
num0.Row = sum(b,2);
num0.Col = sum(b,1);
num0.Total = sum(sum(b))

a = (Tfig == Efig); % correct +/0/-
a = a.*logical(Tfig==0) % correct 0 is still flag 1.

rate0.Row   = sum(a,2)./num0.Row;
rate0.Col   = sum(a,1)./num0.Col;
if num0.Total ~= 0
  rate0.Total = sum(sum(a))/num0.Total;
else

end

