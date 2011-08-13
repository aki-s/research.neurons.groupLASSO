function plot_alpha_ternary(graph,env,alpha_hash,description)
%% 
% plot_alpha_binary(graph,env,alpha_hash)
%% 

cnum = env.cnum;
MAX = graph.PLOT_MAX_NUM_OF_NEURO;
N = 50;

%map = colormap;
map = colormap('gray');
S = .9;
SS = .8;
if cnum < MAX
  figure;
  for i1to = 1:cnum %++parallel
    base = [1 cnum-i1to 0 0]/(cnum+2);
    for i2from = 1:cnum;
      %% subplot() delete existing Axes property.
if 1 == 0
      subplot(cnum,cnum,(i1to-1)*cnum+i2from)
else
      %      norm = [.0 .01 0 0];
      %      norm = norm + [i2from*S i1to*S .9 .9]/cnum;
      %      norm = [i2from*SS (cnum-i1to)*S SS SS]/cnum
      norm = base + [i2from*SS SS SS SS]/cnum;
      subplot('Position',norm);
end
      tmp1 = N* (alpha_hash((i1to-1)*cnum+i2from) +1 );
      %% < chage color ploted according to cell type >
      if i1to == i2from
        %        graph.param.alphaY = max(tmp1);
      end
      hold on;

      %      subimage( tmp1)
      subimage( tmp1,map)

      set(gca,'xtick',[],'ytick',[]);
      %% </ chage color ploted according to cell type >
      if i1to == i2from

      else

      end
      if  graph.TIGHT == 1;
        axis tight;
      end
      set(gca,'XAxisLocation','top');

      %% < from-to cell label >
      if (i1to == 1)     % When in the topmost margin.
        xlabel(i2from,'fontsize',25);
      end
      if (i2from == 1) % When in the leftmost margin.
        ylabel(i1to,'fontsize',25);
      end
      %% </ from-to cell label >
    end
  end
  %% h: description about outer x-y axis
  h = axes('Position',[0 0 1 1],'Visible','off'); 
  set(gcf,'CurrentAxes',h)
  text(.12,.93,'Triggers','fontsize',25,'LineWidth',3) %++bug LineWidth
  text(.08,.88,'Targets' ,'fontsize',25,'LineWidth',3)
  text(.4,.95,description,'fontsize',25,'LineWidth',3);

  %{
  xlabel(h,'Trigger')
  ylabel(h,'Target')
  %}

else
  warning('plot:aborted','Too large number of cells to plot.\n Plot aborted.')
end
