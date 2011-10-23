function  saveResponseFunc(env,graph,EKerWeight,Ealpha,Ebias,DAL,status,fire,varargin)
%
% saveResponseFunc(Ealpha,DAL,status,'fire_by')

INBASE = 8;
if nargin > INBASE
  bases = varargin{1};
else
  bases = NaN;
end
if nargin > INBASE + 1
  crossValIdx = varargin{2};
else
  crossValIdx = '';
end

basisWeight = EKerWeight;
AlphaSelf = Ebias;
%%
cnum = env.cnum;
frame = DAL.Drow;
regFac = DAL.regFac;
N = length(regFac);
method = status.method;
%checkDirname = status.checkDirname;
savedirname = status.savedirname;
%%
SIZE = 500; % SIZE > bases.ihbas.iht
Alpha_ = cell(1,N);
len = length(Ealpha{1}{1}{1}(:));
for i1 = 1:length(regFac)
  Alpha_{i1} = zeros(cnum,cnum,SIZE);
  for i1to =1:cnum
    for i2from =1:cnum
      Alpha_{i1}(i1to,i2from,1:len) = Ealpha{i1}{i1to}{i2from}(:);
      %      Alpha(i1to,i2from,:) = Ealpha{i1}{i1to}{i2from}(1:SIZE)
    end
  end
  %plotalpha(Alpha_{i1})
end
%%
if isempty(crossValIdx)
  K ='';
else
  K = sprintf('-CV%1d',crossValIdx);
end
for i1 = 1:N
  Alpha = Alpha_{i1};
  save([savedirname,'/',method,'-', ...
        sprintf('%07d',regFac(i1)),...
        '-',fire, ...
        sprintf('-%07d',frame),...
        sprintf('-%03d',cnum),...
        K,...
        '.mat' ],'env','graph','Alpha','AlphaSelf','basisWeight','DAL','bases');
end
