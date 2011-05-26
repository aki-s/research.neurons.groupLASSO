function plot_loglambda(env,loglambda,title);
%%
%% input)
%% env.cnum: number of cells
%% env.gen_lambda_loop: number of frames
%% loglambda: 
%% title: title of the window
%%
%% usage)
% plot_loglambda(env,loglambda,'log \lambda: [per frame]');
%%

figure; 
set(gca,'XAxisLocation','top');
for i1 = 1:env.cnum
  subplot(env.cnum,1,i1)
  plot( 1:env.gen_lambda_loop, loglambda(:,i1))
  grid on; ylim([min(min(loglambda)),max(max(loglambda))]);
  ylabel(sprintf('%d',i1));
end

h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)