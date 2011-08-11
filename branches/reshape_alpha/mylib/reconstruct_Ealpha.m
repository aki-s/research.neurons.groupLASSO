function [Ealpha] = reconstruct_Ealpha(DAL,bases,EKerWeight)

global env
cnum = env.cnum;


Ealpha = cell(zeros(1,DAL.loop));

if strcmp(bases.type,'bar')
  for i0 = 1:length(DAL.regFac)
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} =  EKerWeight{i1to}(:,i2from);
      end
    end
  end
elseif  strcmp(bases.type,'glm')
  for i0 = 1:length(DAL.regFac)
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} = (bases.ihbasis* EKerWeight{i1to}(:,i2from));
      end
    end
  end
end
