function [ Ealpha_ ] = EalphaCell2Mat(env,Ealpha,regFacLen,varargin)
%% transform response function
%% from Ealpha{cellIdx}{ito}{ifrom} cell
%% to   (cnum*hnum,cnum,regFacLen) 3D matrix
%%
cnum = env.cnum;

IN = 3;
if nargin >= IN +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);
else
  FROM = 1;
end

histSize = length(Ealpha{regFacLen}{1}{1});
%Ealpha_ = zeros(histSize*cnum,cnum,regFacLen);
Ealpha_ = nan(histSize*cnum,cnum,regFacLen);

for ito = 1:cnum
  for ifrom = 1:cnum
    %    for i1 = 1:regFacLen
    for i1 = FROM:regFacLen
      Ealpha_((1:histSize)+histSize*(ifrom-1),ito,i1) = Ealpha{i1}{ito}{ifrom};
    end
  end
end

