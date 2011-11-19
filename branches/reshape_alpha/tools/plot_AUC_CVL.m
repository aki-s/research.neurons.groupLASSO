function plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL,varargin)
%%
%%
%% usage)
% load('./outdir/some_out_data/allVarMat.m')
% ansMat = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat'
%% plot all
% plot_AUC(env,status,graph,DAL,ansMat,CVL)
%% or, plot Index_of_env.useFrame
% plot_AUC(env,status,graph,DAL,ansMat,CVL,Index_of_env.useFrame) 
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

nargin_NUM = 6;
if nargin > nargin_NUM % only one frame
  FROM = varargin{1};
  uF = FROM;
else % mix ALL
  FROM = 1;
  uF = status.validUseFrameIdx;
end

if isnumeric(ansMat)
  M_ans = ansMat;  
else
load(ansMat,'M_ans');
end
uR = length(DAL.regFac);
cSET = length(env.inFiringUSE);

uFnum = cell(1,uF);
XLABEL = cell(1,uF);
regFac = cell(1,uR);
inFiringUSE = cell(1,cSET);

for i1 =1:uF
  uFnum{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  XLABEL{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
end
for i1 =1:uR
  regFac{i1} = num2str(sprintf('%09.4f',DAL.regFac(i1)));
end
XLABELrf = num2cell(DAL.regFac);
for i1 = 1:cSET
  inFiringUSE{i1} = num2str(sprintf('%03d',env.inFiringUSE(i1)));
end
fFNAME = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
%inRoot = regexprep(status.outputfilename,'(.*/)(.*)(.mat)','$1');
inRoot = status.savedirname;
%% ==</conf>==

if strcmp('leaveOut_calcAUC','leaveOut_calcAUC')
%% ==< calcAUC >==
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
%% ==</calcAUC >==
end
%%
for j0 = FROM:uF
  figure

  subplot(2,1,1)
  plot(1:uR, auc.A(j0,:),'o-','Color',myColor{j0},'LineWidth',2)
% plot_AUC(env,status,DAL,ansMat)
  ylabel('AUC')
  set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf,'ylim',[0.5 1])
  axis([1 uR .5 1.05]) % move figures to the left.
  xlabel('regularization factor')

  subplot(2,1,2)
  plot_CVLwhole(env,status,graph,DAL,CVL{1},j0)
  axis([1 uR 0 1e5/(j0.^5)]) % move figures to the left.

end
%{

%% for paper
if strcmp('for_publish','for_publish')
  if 1 == 1
    %% program started   : 2011-11-10-18:54:29, (firng,method) = (kim,aki)
    text(11.5 ,0.60,'\color{white}  240','fontsize',12,'BackgroundColor',myColor{1} );
    text(11.5 ,0.87,'\color{white}  500','fontsize',12,'BackgroundColor',myColor{2} );
    text( 9.4 ,0.89,'\color{white} 1000','fontsize',12,'BackgroundColor',myColor{3} );
    text( 7.1 ,0.83,'\color{white} 4000','fontsize',12,'BackgroundColor',myColor{4} );
    text( 5.5 ,0.88,'\color{white}10000','fontsize',12,'BackgroundColor',myColor{5} );
    text( 4.0 ,0.80,'\color{white}40000','fontsize',12,'BackgroundColor',myColor{6} );
    text( 3.0 ,0.88,'\color{white}75000','fontsize',12,'BackgroundColor',myColor{7} );

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
else
  legend(uFnum{FROM:uF},'Location','WestOutside')
  set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,200])
end

%}
