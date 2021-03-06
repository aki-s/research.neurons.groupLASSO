function [RFcon] = plot_ResFuncSuperpose(in,DAL_regFac,useFrame,cnum,varargin)
%%
%% USAGE)
%% Example:
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,80000,env.cnum)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,80000,env.cnum,xrange)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,env.useFrame(end),env.cnum,xrange,yrange)
%%plot_ResFuncSuperpose(status.savedirname,DAL.regFac,env.useFrame(end),env.cnum,xrange,yrange,Fpeaks)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,75000,9,[0 bases.ihbasprs.numFrame],[-.5 .5],Fpeaks)
%% Fpeaks: Fpeaks = get_basisPeaks(bases.ihbasis);
%%
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,75000,9,[0 bases.ihbasprs.numFrame],[-.5 .5],Fpeaks,ans2Dmat)
%% ans2Dmat: 'indir/sim_kim_ans.mat' or ResFunc_fig
%% or,
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,75000,9,[0 bases.ihbasprs.numFrame],[-.5 .5],Fpeaks,intensityThreshold)
%%
DEBUG = 0;

cnum2cnum = cnum*cnum;

BASEIN = 4;
PAPER = 1;
if nargin >= BASEIN +1
  xrangeIn = varargin{1};
else
  xrangeIn = [0 200];
end
if nargin >= BASEIN +2
  yrangeIn = varargin{2};
else
  yrangeIn = [-1 1];
end
if nargin >= BASEIN +3
  Fpeaks = varargin{3};
  FF = length(Fpeaks);
  WIDTH = 0.005;
  %  HEIGHT = 20;
  HEIGHT = 2000;
else
  Fpeaks = 0;
  FF = 1;
  HEIGHT = 1;
  WIDTH = 0;
end
%if nargin >= BASEIN +3
if nargin >= BASEIN +4
  if isscalar(varargin{4})
    thresh = varargin{4};
    CHECK_NOISE = 0;
  elseif isnumeric(varargin{4})
    M_ans = varargin{4};  
    CHECK_NOISE = 1;
  else
    load(varargin{4},'M_ans');
    CHECK_NOISE = 1;
  end
else
  CHECK_NOISE = 0;
  thresh = 0;
end

in = strcat(in,'/');
listLS = ls([in,'*.mat']); % default list
if isempty(listLS)
  error('default list is empty')
end

