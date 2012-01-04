function plot_AUC(env,status,graph,DAL,ansMat,varargin)
%%
%%
%% usage)
% load('./outdir/some_out_data/allVarMat.m')
% ansMat = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat'
% plot_AUC(env,status,graph,DAL,ansMat)
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.

%% ==<conf>==

myColor = graph.prm.myColor;

%% ==< set figure propertiy >==
WIDTH = 550;
switch 4
  case 1
    legendLoc = 'South';
  case 2
    legendLoc = 'Best';
  case 3
    legendLoc = 'WestOutside';
  case 4
    legendLoc = 'SouthWest';
end
%% ==</set figure propertiy >==

nargin_NUM = 5;
if 1 == 1
  F = set_frameRange(nargin,nargin_NUM,varargin,status.validUseFrameIdx);
else
  if nargin > nargin_NUM % only one frame
    F.from = varargin{1};
    F.to = F.from;
  else % mix ALL
    F.from = 1; %++bug
    F.to = status.validUseFrameIdx;
  end
end

if isnumeric(ansMat)
  M_ans = ansMat;  
else
  load(ansMat,'M_ans');
end
uR = length(DAL.regFac);
cSET = length(env.inFiringUSE);

uFnum = cell(1,F.to);
XLABEL = cell(1,F.to);
%XLABELrf = cell(1,uR);
regFac = cell(1,uR);
inFiringUSE = cell(1,cSET);

for i1 =1:F.to
  uFnum{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  XLABEL{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
end
for i1 =1:uR
  regFac{i1} = num2str(sprintf('%09.4f',DAL.regFac(i1)));
  %  XLABELrf{i1} = num2str(sprintf('%d',DAL.regFac(i1)));
end
XLABELrf = num2cell(DAL.regFac);
for i1 = 1:cSET
  inFiringUSE{i1} = num2str(sprintf('%03d',env.inFiringUSE(i1)));
end
fFNAME = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
inRoot = status.savedirname;
%% ==</conf>==

%% ==< calc AUC and correct rate >==
if 1 == 1
  print_AUCdescription(status.method,regFac,fFNAME,uFnum,inFiringUSE)
  [auc recr thresh0 ] = print_AUC(status.method,regFac,fFNAME,uFnum,inFiringUSE,F,M_ans,status.savedirname);
elseif strcmp('leaveOut_calcAUC','leaveOut_calcAUC_')
  rate = zeros(uR,4,F.to);
  auc = zeros(F.to,uR);
  spaceLen = length(sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{1}, ...
                            fFNAME, uFnum{F.from}, inFiringUSE{1}));

  fprintf(1,'LEGEND) TP:=True Positive, p:=positive, n:=negative, z:=zero\n')
  fprintf(1,['response func mat_file %s : (#)TPz  TPp  TPn  TPtotal'...
             ':(%%)TPz  TPp   TPn   TPtotal'...
             ': AUC threshold'...
             '\n'],...
          repmat(' ',[1 (spaceLen-28)]) )
  for j0 = F.from:F.to
    for i0 = 1:cSET
      for regFacIdx = 1:uR
        %%
        filename =sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{regFacIdx}, ...
                          fFNAME, uFnum{j0}, inFiringUSE{i0});
        load( [inRoot '/' filename], 'Alpha');
        RFIntensity = evalResponseFunc( Alpha );
        if strcmp('omitDiag','omitDiag_')
          [recn, recr, thresh0 ,auc(j0,regFacIdx)] = evalRFIntensity_omitDiag(RFIntensity, M_ans);
        else
          [recn, recr, thresh0 ,auc(j0,regFacIdx)] = ...
              evalRFIntensity(RFIntensity, M_ans);
        end
        disp( sprintf( ['%20s:'...
                        '%3d, %3d, %3d, %6d: '...
                        '%5.1f, %5.1f, %5.1f, %5.1f: '...
                        '%2.1f %5.3f'],...
                       filename,...
                       recn,...
                       recr*100,...
                       auc(j0,regFacIdx), thresh0) );
      end
    end
    fprintf(1,'\n');
  end
  %% ==</calc AUC and correct rate >==
end
rate = shiftdim(recr,1)*100;

%% ==< plot correct rate >==
A0 = [4,1,2,3];
%% '+/0/-','0','+','-'
ylabels ={'Total', 'Specificity', 'Excitatory', 'Inhibitory'};

N = 4;
switch 2 % num of window (odd num)
  case 4
    div2 = 1;
  case 2
    div2 = 2;
  case 1
    div2 = N;
end

