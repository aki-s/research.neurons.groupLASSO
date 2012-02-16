%% ++bug: This file shouldn't be distributed as library.
%%
%% Generate the figure comparing correct rate between Kim method
%% and Aki method.
%% Run this file at ./outdir/check_110818/
PAPER = 1;
FIG.W=800;
FIG.H=800;
%==< conf >==
DAL.regFac = [1000 100 50 10 1];
if 1
  L0 = [ 4 5 4 4 4 4]; % choose DAL.regFac
                       %DAL.regFac = [1 10 50 100 1000];
  env.useFrame = [
      5000 % 3
      10000 % 4
      20000 % 5
      50000 % 6
      90000 % 7
      100000 % 8
                 ];
  XTICKS = [ 5 10 20 50 90 100 ]*1000;
else
  L0 = [4 4 4 5 4 4 4 4]; % choose DAL.regFac
                          %DAL.regFac = [1 10 50 100 1000];
  env.useFrame = [
      1000 % 1 
      2000 % 2 
      5000 % 3
      10000 % 4
      20000 % 5
      50000 % 6
      90000 % 7
      100000 % 8
                 ];
  XTICKS = [ 1 2 5 10 20 50 90 100 ]*1000;
end

status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/Simulation/data_sim_9neuron.mat';
load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat') % M_ans

%==</ conf >==

uF = length(XTICKS);
uR = length(DAL.regFac);
for i1 =1:uF
  N000{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  %  N000L{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
  N000L{i1} = num2str(sprintf('%f',log10(env.useFrame(i1))));
end
for i1 =1:uR
  L000{i1} = num2str(sprintf('%07d',DAL.regFac(i1)));
end

FNAMEf = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
%%%%%%%%%%%%%%%%%%%%%%%%
AkiAcc = zeros(uF,4);
auc.A = zeros(1,uF);
auc.K = auc.A;

for N1 = 1:uF
  %Aki method Aki firing
  filename =sprintf('Aki-%s-%s-%s.mat', L000{L0(N1)}, FNAMEf, N000{N1});
  s = load( filename ); %load 'ResFunc' as 'Alpha'
  try
    ResFunc = s.Alpha;
  catch err
    %  ResFunc = s.EResFunc;
  end
  Phi = evalResponseFunc( ResFunc );
  %  [recn, recr, thresh0,auc.A(1,N1)] = evalRFIntensity_omitDiag(Phi, M_ans);
  [recn, recr, thresh0,auc.A(1,N1)] = evalRFIntensity(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) );
  AkiAcc(N1,:) = recr*100;
end

fprintf(1,'\n');

%% ==< test >== %++bug: There seems to be hiding a bug here?
for N1 = 1:uF
  for reg = 1:uR
    filename =sprintf('Aki-%s-%s-%s.mat', L000{reg}, FNAMEf, N000{N1});
    load( filename ); %ResFunc
    Phi = evalResponseFunc( ResFunc );
    [recn, recr, thresh00,auc.tmp] = evalRFIntensity(Phi, M_ans);
    disp( sprintf( '%20s: %3d, %3d, %3d, %3d,: %5.1f, %5.1f, %5.1f, %5.1f, :%f',...
                   filename, recn, recr*100, auc.tmp) );
    %    AkiAcc(N1,:) = recr*100;
  end
  fprintf(1,'=====================================\n');
end
%% ==</test>==

KimAcc = zeros(uF,4);
for N1 = 1:uF
  filename = sprintf('Kim-%s-%s.mat', FNAMEf, N000{N1});
  load( filename ); % Phi
                    %  [recn, recr, thresh0,auc.K(1,N1)] = evalRFIntensity(Phi, M_ans);
  [recn, recr, thresh0,auc.K(1,N1)] = evalRFIntensity_omitDiag(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) )
  KimAcc(N1,:) = recr*100;
end


% recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
% recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(Phi)];

A0 = [4,1,2,3];
%ylabels ={'Total', 'Specificity', 'Excitatory', 'Inhibitory'};
TITLES ={'Accuracy', 'Null connection', 'Excitatory', 'Inhibitory'};
ylabs = {'Accuracy', '','Accuracy',''};
YTICKSLAB = {[0 50 100],[],[0 50 100],[]};
XTICKSTITLE = {'','','Duration [ms]','Duration [ms]'};
N = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%div2 = N; %number of figure to be created.
%div2 = 4; % tested when div2=1,2,4
div2 = 1; % tested when div2=1,2,4
j = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NN = N/div2;
rNN = N/div2/j;
div = 0;
h = cell(1,N);
if strcmp('2x2','2x2_')

