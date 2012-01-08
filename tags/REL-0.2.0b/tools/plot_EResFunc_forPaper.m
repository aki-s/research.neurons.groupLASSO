%function plot_EResFunc_forPapr(env,graph,EResFunc,ResFunc,title)
%%
%% USAGE)
%% Example:
% plot_EResFunc(env,graph,ResFunc,EResFunc,'title')
%%
global rootdir_

%%
S = load([rootdir_ '/outdir/15-Aug-2011-start-08/15-Aug-201108.mat']);
St = S.EResFunc{1};

ResFunc = S.ResFunc;

A = load([rootdir_ '/outdir/15-Aug-2011-start-23_6/15-Aug-201123_6.mat']);
At = A.EResFunc{1};

%%

NUM = 3;
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
%%% ===== PLOT ResFunc ===== START =====

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
  %  XSIZE = 2;
  XSIZE = 1;
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange = graph.prm.Yrange;
end
if cnum < MAX
  figure;
  i2to = 1; % cell to
  i3from = 1; % cell from
  for i1 = 1:NUM*NUM % subplot select
    subplot(NUM,NUM,i1);

    Aki_EResFunc = At{i2to}{i3from};
    TrueResFunc = ResFunc((1:hnum)+(i3from-1)*hnum,i2to);
    Stevenson_EResFunc = St{i2to}{i3from};
    %% <  chage color ploted according to cell type >
    if i2to == i3from
      %      ylim(diag_Yrange)
    end
    hold on;
    set(gcf,'color','white')

if strcmp('uneasy_to_watch','uneasy_to_watch_')
    plot(Aki_EResFunc,'r','LineWidth',1);
    plot(TrueResFunc,'--b','LineWidth',1);
    plot(Stevenson_EResFunc,'k','LineWidth',3);
else
    plot(Aki_EResFunc,'r','LineWidth',1);
    plot(TrueResFunc,'b','LineWidth',3);
    plot(Stevenson_EResFunc,'--k','LineWidth',1);
end
    %    plot( 1:hnum, 0, 'k','LineWidth',4); % emphasize 0.
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
      xlabel(i3from,'fontsize',15);
      %      xlim([0,hnum*hwind*XSIZE]);
    end
    if (i3from == 1) % When in the leftmost margin.
      ylabel(i2to,'fontsize',15); 
    end
    %% </ from-to cell label >

    %% < index config >
    if (i3from == NUM ) % When in the righmost margin.
      i2to = i2to +1; i3from = 0;
    end
    i3from = i3from +1;
    %% </ index config >
  end
end

%% h: description about outer x-y axis
%{
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
text(.12,.90,'Triggers')
text(.08,.85,'Targets')
%}


