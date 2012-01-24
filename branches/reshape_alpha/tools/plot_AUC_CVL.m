function plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL,varargin)
%% plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL,varargin)
%%
%% usage)
% load('./outdir/some_out_data/allVarMat.m')
%% usage1)
% ansMat = '/home/aki-s/svn.d/art_repo2/branches/reshape_ResFunc/indir/sim_kim_ans.mat'
%% plot all
% plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL)
%% or, plot Index_of_env.useFrame
% plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL,Index_of_env.useFrame) 
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% usage2)
%% ansMat = ResFunc_fig %ResFunc_fig: matrix whose entry is 1 or 0.
% plot_AUC_CVL(env,status,graph,DAL,ansMat,CVL)

%%++todo: share code with plot_AUC.m
nargin_NUM = 6;
uR = length(DAL.regFac);
cSET.to = length(env.inFiringUSE);

%% ==<conf>==
if nargin >= nargin_NUM +1
  FROM = varargin{1};
else
FROM =1;
end
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
%% set frame range to be used.
if 1
  F = set_frameRange(nargin,nargin_NUM,FROM,status.validUseFrameIdx);
else
  if nargin > nargin_NUM % only one frame
    F.from = varargin{1};
    F.to = F.from;
  else % mix ALL
    F.from = 1;
    F.to = status.validUseFrameIdx;
  end
end

myColor = graph.prm.myColor;
if strcmp('plot_monochrome','plot_monochrome')
  myColor = cell(1,uR);
  for i1 = 1:uR
    myColor{i1} = [0 0 0];
  end
end
if isnumeric(ansMat)
  M_ans = ansMat;  
else
  load(ansMat,'M_ans');
end

uFnum = cell(1,F.to);
XLABEL = cell(1,F.to);
regFac = cell(1,uR);
inFiringUSE = cell(1,cSET.to);

for i1 =1:F.to
  uFnum{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  XLABEL{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
end
for i1 =1:uR
  regFac{i1} = num2str(sprintf('%09.4f',DAL.regFac(i1)));
end
XLABELrf = num2cell(DAL.regFac);
for i1 = 1:cSET.to
  inFiringUSE{i1} = num2str(sprintf('%03d',env.inFiringUSE(i1)));
end
fFNAME = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
inRoot = status.savedirname;
%% ==</conf>==
%% ==< calcAUC >==
if 1 == 1
  echo_AUCdescription(status.method,regFac,fFNAME,uFnum,inFiringUSE)
  [auc recr thresh0 ] = echo_AUC(status.method,regFac,fFNAME,uFnum,inFiringUSE,F,M_ans,status.savedirname);
elseif strcmp('leaveOut_calcAUC','leaveOut_calcAUC_')
  auc = zeros(F.to,uR);
  recr = zeros(F.to,uR,4);
  thresh0 = zeros(F.to,uR);

  spaceLen = length(sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{1}, ...
                            fFNAME, uFnum{F.from}, inFiringUSE{1}));

  fprintf(1,'LEGEND) TP:=True Positive, p:=positive, n:=negative\n')
  fprintf(1,['response func mat_file %s : (#)TP0  TPp  TPn  TPtotal'...
             ':(%%)TP0  TPp   TPn   TPtotal'...
             ': AUC threshold'...
             '\n'],...
          repmat(' ',[1 (spaceLen-28)]) )

  for j0 = F.from:F.to
    for i0 = 1:cSET.to
      for regFacIdx = 1:uR
        try
        filename =sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{regFacIdx}, ...
                          fFNAME, uFnum{j0}, inFiringUSE{i0});
        load( [inRoot '/' filename], 'EResFunc');

        catch err
          [inRoot]= strcat(inRoot,'/CV');
          filename =sprintf('%s-%s-%s-%s-%s-CV1.mat',status.method, regFac{regFacIdx}, ...
                          fFNAME, uFnum{j0}, inFiringUSE{i0});
          load( [inRoot '/' filename], 'EResFunc');
        end
        RFIntensity = evalResponseFunc( EResFunc );
        [recn, recr(j0,regFacIdx,1:4), thresh0(j0,regFacIdx) ,auc(j0,regFacIdx)] = evalRFIntensity(RFIntensity, M_ans);
        disp( sprintf( ['%20s:'...
                        ' %3d, %3d, %3d, %6d:'...
                        ' %5.1f, %5.1f, %5.1f, %5.1f:'...
                        ' %4.3f',...
                        ' %5.3f'],...
                       filename,...
                       recn, recr(j0,regFacIdx,1:4)*100,...
                       auc(j0,regFacIdx),...
                       thresh0(j0,regFacIdx)) );
      end
    end
    fprintf(1,'\n');
  end
  %% ==</calcAUC >==
