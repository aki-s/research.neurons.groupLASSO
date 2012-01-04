function plot_ResFuncSuperpose(in,DAL,useFrame,cnum,varargin)
%%
%% USAGE)
%% Example:
%plot_ResFuncSuperpose(status.savedirname,DAL,80000,env.cnum)

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
in = strcat(in,'/');

listLS = ls([in,'*.mat']); % default list

[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-[0-9\.]*-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
N = length(list);

RFIntensity = nan(cnum,cnum,N);

for i1 = 1:N

[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-',sprintf('%09.4f',DAL.regFac(i1)),'-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
  fprintf('loaded: %s\n',list{1});
  S = load(list{1});

  RFIntensity(:,:,i1) = evalResponseFunc( S.Alpha );
  FLAG = reshape(RFIntensity(:,:,i1),1,[]);

  RFIp = RFIntensity >0;
  RFIpN = sum(sum(RFIp,1),2);
  RFIn = RFIntensity <0;
  RFInN = sum(sum(RFIn,1),2);
  %RFIp-RFIn
  %% ==< set title >==
  %% ==</set title >==

  %%% ===== PLOT alpha ===== START =====
  figure;
  title(['positive: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d',RFIpN(i1),S.DAL.regFac(i1),useFrame)])
  hold on;
  for i2 = 1:cnum*cnum
    if FLAG(i2) > 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]))
    end
  end
  xlim(xrangeIn);
  ylim(yrangeIn);

  figure;
  title(['negative: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d',RFInN(i1),S.DAL.regFac(i1),useFrame)])
  hold on;
  for i2 = 1:cnum*cnum
    if FLAG(i2) < 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]))
    end
  end
  xlim(xrangeIn);
  ylim(yrangeIn);
end

%%% ===== PLOT alpha ===== END =====
if N == 0
  fprintf(1,'nothing to plot\n');
end
