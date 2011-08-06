function plot_lambda(graph,env,lambda,title)
%%
%% input)
%% cnum: number of cells
%% gen_lambda_loop: number of frames
%% lambda: 
%% title: title of the window
%%
%% usage)
%plot_lambda(graph,env,lambda,'\lambda: Firing Rates [per frame]');
%%

global Tout;
global status;

cnum = env.cnum;
xrange = graph.xrange;

if status.DEBUG.level > 2
  warning('DEBUG:xrange','Full plot of lambda');
  xrange = FlameMax;
end

figure; 
set(gca,'XAxisLocation','top');
ylim( [0,10*mean(median(lambda))]);
%ylim( [0,4]);
%xlim([0,graph.xrange]);
%set(gca,'Xlim',[0,graph.xrange]);
for i1 = 1:cnum
  subplot(cnum,1,i1)
  set(gca,'Xlim',[0,graph.xrange]); %++bug:'don't work well.
  %%  plot( 1:gen_lambda_loop, lambda(:,i1))
  %  bar( 1:(env.hnum*env.hwind+gen_lambda_loop), lambda(:,i1))
  bar( lambda((end+1-xrange):end,i1))
  grid on;
  %  ylim([0,10 * max(median(lambda))]);
  ylim([0,min(Tout.FiringRate)*2 ]);
  ylabel(sprintf('%d',i1));
end

h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)