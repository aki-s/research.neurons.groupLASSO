cnum = env.cnum;
hnum = env.hnum;
hwind = env.hwind;
regFacIndex = prm.regFacIndex;
TIMEL = prm.xlabel;
dh = prm.xtickwidth;
newYrange = prm.yrange;
zeroFlag = prm.zeroFlag;
DESCRIPTION = prm.title;
savedirname = prm.savedirname;

ARGNUM = 7;
if nargin >= (ARGNUM + 1 ) 
  if nargin >= (ARGNUM + 2 ) 
    EbasisWeight = varargin{ 1 };
    bases = varargin{ 2 };
  end
end
%% 
if size(ResFunc,3) > 1 
  XRANGE = size(ResFunc,3);
  ResFuncH = sprintf('%s','shiftdim(ResFunc(i2to,i3from,:),2)');
else
  XRANGE = hnum*hwind;
  ResFuncH = sprintf('%s','ResFunc((1:hnum)+(i3from-1)*hnum,i2to)'); ...
  %++bug?
end
