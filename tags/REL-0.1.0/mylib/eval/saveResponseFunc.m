function  saveResponseFunc(env,graph,status,bases,EbasisWeight,Ealpha,Ebias,DAL,fire,varargin)
%
% saveResponseFunc(Ealpha,DAL,'FNAME')
% saveResponseFunc(Ealpha,DAL,'FNAME','relative_dirname')

INBASE = 9;

if nargin >= INBASE + 1
  outFolder = varargin{1};
  outFmk = [status.savedirname,'/',outFolder];
  if ~exist(outFmk,'dir')
    mkdir(outFmk)
  end
else
  outFolder ='';
end

if nargin >= INBASE + 2
  crossValIdx = varargin{2};
else
  crossValIdx = '';
end

EbasisWeight = EbasisWeight; %good, rename in transition
AlphaSelf = Ebias; %bad, rename in transition
%%
cnum = env.cnum;
frame = DAL.Drow;
regFac = DAL.regFac;
N = length(regFac);
method = status.method;
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
if nargin == INBASE + 2
  for i1 = 1:N
    Alpha = Alpha_{i1};
    save([savedirname,'/',outFolder,'/',...
          method,'-', ...
          sprintf('%09.4f',regFac(i1)),...
          '-',fire, ...
          sprintf('-%07d',frame),...
          sprintf('-%03d',cnum),...
          K,...
          '.mat' ],'env','graph','savedirname','Alpha','AlphaSelf','EbasisWeight','DAL','bases');
  end

else
  for i1 = 1:N
    Alpha = Alpha_{i1};
    save([savedirname,'/',method,'-', ...
          sprintf('%09.4f',regFac(i1)),...
          '-',fire, ...
          sprintf('-%07d',frame),...
          sprintf('-%03d',cnum),...
          K,...
          '.mat' ],'env','graph','status','savedirname','Alpha','AlphaSelf','EbasisWeight','DAL','bases');
  end
end