%% remove unnecessary list
[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-[0-9\.]*-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
if isempty(list)
  %  error('screened list is empty')
  fprintf('Supposing status.crossVal_rough==1\n')
  in = strcat(in,'/CV/');
  listLS = ls([in,'*.mat']); % default list
end
N = length(DAL_regFac);

RFIntensity = nan(cnum,cnum,N);

for i1 = 1:N
  try
    [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                        '\w*-',sprintf('%09.4f',DAL_regFac(i1)),'-\w*-',...
                        '0*',sprintf('%d',useFrame),'-',...
                        '0*',sprintf('%d',cnum),'.mat']);
    if isempty(list) && (status.crossVal_rough == 0)
      warning('list is empty, trying values from CV1.')
    end
  catch err % status.crossVal_rough == 1
    [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp([listLS '/CV/'],[in, ...
                        '\w*-',sprintf('%09.4f',DAL_regFac(i1)),'-\w*-',...
                        '0*',sprintf('%d',useFrame),'-',...
                        '0*',sprintf('%d',cnum),'-CV1.mat']);
    [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp([listLS '/CV/'],[in, ...
                        '\w*-',sprintf('%09.4f',DAL_regFac(i1)),'-\w*-',...
                        '0*',sprintf('%d',useFrame),'-',...
                        '0*',sprintf('%03d',cnum),'-CV1.mat']);
  end

  if isempty(list)
    error('list is empty')
  end
  fprintf('loaded: %s\n',list{1});
  S = load(list{1});

  try
    RFIntensity(:,:,i1) = evalResponseFunc( S.ResFunc );
  catch e
    try
      S.ResFunc = S.EResFunc;%++bug: all mat file has not ResFunc but EResFunc?
      RFIntensity(:,:,i1) = evalResponseFunc( S.ResFunc );
    catch e
      S.ResFunc = S.Alpha;%++obsolete:@revision110
      RFIntensity(:,:,i1) = evalResponseFunc( S.ResFunc );
    end
  end
  if CHECK_NOISE == 1
    [dum1 dum2 thresh] = evalRFIntensity( RFIntensity(:,:,i1), M_ans);
  end
  TYPE = reshape(RFIntensity(:,:,i1),1,[]);

  [RFcon RFIp RFIn]= get_conMat(RFIntensity(:,:,i1),thresh);
  %  RFIp = RFIntensity - thresh >0; % thresh >= 0
  RFIpN = sum(sum(RFIp,1),2);
  %  RFIn = RFIntensity + thresh  <0;
  RFInN = sum(sum(RFIn,1),2);
  %  RFcon = RFIp - RFIn;

  RFIzN = cnum2cnum - RFIpN - RFInN;
  %%
  if DEBUG > 0
    figure
    BG = reshape(sum(sum(S.ResFunc,1),2)/cnum2cnum,1,[]);
    plot(BG)
  end

  %%% ===== PLOT ResFunc ===== START =====
  figure;

  %% positive
  subplot(2,2,1)
  title(['positive: ',sprintf('#%4d',RFIpN)])
  hold on;
  for i2 = 1:cnum2cnum
    if TYPE(i2) -thresh > 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.ResFunc(row,col,:),1,[]),'r')
    end
  end
  bar(Fpeaks,repmat(+HEIGHT,[FF 1]),WIDTH)
  xlim(xrangeIn);
  ylim(yrangeIn);

  %% negative
  subplot(2,2,2)
  title(['negative: ',sprintf('#%4d',RFInN)])
  hold on;
  for i2 = 1:cnum2cnum
    if TYPE(i2) +thresh < 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.ResFunc(row,col,:),1,[]),'b')
    end
  end
  bar(Fpeaks,repmat(-HEIGHT,[FF 1]),WIDTH)
  xlim(xrangeIn);
  ylim(yrangeIn);

  %% noise
  subplot(2,2,3)
  title(['noise: ',sprintf('#%4d',RFIzN)])
  hold on;
  for i2 = 1:cnum2cnum
    if ~( (TYPE(i2) -thresh > 0) || (TYPE(i2) +thresh < 0) )
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.ResFunc(row,col,:),1,[]),'k')
    end
  end
  bar(Fpeaks,repmat(+HEIGHT,[FF 1]),WIDTH)
  bar(Fpeaks,repmat(-HEIGHT,[FF 1]),WIDTH)
  xlim(xrangeIn);
  ylim(yrangeIn);

  %% scatter plot about RFIntensity
  subplot(2,2,4)
  hold on;
if ~PAPER
  %% partition
  SHIFT = 0.5;
  bar(SHIFT+cnum*(1:(cnum-1)),+HEIGHT*ones(1,(cnum-1)),WIDTH)
  bar(SHIFT+cnum*(1:(cnum-1)),-HEIGHT*ones(1,(cnum-1)),WIDTH)
end
  %% threshold
  plot(repmat(+thresh,[1 cnum2cnum]),'-r')
  plot(repmat(-thresh,[1 cnum2cnum]),'-b')
  
  plot(TYPE,'ok')
  xlim([0 1+cnum2cnum])

  if cnum <= 10
    %    SCALE = 10/cnum;
    axes('position',[.13 0 1.2 .08]);
    set(gca,'Visible','off');
    set(title(sprintf('%s',num2str(sprintf('%7d',1:cnum)))),'Visible','on')
  end
  %%% add summary text
  %http://www.mathworks.com/matlabcentral/newsreader/view_thread/244434
  set(gcf,'NextPlot','add');
  axes('position',[.1 .84 .9 .1]);
  set(gca,'Visible','off');
if ~PAPER
  h =  title(sprintf('regFac:%9.4f, useFrame:%10d, thresh:%5.3f', ...
                     DAL_regFac(i1),useFrame,thresh));
  set(h,'Visible','on');
end
end

%%% ===== PLOT ResFunc ===== END =====
if N == 0
  fprintf(1,'nothing to plot\n');
end
