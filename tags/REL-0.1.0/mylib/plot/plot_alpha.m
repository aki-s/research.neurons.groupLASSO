function plot_alpha(graph,env,alpha,title)
%%
%% Usage:
%% Example:
%  plot_alpha(graph,env,alpha,'\alpha: Spatio-temporal Kernels');
%%
%% == format ==
%% >> alpha
%% suppose the num. of neruon is 'N', length of response func is 'L'.
%%
%% -- format 1 --
%% alpha is (cnum*hnum,cnum) 2D matrix
%%   Idx\Idx || (to #1)   (to #2)  ...  (to #N-1)  (to #N) |
%% _________ ||_________ _________ ...  _________  ________|
%% |from #1  |||  1:L  | |  1:L  | ...  |  1:L  |  |  1:L  |
%% _________ ||_________ _________ ...  _________  ________|
%%    .      ||    .                                  .    |
%%    .      ||    .                                  .    |
%%    .      ||    .                                  .    |
%% |from #N-1||    .                                  .    |
%% _________ ||_________ _________ ...  _________  ________|
%% |from #N  |||  1:L  | |  1:L  | ...  |  1:L  |  |  1:L  |
%% _________ ||_________ _________ ...  _________  ________|
%%
%% -- format 2 --
%% alpha is (cnum,cnum,hnum) 3D matrix


DEBUG = 0;

if DEBUG == 1
  title = 'DEBUG';
end

global rootdir_

cnum = env.cnum;
hnum = env.hnum;
hwind = env.hwind;
Hz = env.Hz.video;

MAX = graph.PLOT_MAX_NUM_OF_NEURO;

%%% == useful func ==
%kdelta = inline('n == 0'); % kronecker's delta
%%% ===== PLOT alpha ===== START =====
if isnan(hwind)
  hwind = 1;
end
if isnan(hnum)
  hnum = size(alpha,3);
end
XSIZE = 1; % obsolete

if strcmp('set_xticks','set_xticks')
  Lnum = 2;
  dh = floor((hnum*hwind)/Lnum);
  ddh = dh/Hz; %  convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum);
  for i1to = 1:Lnum+1
    TIMEL{i1to} = (i1to-1)*ddh;
    %  TIMEL{i1to} = sprintf( '%.3d',(i1to-1)*ddh);
  end
end
if strcmp('set_range','set_range') && (graph.prm.auto ~= 1)
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange = graph.prm.Yrange;
  zeroFlag = 0;
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
else
  diag_Yrange = graph.prm.diag_Yrange_auto;
  Yrange      = graph.prm.Yrange_auto;     
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
  %    newYrange = round([ Yrange(1) diag_Yrange(2) ]*100)/100;
  if newYrange == 0
    newYrange = [-0.1 0.1 ];
    zeroFlag = 1;
  else
    zeroFlag = 0;
  end
end

if cnum < MAX
  if size(alpha,3) > 1 
    alphaH = sprintf('%s','shiftdim(alpha(i1to,i2from,:),2)');
  else
    alphaH = sprintf('%s','alpha((1:hnum)+(i2from-1)*hnum,i1to)');
  end
  figure;
  pos = [ .5 (cnum) 0 0 ]/(cnum+2);
  for i1to = 1:cnum %++parallel
    for i2from = 1:cnum;
      %% subplot() delete existing Axes property.
      subplot('position',pos + [i2from -i1to 1 1 ]/(cnum+3) );
      tmp1 = eval(alphaH);
      %% < chage color ploted according to cell type >
      set(gcf,'color','white')
      hold on;
      if tmp1 == 0
        zeroFlag = 1;
      elseif tmp1 > 0
        plot( 1:hnum, tmp1,'r','LineWidth',3);
      elseif tmp1 < 0         
        plot( 1:hnum, tmp1,'b','LineWidth',3);
      else
        plot( 1:hnum, tmp1,'k','LineWidth',3);
      end

      if (zeroFlag == 1)
        %  plot(nan);
        %        if (i1to ~= 1) && (i2from ~= 1)  % When in the topmost or leftmost margin.
        %        set(gca,'xticklabel',[]);
        set(gca,'yticklabel',[]);
        %        end
        zeroFlag = 0;
      else
        plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
        grid on;
        %% </ chage color ploted according to cell type >
        xlim([0,hnum*hwind*XSIZE]);
        if strcmp('sameYrange','sameYrange')
          ylim(newYrange);
          if zeroFlag == 1
            set(gca,'yticklabel',Y_LABEL);
          end
        else
          if i1to == i2from
            ylim(diag_Yrange)
          else
            ylim(Yrange);
          end
        end
      end
      if  graph.TIGHT == 1;
        axis tight;
      end
      set(gca,'XAxisLocation','top');
      set(gca,'XTick' , 1:dh:hnum);
      set(gca,'xticklabel',[]);
      Y_LABEL = get(gca,'yTickLabel');
      %% < from-to cell label >
      if (i1to == 1)     % When in the topmost margin.
        xlabel(i2from);
        set(gca,'XTickLabel',TIMEL);
      end
      if (i2from == 1) % When in the leftmost margin.
        ylabel(i1to);
      end
      %% </ from-to cell label >
    end
  end

  %% h: description about outer x-y axis
  h = axes('Position',[0 0 1 1],'Visible','off'); 
  set(gcf,'CurrentAxes',h)
  text(.4,.95,title,'FontSize',12,'LineWidth',4)
  %{
  text(.12,.90,'Triggers')
  text(.08,.85,'Targets')
  %}

  %{
  xlabel(h,'Trigger')
  ylabel(h,'Target')
  %}

  %%% ===== PLOT alpha ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc', '-tiff' ,[rootdir_ '/outdir/artificial_alpha.eps'])
  end
else
  fprintf(1,'graph.PLOT_MAX_NUM_OF_NEURO= %3d\n',graph.PLOT_MAX_NUM_OF_NEURO);
  warning('plot:aborted','Too large number of cells to plot.\n Plot aborted.')
end
