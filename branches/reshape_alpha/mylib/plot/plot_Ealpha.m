function plot_Ealpha(env,graph,Ealpha,title)
%%
%% USAGE)
%% Example:
% plot_Ealpha(env,graph,alpha,Ealpha,'title')
%%

DEBUG = 0;

if DEBUG == 1
  title = 'DEBUG';
end

global rootdir_

cnum = env.cnum;
if isfield(env,'hnum')
  hnum = env.hnum;
else
  hnum = 1000;
end
if isfield(env,'hwind')
  hwind = env.hwind;
else
  hwind = 1;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end

MAX = graph.PLOT_MAX_NUM_OF_NEURO;

%%% == useful func ==
%kdelta = inline('n == 0'); % kronecker's delta
%%% ===== PLOT alpha ===== START =====

if strcmp('set_xticks','set_xticks')
  Lnum = 2;
  dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
  ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum);
  for i1 = 1:Lnum+1
    TIMEL{i1} = (i1-1)*ddh;
  end
end

if strcmp('set_range','set_range')
  XSIZE = 2;
  %  tmp1 = alpha((1:hnum)+(i2from-1)*hnum,i1to);
  %  tmp1 = alpha((1:hnum),1);
  %  diag_Yrange = [min(tmp1)*1.5, max(tmp1)*1.5];
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange = graph.prm.Yrange;
end
if cnum < MAX
  figure;
  i2to = 1; % cell to
  i3from = 1; % cell from
  for i1 = 1:cnum*cnum % subplot select
    subplot(cnum,cnum,i1);
    tmp1 = Ealpha{i2to}{i3from};
    %% <  chage color ploted according to cell type >
    if i2to == i3from
      %      ylim(diag_Yrange)
    end
    hold on;

    if tmp1 > 0
      plot(tmp1,'r','LineWidth',3);
    elseif tmp1 < 0
      plot(tmp1,'b','LineWidth',3);
    else           
      plot(tmp1,'k','LineWidth',3);
    end

    plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
    grid on;
    %% </ chage color ploted according to cell type >
    xlim([0,hnum*hwind*XSIZE]);  
    if i2to == i3from
      ylim(diag_Yrange)
    else
      ylim(Yrange);
    end
    if  graph.TIGHT == 1;
      axis tight;
    end
    set(gca,'XAxisLocation','top');
    set(gca,'XTick' , 1:dh:hnum*hwind);
    set(gca,'XTickLabel',TIMEL);

    %% < from-to cell label >
    if (i2to == 1)     % When in the topmost margin.
      xlabel(i3from);
      %      xlim([0,hnum*hwind*XSIZE]);
    end
    if (i3from == 1) % When in the leftmost margin.
      ylabel(i2to); 
    end
    %% </ from-to cell label >

    %% < index config >
    if (i3from == cnum ) % When in the righmost margin.
      i2to = i2to +1; i3from = 0;
    end
    i3from = i3from +1;
    %% </ index config >
  end
end

%% h: description about outer x-y axis
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
text(.12,.90,'Triggers')
text(.08,.85,'Targets')

%{
xlabel(h,'Trigger')
ylabel(h,'Target')
%}

%%% ===== PLOT alpha ===== END =====
%% write out eps file
if graph.PLOT_T == 1
  print('-depsc','-tiff', [rootdir_ '/outdir/Estimated_alpha.eps'])
end

