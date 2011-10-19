function [Ebias_] = Ebias2Mat(env,Ebias,regFacLen)

cnum = env.cnum;

Ebias_ = zeros(cnum,regFacLen);

for i2 = 1:cnum
  Ebias_(i2,:) = Ebias{i2};
end

Ebias_ = Ebias_';
