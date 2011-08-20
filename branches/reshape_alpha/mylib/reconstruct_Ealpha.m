function [Ealpha] = reconstruct_Ealpha(env,DAL,bases,EKerWeight)

cnum = env.cnum;


Ealpha = cell(zeros(1,length(DAL.regFac)));

if strcmp(bases.type,'bar')
  for i0 = 1:length(DAL.regFac)
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} =  EKerWeight{i0}{i1to}(:,i2from);
      end
    end
  end
elseif  strcmp(bases.type,'glm')
  for i0 = 1:length(DAL.regFac)
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} = (bases.ihbasis* EKerWeight{i0}{i1to}(:,i2from));
      end
    end
  end
end
