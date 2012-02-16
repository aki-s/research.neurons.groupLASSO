function [ EResFunc_ ] = EResFuncCell2Mat(cnum,EResFunc,regFacLen,varargin)
%% transform response function
%% from EResFunc{cellIdx}{ito}{ifrom} cell
%% to   (cnum*hnum,cnum,regFacLen) 3D matrix
%%
IN = 3;
if nargin >= IN +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);
else
  FROM = 1;
end

try
  histSize = length(EResFunc{regFacLen}{1}{1});
catch er
  i1 = 1;
  while isempty(EResFunc{i1})
    i1 = i1 + 1;
  end
  histSize = length(EResFunc{i1}{1}{1});
end
EResFunc_ = nan(histSize*cnum,cnum,regFacLen);

for ito = 1:cnum
  for ifrom = 1:cnum
    %    for i1 = 1:regFacLen
    try
      for i2 = FROM:regFacLen
        EResFunc_((1:histSize)+histSize*(ifrom-1),ito,i2) = EResFunc{i2}{ito}{ifrom};
      end
    catch err
      EResFunc_((1:histSize)+histSize*(ifrom-1),ito) = EResFunc{i1}{ito}{ifrom};
    end
  end
end