NN = N/div2; % fig per window
div = 0;
for ii = 1:(div2)
  figure
  %  hold on
  for i = 1:NN
    subplot(NN,1,i)
    hold on;
    for j1 = F.from:F.to
      plot(1:uR, rate(:, A0(i+div),j1),'o-','Color',myColor{j1},'LineWidth',2)
      %      plot(1:uR, rate(A0(i+div),j1,:),'o-','Color',myColor{j1},'LineWidth',2)
    end
    ylabel( ylabels{ i+div})
    xlabel( 'regularization factor' ) 
    set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf)
    axis([0 uR 0 105])
  end
  div = div + NN;
  set(gcf, 'Color', 'White', 'Position',[WIDTH*(ii-1),200,WIDTH,800/div2+100])
  legend(uFnum{F.from:F.to},'Location',legendLoc)
end
%% ==</plot correct rate >==

%% ==< plot AUC >==
figure
hold on;
grid on;
for j0 = F.from:F.to
  plot(1:uR, auc(j0,:),'o-','Color',myColor{j0},'LineWidth',2)
end
%ylabel('max AUC about existance of connection')
ylabel('AUC')
set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf,'ylim',[0.5 1])
axis([1 uR .5 1.05]) % move figures to the left.
xlabel('regularization factor')

%% for paper
if strcmp('for_publish','for_publish_') % without legend
  if 1 == 0
    %% program started   : 2011-11-10-18:54:29, (firng,method) = (kim,aki)
    if nargin == nargin_NUM
      text(11.5 ,0.60,'\color{white}  240','fontsize',12,'BackgroundColor',myColor{1} );
      text(11.5 ,0.87,'\color{white}  500','fontsize',12,'BackgroundColor',myColor{2} );
      text( 9.4 ,0.89,'\color{white} 1000','fontsize',12,'BackgroundColor',myColor{3} );
      text( 7.1 ,0.83,'\color{white} 4000','fontsize',12,'BackgroundColor',myColor{4} );
      text( 5.5 ,0.88,'\color{white}10000','fontsize',12,'BackgroundColor',myColor{5} );
      text( 4.0 ,0.80,'\color{white}40000','fontsize',12,'BackgroundColor',myColor{6} );
      text( 3.0 ,0.88,'\color{white}75000','fontsize',12,'BackgroundColor',myColor{7} );
    elseif 1 == 0
      switch F.from
        case 1
          text(11.5 ,0.60,'\color{white}  240','fontsize',12,'BackgroundColor',myColor{1} );
        case 2
          text(11.5 ,0.87,'\color{white}  500','fontsize',12,'BackgroundColor',myColor{2} );
        case 3
          text( 9.4 ,0.89,'\color{white} 1000','fontsize',12,'BackgroundColor',myColor{3} );
        case 4
          text( 7.1 ,0.83,'\color{white} 4000','fontsize',12,'BackgroundColor',myColor{4} );
        case 5 
          text( 5.5 ,0.88,'\color{white}10000','fontsize',12,'BackgroundColor',myColor{5} );
        case 6
          text( 4.0 ,0.80,'\color{white}40000','fontsize',12,'BackgroundColor',myColor{6} );
        case 7
          text( 3.0 ,0.88,'\color{white}75000','fontsize',12,'BackgroundColor',myColor{7} );
      end
    end
  elseif 1 == 0
    %% program started   : 15-Nov-2011-start-12_49, (firng,method) = (kim,aki)
    text(11.5 ,0.60,'\color{white}  256','fontsize',12,'BackgroundColor',myColor{1} );
    text(11.5 ,0.87,'\color{white}  512','fontsize',12,'BackgroundColor',myColor{2} );
    text( 9.4 ,0.89,'\color{white} 1024','fontsize',12,'BackgroundColor',myColor{3} );
    text( 7.1 ,0.83,'\color{white} 4096','fontsize',12,'BackgroundColor',myColor{4} );
    text( 5.5 ,0.88,'\color{white} 8192','fontsize',12,'BackgroundColor',myColor{5} );
    text( 4.0 ,0.80,'\color{white}33168','fontsize',12,'BackgroundColor',myColor{6} );
    text( 3.0 ,0.88,'\color{white}66336','fontsize',12,'BackgroundColor',myColor{7} );
    text( 2.0 ,0.95,'\color{white}87500','fontsize',12,'BackgroundColor',myColor{8} );
  end
  set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH,200])
else % plot legend
legend(uFnum{F.from:F.to},'Location','WestOutside')
set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,200])
end

%% ==< plot AUC >==
