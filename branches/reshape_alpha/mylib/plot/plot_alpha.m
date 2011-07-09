function plot_alpha(graph,env,alpha0,alpha,title);
%%
%% Usage:
%% arg1 == variable: graph
%% arg1 == variable: env
%% arg2 == variable: alpha0
%% arg3 == variable: alpha
%% arg4 == string: title of plotted window
%%
%% Example:
%  plot_alpha(graph,env,alpha0,alpha,'\alpha: Spatio-temporal Kernels');
%%

global rootdir_
cnum = env.cnum;
hnum = env.hnum;
SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
%%% ===== PLOT alpha ===== START =====

%% local var
MAX=10;
kdelta = inline('n == 0');
tmp1 = zeros(hnum,1);
if cnum < MAX
  figure;
  for i1 = 1:cnum %++parallel
    for i2 = 1:cnum;
      %%    axis tight;
      %% subplot() delete existing Axes property.
      subplot(cnum,cnum,(i1-1)*cnum+i2)
      hold on;
      %% < chage color ploted according to cell type >
      tmp1 = alpha((1:hnum)+(i2-1)*hnum,i1) + kdelta(i1-i2)*alpha0(i1);
      if tmp1 > 0
        plot( 1:hnum, tmp1,'r','LineWidth',3);
      elseif tmp1 < 0         
        plot( 1:hnum, tmp1,'b','LineWidth',3);
      else                    
        plot( 1:hnum, tmp1,'k','LineWidth',3);
      end

      plot( 1:hnum, 0, 'b','LineWidth',4);
      %% </ chage color ploted according to cell type >
      xlim([0,hnum]);
      ylim([-SELF_DEPRESS_BASE-1,2]);
      set(gca,'XAxisLocation','top');

      %% < from-to cell label >
      if (i1 == 1)     % When in the topmost margin.
        xlabel(i2);
      end
      if (i2 == 1) ylabel(i1); % When in the leftmost margin.
      end
      %% </ from-to cell label >
    end
  end
  %%  axis tight;
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
    print('-depsc', '-tiff' ,[rootdir_ 'artificial_alpha.eps'])
  end
else
  warning('Too large number of cells to plot.\n Plot aborted.')
end
