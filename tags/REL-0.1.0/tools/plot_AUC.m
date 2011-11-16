function plot_AUC(env,status,graph,DAL,ansMat,varargin)
%%
%%
%% usage)
% load('./outdir/some_out_data/allVarMat.m')
% ansMat = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat'
% plot_AUC(env,status,DAL,ansMat)
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
if nargin > nargin_NUM % only one frame
  FROM = varargin{1};
  uF = FROM;
else % mix ALL
  FROM = 1; %++bug
  uF = status.validUseFrameIdx;
end

load(ansMat,'M_ans');

uR = length(DAL.regFac);
cSET = length(env.inFiringUSE);

uFnum = cell(1,uF);
XLABEL = cell(1,uF);
%XLABELrf = cell(1,uR);
regFac = cell(1,uR);
inFiringUSE = cell(1,cSET);

for i1 =1:uF
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
inRoot = regexprep(status.outputfilename,'(.*/)(.*)(.mat)','$1');
%% ==</conf>==

%% ==< calc AUC and correct rate >==

rate = zeros(uR,4,uF);
auc.A = zeros(uF,uR);
spaceLen = length(sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{1}, ...
                          fFNAME, uFnum{FROM}, inFiringUSE{1}));

fprintf(1,'LEGEND) TP:=True Positive, p:=positive, n:=negative\n')
fprintf(1,['response func mat_file %s : (#)TP0  TPp  TPn  TPtotal'...
           ':(%%)TP0  TPp   TPn   TPtotal'...
           ': AUC'...
           '\n'],...
        repmat(' ',[1 (spaceLen-28)]) )
for j0 = FROM:uF
  for i0 = 1:cSET
    for regFacIdx = 1:uR
      filename =sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{regFacIdx}, ...
                        fFNAME, uFnum{j0}, inFiringUSE{i0});
      load( [inRoot '/' filename], 'Alpha');
      RFIntensity = evalResponseFunc( Alpha );
      [recn, recr, thresh0 ,auc.A(j0,regFacIdx)] = evalRFIntensity(RFIntensity, M_ans);
      disp( sprintf( '%20s: %3d, %3d, %3d, %6d: %5.1f, %5.1f, %5.1f, %5.1f: %2.1f',...
                     filename, recn, recr*100, auc.A(j0,regFacIdx)) );
      rate(regFacIdx,1:4,j0) = recr*100;
    end
  end
  fprintf(1,'\n');
end
%% ==</calc AUC and correct rate >==

%% ==< plot correct rate >==
A0 = [4,1,2,3];
%% '+/0/-','+/1','+','-'
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
    for j1 = FROM:uF
      plot(1:uR, rate(:, A0(i+div),j1),'o-','Color',myColor{j1},'LineWidth',2)
      %      plot(1:uR, rate(:, A0(i+div),j1),'o-','Color',color(j1,:),'LineWidth',2)
      %      plot(0:(uR-1), rate(:, A0(i+div),j1),'o-','Color',color(j1,:),'LineWidth',2)
    end
    ylabel( ylabels{ i+div})
    xlabel( 'regularization factor' ) 
    set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf)
    axis([0 uR 0 105])
  end
  div = div + NN;
  set(gcf, 'Color', 'White', 'Position',[WIDTH*(ii-1),200,WIDTH,800/div2+100])
  legend(uFnum{FROM:uF},'Location',legendLoc)
end
%% ==</plot correct rate >==

%% ==< plot AUC >==
figure
hold on;
grid on;
for j0 = FROM:uF
  plot(1:uR, auc.A(j0,:),'o-','Color',myColor{j0},'LineWidth',2)
end
ylabel('AUC')
set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf,'ylim',[0.5 1])
axis([1 uR .5 1.05]) % move figures to the left.
xlabel('regularization factor')

%% for paper
if strcmp('for_publish','for_publish') % without legend
  if 1 == 1
    %% program started   : 2011-11-10-18:54:29, (firng,method) = (kim,aki)
    if nargin == nargin_NUM
      text(11.5 ,0.60,'\color{white}  240','fontsize',12,'BackgroundColor',myColor{1} );
      text(11.5 ,0.87,'\color{white}  500','fontsize',12,'BackgroundColor',myColor{2} );
      text( 9.4 ,0.89,'\color{white} 1000','fontsize',12,'BackgroundColor',myColor{3} );
      text( 7.1 ,0.83,'\color{white} 4000','fontsize',12,'BackgroundColor',myColor{4} );
      text( 5.5 ,0.88,'\color{white}10000','fontsize',12,'BackgroundColor',myColor{5} );
      text( 4.0 ,0.80,'\color{white}40000','fontsize',12,'BackgroundColor',myColor{6} );
      text( 3.0 ,0.88,'\color{white}75000','fontsize',12,'BackgroundColor',myColor{7} );
    else
      switch FROM
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
  else
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
legend(uFnum{FROM:uF},'Location','WestOutside')
set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,200])
end

%% ==< plot AUC >==
