function [ EResFunc_ ] = EResFuncCell2Mat(env,EResFunc,regFacLen,varargin)
%% transform response function
%% from EResFunc{cellIdx}{ito}{ifrom} cell
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

histSize = length(EResFunc{regFacLen}{1}{1});
%EResFunc_ = zeros(histSize*cnum,cnum,regFacLen);
EResFunc_ = nan(histSize*cnum,cnum,regFacLen);

for ito = 1:cnum
  for ifrom = 1:cnum
    %    for i1 = 1:regFacLen
    for i1 = FROM:regFacLen
      EResFunc_((1:histSize)+histSize*(ifrom-1),ito,i1) = EResFunc{i1}{ito}{ifrom};
    end
  end
end

