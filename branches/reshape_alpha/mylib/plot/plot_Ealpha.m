function plot_Ealpha(env,graph,Ealpha,title)
%%
%% Generate and plot estimated alpha.
%% INPUT)
%%
%% USAGE)
% plot_Ealpha(env,graph,Ealpha,title)
%%
global rootdir_
%global env;
%global graph;
cnum = env.cnum;
hnum = env.hnum;
hwind = env.hwind;
Hz = env.Hz.video;

SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;

%%% ===== PLOT alpha ===== START =====
if exist('gain') == 0
  gain = 1;
end

%% prohibit protting if the number of neurons is 
%% >= constant 'MAX' 
MAX=10;

Lnum = 3;
dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
TIMEL = cell(1,Lnum);
for i1 = 1:Lnum+1
  TIMEL{i1} = (i1-1)*ddh;
end

XSIZE = 2;
if cnum < MAX
  figure;
  i2to =1; % cell to
  i3from =1; % cell from
  for i1 = 1:cnum*cnum % subplot select
    if  graph.TIGHT == 1;
      axis tight;
    end
    grid on;
    set(gca,'Xlim',[0,hnum*hwind*XSIZE]);
    %{
    set(gca,'Ylim',[SELF_DEPRESS_BASE*gain-2,2]);
    %}
    subplot(cnum,cnum,i1);
    tmp1 = Ealpha{i2to}{i3from};
    if i2to == i3from
      %    tmp1 = tmp1 + Ebias{i2to};
    end
    if tmp1 > 0
      plot(tmp1,'r','LineWidth',3);
    elseif tmp1 < 0
      plot(tmp1,'b','LineWidth',3);
    else           
      plot(tmp1,'k','LineWidth',3);
    end
    %% </ chage color ploted according to cell type >
    %% no use in setting xlim and ylim if not before subplot.
    xlim([0,hnum*hwind*XSIZE]);  
    %{
    ylim([-SELF_DEPRESS_BASE*gain-2,2]);
    %}
    set(gca,'XAxisLocation','top');
    set(gca,'XTick' , 1:dh:hnum*hwind);
    set(gca,'XTickLabel',TIMEL);

    %% < from-to cell label >
    if (i2to == 1)     % When in the topmost margin.
      xlabel(i3from);
      xlim([0,hnum*hwind]);
    end
    if (i3from == 1) ylabel(i2to); % When in the leftmost margin.
    end
    %% </ from-to cell label >

    %% < index config >
    if (i3from == cnum ) i2to = i2to +1; i3from = 0; end % When in the righmost margin.
    i3from = i3from +1;
    %% </ index config >
  end
end
if  graph.TIGHT == 1;
  axis tight;
end
grid on; % for right-bottom subplot.
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

