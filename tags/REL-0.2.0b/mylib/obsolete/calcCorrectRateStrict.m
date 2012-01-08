function [rate] = calcCorrectRateStrict(Tfig,Efig)

[R C] = size(Tfig);
a = (Tfig == Efig);
rate.Row   = sum(a,2)/R;
rate.Rown   = sum(a,2);
rate.Col   = sum(a,1)/C;
rate.Coln   = sum(a,1);
rate.Total = sum(sum(a))/(R*C);
rate.Totaln = sum(sum(a));
