function plot_I(graph,env,I,title)
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
global status
global Tout

genLoop = env.genLoop;
cnum = env.cnum;
hnum = env.hnum;
hwind = env.hwind;
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

for i1 = 1:Lnum+1
  if 1 == 1
    TIMEL{i1} = Tout.simtime - (Lnum+1 -i1)*ddh;
  else
    TIMEL{i1} = sprintf('%s [sec]',...
                        Tout.simtime - (Lnum+1 -i1)*ddh)
  end
end
%% ==</convert XTick unit from [frame] to [sec] >==

figure;
tmp1spacing = floor(genLoop/(hnum*hwind)) ;
for i1 = 1: cnum
  subplot( cnum, 1,i1)
  grid off;
  %% I(:,:): first hnum*wind history is all zero.
  if 1 == 1
    %bar( 1 :genLoop + hnum*hwind , I(:,i1))
    %  set(gca,'Xtick',-hnum*hwind+1:20:genLoop)
    %  set(gca,'Xtick',-hnum*hwind+1: tmp1spacing :genLoop)
  end
  ylim([0,1]);
  %%if status.DEBUG.plot == 1
% $$$   if status.DEBUG.level > 1
% $$$     %    xlim([hnum*hwind - 3, hnum*hwind + 3000]);
% $$$     bar( I(1:end,i1) );
% $$$     set(gca,'XTick' , 1:dh:FlameMax);
% $$$   else
    if genLoop > 100000
      warning('plot:xrange',['graph.xrange is too large. I''ve tweeked to appropriate ' ...
               'range.']);
      xlim([-hnum*hwind+1,genLoop/hnum]);
    else
      %      bar( 1:xrange , I((end+1 -xrange):end,i1))
      bar( I((end+1 -xrange):end,i1));
      %      xlim([genLoop-xrange,genLoop]);
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

