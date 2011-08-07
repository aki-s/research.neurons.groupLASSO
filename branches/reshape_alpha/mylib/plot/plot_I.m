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
% plot_I(graph,env,I,'title')
%%

%%
global Tout

genLoop = env.genLoop;
cnum = env.cnum;
Hz = env.Hz.video;
xrange = graph.xrange;

[FlameMax cnum] = size(I);
if status.DEBUG.level > 2
  warning('DEBUG:xrange','Full plot of I');
 xrange = FlameMax;
end
%% ==< convert XTick unit from [frame] to [sec] >==
Lnum = 3;% Lnum: number of xtick Label
dh = floor(xrange/Lnum);  %dh: width of each tick. [frame]
ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
TIMEL = cell(1,Lnum);

if exist(Tout)
for i1 = 1:Lnum+1
  if 1 == 1
    TIMEL{i1} = Tout.simtime - (Lnum+1 -i1)*ddh;
  else
    TIMEL{i1} = sprintf('%s [sec]',...
                        Tout.simtime - (Lnum+1 -i1)*ddh);
  end
end
end
%% ==</convert XTick unit from [frame] to [sec] >==

figure;
for i1 = 1: cnum
  subplot( cnum, 1,i1)
  grid off;
  ylim([0,1]);
  %%if status.DEBUG.plot == 1
    if genLoop > 100000
      warning('plot:xrange',['graph.xrange is too large. I''ve tweeked to appropriate ' ...
               'range.']);
      bar( I((end+1 -graph.xrange):end,i1));
    else
      bar( I((end+1 -xrange):end,i1));
      set(gca,'XTick' , 1:dh:xrange);
      set(gca,'XTickLabel',TIMEL);
    end
% $$$   end
  ylabel(sprintf('%d',i1));
end

%% ==< set xlabel >==
h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)

text(.4,.95,title,'FontSize',12)

%% ==</ set xlabel >==

