function plot_ResFuncSuperpose(in,DAL,useFrame,cnum,varargin)
%%
%% USAGE)
%% Example:
% plot_ResFuncSuperpose(status.savedirname,DAL,80000,env.cnum)
% plot_ResFuncSuperpose(status.savedirname,DAL,80000,env.cnum,xrange)
% plot_ResFuncSuperpose(status.savedirname,DAL,env.useFrame(end),env.cnum,xrange,yrange)
%%plot_ResFuncSuperpose(status.savedirname,DAL,env.useFrame(end),env.cnum,xrange,yrange,ansMat)
% plot_ResFuncSuperpose(status.savedirname,DAL,75000,9,[0 bases.ihbasprs.numFrame],[-.1 .1],ansMat)
%%
%% ansMat: 'indir/sim_kim_ans.mat' or alpha_fig
%%
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
in = strcat(in,'/');

listLS = ls([in,'*.mat']); % default list

[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-[0-9\.]*-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
N = length(list);

RFIntensity = nan(cnum,cnum,N);
thresh = 0;
for i1 = 1:N

  [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                      '\w*-',sprintf('%09.4f',DAL.regFac(i1)),'-\w*-',...
                      '0*',sprintf('%d',useFrame),'-',...
                      '0*',sprintf('%d',cnum),'.mat']);
  fprintf('loaded: %s\n',list{1});
  S = load(list{1});

  RFIntensity(:,:,i1) = evalResponseFunc( S.Alpha );
  if CHECK_NOISE == 1
    [dum1 dum2 thresh] = evalRFIntensity( RFIntensity(:,:,i1), M_ans);
  end
  TYPE = reshape(RFIntensity(:,:,i1),1,[]);

  RFIp = RFIntensity - thresh >0; % thresh >= 0
  RFIpN = sum(sum(RFIp,1),2);
  RFIn = RFIntensity + thresh  <0;
  RFInN = sum(sum(RFIn,1),2);

  %%% ===== PLOT alpha ===== START =====
  figure;
  title(['positive: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d, thresh:%5.3f',RFIpN(i1),S.DAL.regFac(i1),useFrame,thresh)])
  hold on;
  for i2 = 1:cnum*cnum
    if TYPE(i2) > 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]),'r')
    end
  end
  xlim(xrangeIn);
  ylim(yrangeIn);

  figure;
  title(['negative: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d, thresh:%5.3f',RFInN(i1),S.DAL.regFac(i1),useFrame,thresh)])
  hold on;
  for i2 = 1:cnum*cnum
    if TYPE(i2) < 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]),'b')
    end
  end
  xlim(xrangeIn);
  ylim(yrangeIn);
end

%%% ===== PLOT alpha ===== END =====
if N == 0
  fprintf(1,'nothing to plot\n');
end
