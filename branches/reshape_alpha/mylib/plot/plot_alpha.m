function plot_alpha(graph,env,alpha,title)
%%
%% Usage:
%% Example:
%  plot_alpha(graph,env,alpha,'\alpha: Spatio-temporal Kernels');
%%

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
if strcmp('set_range','set_range')
  XSIZE = 2;
  %  tmp1 = alpha((1:hnum)+(i2from-1)*hnum,i1to);
% $$$   tmp1 = alpha((1:hnum),1);
% $$$   diag_Yrange = [min(tmp1)*1.5, max(tmp1)*1.5];
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange = graph.prm.Yrange;
end
if cnum < MAX
  figure;
  for i1to = 1:cnum %++parallel
    for i2from = 1:cnum;
      %% subplot() delete existing Axes property.
      subplot(cnum,cnum,(i1to-1)*cnum+i2from)
      tmp1 = alpha((1:hnum)+(i2from-1)*hnum,i1to);
      %% < chage color ploted according to cell type >
      if i1to == i2from
        %        graph.param.alphaY = max(tmp1);
      end
      hold on;

      if tmp1 > 0
        plot( 1:hnum, tmp1,'r','LineWidth',3);
      elseif tmp1 < 0         
        plot( 1:hnum, tmp1,'b','LineWidth',3);
      else                    
        plot( 1:hnum, tmp1,'k','LineWidth',3);
      end

      plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
      grid on;
      %% </ chage color ploted according to cell type >
      xlim([0,hnum*hwind*XSIZE]);
      if i1to == i2from
        ylim(diag_Yrange)
      else
        ylim(Yrange);
      end
      if  graph.TIGHT == 1;
        axis tight;
      end
      set(gca,'XAxisLocation','top');
      set(gca,'XTick' , 1:dh:hnum);
      set(gca,'XTickLabel',TIMEL);

      %% < from-to cell label >
      if (i1to == 1)     % When in the topmost margin.
        xlabel(i2from);
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
  text(.12,.90,'Triggers')
  text(.08,.85,'Targets')

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
  warning('plot:aborted','Too large number of cells to plot.\n Plot aborted.')
end