end
%%
YRANGE_CVL = sum(median(CVL{1},1),2);
CHECK_EACH_RATE = 1;
CHECK_THRESHOLD = 1;
N = 2;
if CHECK_THRESHOLD == 1
  N = N+1;
end
if CHECK_EACH_RATE == 1
  N = N+1;
end

[maxVal]    = max(auc, [], 2);
[numMaxVal] = max(recr(:,:,4), [], 2);
for j0 = F.from:F.to
  maxIdx    = find(maxVal(j0)    == auc(j0,1:uR) );
  numMaxIdx = find(numMaxVal(j0) == recr (j0,1:uR,4) );
  figure

  subplot(N,1,1)
  plot_CVLwhole(env,status,graph,DAL,CVL{1},j0)
  %  axis([1 uR 0 1e5/(j0.^5)]) % move figures to the left.
  %  axis([1 uR 0 10]) % move figures to the left.
  %% good?
  %  axis([1 uR 0 100/(j0.^3)]) % move figures to the left./ adjust yrange
  %% good+?
  % axis([1 uR 1.e4/env.useFrame(j0) 1.e5/env.useFrame(j0) ])
  %% good++?
  axis([1 uR YRANGE_CVL(j0)*[.8 1.2] ])

  subplot(N,1,2)
  hold on;
  plot(1:uR, auc(j0,:),'o-','Color',myColor{j0},'LineWidth',2)
  ylabel('AUC')
  set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf,'ylim',[0.5 1])
  axis([1 uR .5 1.05]) % move figures to the left.
  xlabel('regularization factor')
  %% set diamond at maxIdx
  hLine2 = plot(maxIdx, auc(j0,maxIdx),'o-','color',myColor{j0},...
                'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine2,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');
  title(['max AUC : ',sprintf('%5.3f',auc(j0,maxIdx(1)))]);

  if CHECK_THRESHOLD == 1
    subplot(N,1,3)
    plot(1:uR, thresh0(j0,:),'o-','Color',myColor{j0},'LineWidth',2)
    set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,600])
    set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf)
    %    axis([1 uR 0 5]) % move figures to the left.
    axis([1 uR 0 20]) %for program started   : 2011-12-24-20:09:38
    xlabel('regularization factor')
    ylabel('threshold')
    title(['threshold avg@maxCorrectRate: ',sprintf('%6.3f',sum(thresh0(j0,numMaxIdx))/length(numMaxIdx))]);
  end

  if CHECK_EACH_RATE == 1
    subplot(N,1,4)
    hold on;
    %%TP0
    %    plot(1:uR,recr(j0,1:uR,1),'o-k','LineWidth',2)
    plot(1:uR,recr(j0,1:uR,1),'o-.k','LineWidth',2)
    %%TPp
    plot(1:uR,recr(j0,1:uR,2),'o--r','LineWidth',2)
    %%TPn
    plot(1:uR,recr(j0,1:uR,3),'o:b','LineWidth',2)
    %%TPtotal
    plot(1:uR,recr(j0,1:uR,4),'^-g','LineWidth',2)
    hLine3 = plot(numMaxIdx, recr(j0,numMaxIdx,4),'gd',...
                  'MarkerFaceColor','auto','MarkerSize',10,'LineWidth',2);
    set(get(get(hLine3,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','off');
    title(['max : ',sprintf('%5.3f',recr(j0,numMaxIdx(end),4))]);
% $$$   hLine4 = plot(maxIdx, auc(j0,maxIdx),'o-','color',myColor{j0},...
% $$$                 'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
% $$$   set(get(get(hLine2,'Annotation'),'LegendInformation'),...
% $$$       'IconDisplayStyle','off');
    xlabel('regularization factor')
    ylabel('correct rate')
    %  legend({'TP0','TPp','TPn'})
    axis([1 uR 0 1.05]) % move figures to the left.
    set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf,'ylim',[0 1.1])
  end

end

if 1 == 0
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
    legend(uFnum{F.from:F.to},'Location','WestOutside')
    set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,200])
  end

end
