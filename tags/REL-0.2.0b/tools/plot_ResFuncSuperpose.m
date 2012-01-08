function plot_ResFuncSuperpose(in,DAL_regFac,useFrame,cnum,varargin)
%%
%% USAGE)
%% Example:
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,80000,env.cnum)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,80000,env.cnum,xrange)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,env.useFrame(end),env.cnum,xrange,yrange)
%%plot_ResFuncSuperpose(status.savedirname,DAL.regFac,env.useFrame(end),env.cnum,xrange,yrange,ansMat)
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,75000,9,[0 bases.ihbasprs.numFrame],[-.5 .5],ansMat)
%% ansMat: 'indir/sim_kim_ans.mat' or ResFunc_fig
%%
% plot_ResFuncSuperpose(status.savedirname,DAL.regFac,75000,9,[0 bases.ihbasprs.numFrame],[-.5 .5],ansMat,Fpeaks)
%% Fpeaks: Fpeaks = get_basisPeaks(bases.ihbasis);
%%
DEBUG = 1;

cnum2cnum = cnum*cnum;

BASEIN = 4;
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
  CHECK_NOISE = 1;
  if isnumeric(varargin{3})
    M_ans = varargin{3};  
  else
    load(varargin{3},'M_ans');
  end
else
  CHECK_NOISE = 0;
end
if nargin >= BASEIN +4
  Fpeaks = varargin{4};
  FF = length(Fpeaks);
  WIDTH = 0.005;
  HEIGHT = 5;
else
  Fpeaks = 0;
  FF = 1;
  HEIGHT = 1;
  WIDTH = 0;
end

in = strcat(in,'/');

listLS = ls([in,'*.mat']); % default list

[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-[0-9\.]*-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
N = length(DAL_regFac);

RFIntensity = nan(cnum,cnum,N);
thresh = 0;
for i1 = 1:N

  [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                      '\w*-',sprintf('%09.4f',DAL_regFac(i1)),'-\w*-',...
                      '0*',sprintf('%d',useFrame),'-',...
                      '0*',sprintf('%d',cnum),'.mat']);
  fprintf('loaded: %s\n',list{1});
  S = load(list{1});

  RFIntensity(:,:,i1) = evalResponseFunc( S.ResFunc );
  if CHECK_NOISE == 1
    [dum1 dum2 thresh] = evalRFIntensity( RFIntensity(:,:,i1), M_ans);
  end
  TYPE = reshape(RFIntensity(:,:,i1),1,[]);

  RFIp = RFIntensity - thresh >0; % thresh >= 0
  RFIpN = sum(sum(RFIp,1),2);
  RFIn = RFIntensity + thresh  <0;
  RFInN = sum(sum(RFIn,1),2);

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
  title(['positive: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d, thresh:%5.3f',RFIpN,DAL_regFac(i1),useFrame,thresh)])
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
  title(['negative: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d, thresh:%5.3f',RFInN,DAL_regFac(i1),useFrame,thresh)])
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
  title(['noise: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d, thresh:%5.3f',RFIzN,DAL_regFac(i1),useFrame,thresh)])
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
  %% partition
  SHIFT = 0.5;
  bar(SHIFT+cnum*(1:(cnum-1)),+HEIGHT*ones(1,(cnum-1)),WIDTH)
  bar(SHIFT+cnum*(1:(cnum-1)),-HEIGHT*ones(1,(cnum-1)),WIDTH)

  %% threshold
  plot(repmat(+thresh,[1 cnum2cnum]),'-')
  plot(repmat(-thresh,[1 cnum2cnum]),'-')
  
  plot(TYPE,'o')
  xlim([0 1+cnum2cnum])

end

%%% ===== PLOT ResFunc ===== END =====
if N == 0
  fprintf(1,'nothing to plot\n');
end
