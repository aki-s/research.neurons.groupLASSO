function plot_AUC(env,status,DAL,ansMat,varargin)
%%
%%
%% usage)
% load('./outdir/some_out_data/allVarMat.m')
% ansMat = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat'
% plot_AUC(env,status,DAL,ansMat)
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.

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

nargin_NUM = 4;
if nargin > nargin_NUM % only one frame
  FROM = varargin{1};
  uF = FROM;
else % mix ALL
  FROM = 1;
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
%%%%%%%%%%%%%%%%%%%%%%%%
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
for j0 = FROM:uF %++bug: duplicate j0,i0 ?
  for i0 = 1:cSET
    for regFacIdx = 1:uR
      filename =sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{regFacIdx}, ...
                        fFNAME, uFnum{j0}, inFiringUSE{i0});
      load( [inRoot '/' filename], 'Alpha');
      RFint = evalResponseFunc( Alpha );
      [recn, recr, thresh0 ,auc.A(j0,regFacIdx)] = evalRFint(RFint, M_ans);
      disp( sprintf( '%20s: %3d, %3d, %3d, %6d: %5.1f, %5.1f, %5.1f, %5.1f: %2.1f',...
                     filename, recn, recr*100, auc.A(j0,regFacIdx)) );
      rate(regFacIdx,1:4,j0) = recr*100;
    end
  end
  fprintf(1,'\n');
end

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
color = zeros(uF,3);
for j1 = 1:uF
  color(j1,:) = rand(1,3);
  while ( color(j1,1) > .6 ) && ( color(j1,2) > .6 )
    color(j1,:) = rand(1,3);
  end
end
for ii = 1:(div2)
  figure
  %  hold on
  for i = 1:NN
    subplot(NN,1,i)
    hold on;
    for j1 = FROM:uF
      plot(1:uR, rate(:, A0(i+div),j1),'o-','Color',color(j1,:),'LineWidth',2)
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
%% AUC
figure
hold on;
grid on;
for j0 = FROM:uF
  plot(1:uR, auc.A(j0,:),'o-','Color',color(j0,:),'LineWidth',2)
end
ylabel('AUC')
set(gca, 'XTick', 1:uR, 'XTickLabel', XLABELrf)
xlabel('regularization factor')
axis([0 uR 0 1.05])
set(gcf, 'Color', 'White', 'Position',[WIDTH,800,WIDTH+150,200])
legend(uFnum{FROM:uF},'Location','WestOutside')


