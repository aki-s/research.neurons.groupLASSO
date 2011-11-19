function plot_ResFuncSuperpose(in,DAL,useFrame,cnum,varargin)
%%
%% USAGE)
%% Example:
%  plot_ResFuncALL(status.savedirname,DAL.regFac(3),env.useFrame(4),9)

BASEIN = 4;
if nargin >= BASEIN +1
  yrangeIn = varargin{1};
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
%S = load(list{1});
%regFacLen = length(S.DAL.regFac);
%RFIntensity = nan(cnum,cnum,regFacLen);
RFIntensity = nan(cnum,cnum,N);
%for i1 = 1:regFacLen
%for i1 = 14:14
for i1 = 1:N

[dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                    '\w*-',sprintf('%09.4f',DAL.regFac(i1)),'-\w*-',...
                    '0*',sprintf('%d',useFrame),'-',...
                    '0*',sprintf('%d',cnum),'.mat']);
  fprintf('loaded: %s\n',list{1});
  S = load(list{1});

  RFIntensity(:,:,i1) = evalResponseFunc( S.Alpha );
  FLAG = reshape(RFIntensity(:,:,i1),1,[]);
  %end
  RFIp = RFIntensity >0;
  RFIpN = sum(sum(RFIp,1),2);
  RFIn = RFIntensity <0;
  RFInN = sum(sum(RFIn,1),2);
  %RFIp-RFIn
  %% ==< set title >==
  %% ==</set title >==

  %%% ===== PLOT alpha ===== START =====
  figure;
  %for i1 = 1:regFacLen
  %title('positive')
  title(['positive: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d',RFIpN(i1),S.DAL.regFac(i1),useFrame)])
  hold on;
  for i2 = 1:cnum*cnum
    if FLAG(i2) > 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]))
    end
  end
  ylim(yrangeIn);
  %end
  figure;
  %for i1 = 1:regFacLen
  title(['negative: ',sprintf('#%4d, regFac:%9.4f, useFrame:%10d',RFInN(i1),S.DAL.regFac(i1),useFrame)])
  hold on;
  for i2 = 1:cnum*cnum
    if FLAG(i2) < 0
      col = ceil(i2 / cnum);
      row = i2 - (col-1)*cnum;
      plot(reshape(S.Alpha(row,col,:),1,[]))
    end
  end
  ylim(yrangeIn);
end

%%% ===== PLOT alpha ===== END =====
