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
%%++improve: share code with 'set_plot_ResFunc_variables.m'
run set_plot_ResFunc_variables
%%

ARGNUM = 7;
if nargin >= (ARGNUM + 1 ) 
  if nargin >= (ARGNUM + 2 ) 
    EbasisWeight = varargin{ 1 };
    bases = varargin{ 2 };
  end
end
%% 
if size(ResFunc,3) > 1 
  % s.EResFunc:plot_ResFunc_subplot.m
  XRANGE = size(ResFunc,3);
  ResFuncH = sprintf('%s','shiftdim(ResFunc(i2to,i3from,:),2)');
elseif iscell(ResFunc)
disp('cell')%plot_EResFunc_subplot.m
  ResFunc = EResFuncCell2Mat(cnum,ResFunc,1);
     %++bug: ( hnum == NaN ) @conf_use_kim.m
  if exist('bases','var')
    hnum =  bases.ihbasprs.numFrame;
  end
  XRANGE = hnum*hwind;
  ResFuncH = sprintf('%s','ResFunc((1:hnum)+(i3from-1)*hnum,i2to)');
else % assume 2D matrix
disp('2D')
     %++bug: ( hnum == NaN ) @conf_use_kim.m
% $$$   if exist('bases','var')
% $$$     hnum =  bases.ihbasprs.numFrame;
% $$$   end
  XRANGE = hnum*hwind;
  ResFuncH = sprintf('%s','ResFunc((1:hnum)+(i3from-1)*hnum,i2to)');
end
