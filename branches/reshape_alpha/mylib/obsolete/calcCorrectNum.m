function [sum] = calcCorrectNum(tfig,efig)

[R C] = size(tfig);
sum.e = 0;
sum.i = 0;
sum.z = 0;
sum.total = 0;
for i1 = 1:R
  for i2 = 1:C
    switch efig(i1,i2)
      case +1
        sum.e =    sum.e + 1;
      case -1             
        sum.i =    sum.i + 1;
      case 0              
        sum.z =    sum.z + 1;
    end
    if ( tfig(i1,i2) ==  efig(i1,i2) )
      sum.total = sum.total + 1;
    end
  end
end
