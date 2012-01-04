function [rate0,num0] = calcCorrectRateLax_IE(Tfig,Efig)
% return correct rate of (+/-)
% [rate0,num0] = calcCorrectRateLax_IE(Tfig,Efig)

%[R C] = size(Tfig);

b = (Tfig ~= 0);
num0.Row = sum(b,2);
num0.Col = sum(b,1);
num0.Total = sum(sum(b));

a = (0 ~= Efig); % 
a = a.*logical(Tfig~=0) % correct (+/-) is still flag 1.

rate0.Row   = sum(a,2)./num0.Row;
rate0.Col   = sum(a,1)./num0.Col;
rate0.Total = sum(sum(a))/num0.Total;
