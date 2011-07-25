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
% plot_I(
%%
global status
global Tout
DEBUG = 0;

genLoop = env.genLoop;
cnum = env.cnum;
hnum = env.hnum;
wind = env.hwind;
Hz = env.Hz.video;
xrange = graph.xrange;

%% ==< convert XTick unit from [frame] to [sec] >==
Lnum = 3;% Lnum: Label number
dh = (xrange/Hz)
TIMEL = cell(1,Lnum);
%for i1 = Lnum+1:-1:1
for i1 = 1:Lnum+1
  TIMEL{i1} = Tout.simsec - (Lnum+1 -i1)*dh;
end
%% ==</convert XTick unit from [frame] to [sec] >==

figure;
tmp1spacing = floor(genLoop/(hnum*hwind)) ;
for i1 = 1:cnum
  subplot(cnum,1,i1)
  %% I(:,:): first hnum*wind history is all zero.
    bar( 1 :genLoop + hnum*wind , I(:,i1))
    %  set(gca,'Xtick',-hnum*wind+1:20:genLoop)
    set(gca,'Xtick',-hnum*wind+1: tmp1spacing :genLoop)
  grid off;
  ylim([0,1]);
  %%if status.DEBUG.plot == 1
if DEBUG == 1
    xlim([hnum*wind - 3, hnum*wind + 3000]);
else
  if genLoop > 100000
    warning(['graph.xrange is too large. I''ve tweeked to appropriate ' ...
             'range.']);
    xlim([-hnum*wind+1,genLoop/hnum]);
  else
    xlim([genLoop-xrange,genLoop]);
    set(gca,'XTick' , 1:dh:hnum);
    set(gca,'XTickLabel',TIMEL);
  end
end
  ylabel(sprintf('%d',i1));
end

%% ==< set xlabel >==
h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
%% ==</ set xlabel >==
