function [ Ealpha_ ] = EalphaCell2Mat(env,Ealpha,regFacLen)
%% transform response function
%% from Ealpha{cellIdx}{ito}{ifrom} cell
%% to   (cnum,cnum,hnum) 3D matrix
%%
cnum = env.cnum;

histSize = length(Ealpha{1}{1}{1});
Ealpha_ = zeros(histSize*cnum,cnum,regFacLen);
for ito = 1:cnum
  for ifrom = 1:cnum
    for i1 = 1:regFacLen
      Ealpha_((1:histSize)+histSize*(ifrom-1),ito,i1) = Ealpha{i1}{ito}{ifrom};
    end
  end
end