else
  for ii = 1:(div2)
    figure
    for i = 1:NN
      subplot(rNN,j,i)
      hold on;
      h{i} = plot(XTICKS, AkiAcc(:, A0(i+div) ),'o-b',...
                  XTICKS, KimAcc(:, A0(i+div) ), 'x--r','LineWidth',2);
      set(gca,'xscale','log')
      %      xlabel('Duration [ms]')
      if ( ii == 1 ) && ( i <= 2 )
        %        axis([0 XTICKS(end) 45 105])
        axis([0 XTICKS(end) 0 105])
      elseif ( ii >= 3 ) || ( i >= 3 )
        axis([0 XTICKS(end) 0 105])
      else

      end
      if PAPER
        set(findobj('Type','line'),'Color','k'); %decolor
        %%        ylabel([0.5 1])
        %a=uint32(floor(median(XTICKS)))
        %whos a
        %      set(gca, 'XTick', [1 uF], 'XTickLabel', N000L{[1 uF]})
        %      set(gca, 'XTick', [1 4 uF], 'XTickLabel', N000L{[1 4 uF]})
        %        set(gca,'xscale','log')
        %        set(gca,'xtick',[])
        title( TITLES{i+div})
        ylabel( ylabs{i+div})
        set(gca,'yticklabel',YTICKSLAB{i+div});
        xlabel(XTICKSTITLE{i+div})
      else
        set(gca, 'XTick', XTICKS, 'XTickLabel', N000L)
        ylabel( ylabels{i+div})
        xlabel( '# Frames' )
      end
    end
% $$$     if j == 1
% $$$       set(gcf, 'Color', 'White', 'Position',[200,200,400,800/div2+100])
% $$$     else
% $$$       set(gcf, 'Color', 'White', 'Position',[200,200,400,800/j/div2])
% $$$       %      set(gcf, 'Color', 'White', 'Position',[200,200,700,300])
% $$$     end
    if j == 1
      set(gcf, 'Color', 'White', 'Position',[200,200,FIG.W,FIG.H/div2+100])
    else
      set(gcf, 'Color', 'White', 'Position',[200,200,FIG.W,FIG.H/j/div2])
      %      set(gcf, 'Color', 'White', 'Position',[200,200,700,300])
    end
    div = div + NN;
  end
end
hh = legend(h{1},{'our method','Kim et al.'},'location','south');
legend(hh,'boxoff')
%set(h1,'Position',[.5,.5,.1,.2]);

%% AUC
figure
hold on;
if PAPER
  h2 = cell(1,2);
  h2{1} = plot(XTICKS, auc.A,'o-k','LineWidth',2);
  h2{2} = plot(XTICKS, auc.K,'x--k','LineWidth',2);
  legend([h2{1},h2{2}],{'our method','Kim et al.'},'location','southeast');
  legend('boxoff')
  set(gca,'xscale','log')
  %  set(findobj('Type','line'),'Color','k'); %decolor
  %  set(findobj('Type','line','-or','Type','marker','-or','Type','MarkerEdgeColor'),'Color','k'); %decolor
  %  set(findall(gcf),'Color','k'); %decolor
  %  set(gca,'xtick',[],'ytick',[0.5 1])
  set(gca,'ytick',[0.5 1])
  xlabel('Duration [ms]')
else
  plot(XTICKS, auc.A,'o-b','LineWidth',2,'MarkerEdgeColor','b');
  plot(XTICKS, auc.K,'x--r','LineWidth',2,'MarkerEdgeColor','r');
  set(gca, 'XTick', XTICKS, 'XTickLabel', N000L)
  xlabel('# Frames')
  axis([0 uF 0.45 1.05])
end
axis([0 XTICKS(end) 0.45 1.05])
ylabel('AUC')
set(gcf, 'Color', 'White', 'Position',[400,400,400,400])

save_plottedGraphAll('110818_AROB_','./')
