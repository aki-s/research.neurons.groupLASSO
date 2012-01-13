function plot_I(status,graph,env,I,title)
%%
%% input)
%% arg1 : 
%% arg2 : 
%% arg3 : 
%% arg4 : 
%% arg5 : 
%% arg6 : 
%%
%% Example)
% plot_I(status,graph,env,I,'title')
%%
DEBUG = 0;
PRESEN = 0;
%%
global envSummary

Hz = env.Hz.video;
xrange = graph.xrange;
cnum = env.cnum;
useNidx = status.usedNeuronIdx;
[FlameMax] = size(I,1);
if status.DEBUG.level > 2
  warning('DEBUG:xrange','Full plot of I');
  xrange = FlameMax;
end
%% ==< convert XTick unit from [frame] to [sec] >==
%++improve: share code with set_ResFunc_xticks()
Lnum = 3;% Lnum: number of xtick Label
dh = floor(xrange/Lnum);  %dh: width of each tick. [frame]
ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
TIMEL = cell(1,Lnum);

if ~isempty(envSummary)
  for i1 = 1:Lnum+1
    if 1 == 1
      TIMEL{i1} = envSummary.simtime - (Lnum+1 -i1)*ddh;
    else
      TIMEL{i1} = sprintf('%s [sec]',...
                          envSummary.simtime - (Lnum+1 -i1)*ddh);
    end
  end
end
%% ==</convert XTick unit from [frame] to [sec] >==

figure;
for i1 = 1: cnum
  subplot( cnum, 1,i1)
  if i1 ~= useNidx
    bar(zeros(1,xrange));
    legend('unsed spike train')
    if DEBUG > 0
      fprintf('x_')
    end
  else
    if DEBUG > 0
      fprintf('%d_',i1)
    end
    grid off;
    bar( I((end+1 -xrange):end,i1));
    set(gca,'XTick' , 1:dh:xrange);
    if PRESEN == 1
      set(gca,'XTickLabel','');
    else
      set(gca,'XTickLabel',TIMEL);
      ylabel(sprintf('%d',i1));
    end
    set(gca,'YTick',[]);
  end
  ylim([0,1]);
end
if DEBUG > 0
  fprintf('\n')
end
set(gcf,'color','white')
%% ==< set xlabel >==
h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
%% ==</ set xlabel >==
