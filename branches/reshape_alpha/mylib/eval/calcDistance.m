function [Dis] = calcDistance(mx,my,cnum)

Dis = zeros(cnum);
for i1 = 1:cnum
  for i2 = 1:cnum
    Dis(i1,i2) = sqrt((mx(i1) - mx(i2))^2 +  (my(i1) - my(i2))^2);
  end
end
%++improve: Dis' == Dis 
