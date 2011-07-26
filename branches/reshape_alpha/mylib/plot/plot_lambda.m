function plot_lambda(graph,env,lambda,title);
%%
%% input)
%% cnum: number of cells
%% gen_lambda_loop: number of frames
%% lambda: 
%% title: title of the window
%%
%% usage)
% plot_lambda(graph,env,lambda,'\lambda: Firing Rates
% [per frame]');
%%

gen_lambda_loop = env.genLoop;
cnum = env.cnum;

figure; 
set(gca,'XAxisLocation','top');
ylim( [0,mean(median(lambda))]);
%ylim( [0,4]);
%xlim([0,graph.xrange]);
%set(gca,'Xlim',[0,graph.xrange]);
for i1 = 1:cnum
  subplot(cnum,1,i1)
  set(gca,'Xlim',[0,graph.xrange]); %++bug:'don't work well.
  %%  plot( 1:gen_lambda_loop, lambda(:,i1))
  %  bar( 1:(env.hnum*env.hwind+gen_lambda_loop), lambda(:,i1))
  bar( lambda(:,i1))
  grid on;
  ylim([0,max(max(lambda))]);
  ylabel(sprintf('%d',i1));
end

h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)