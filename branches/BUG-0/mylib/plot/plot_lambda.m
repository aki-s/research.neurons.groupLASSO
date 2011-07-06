function plot_lambda(cnum,gen_lambda_loop,lambda,title);
%%
%% input)
%% cnum: number of cells
%% gen_lambda_loop: number of frames
%% lambda: 
%% title: title of the window
%%
%% usage)
% plot_lambda(env.cnum,env.gen_lambda_loop,lambda,'\lambda: Firing Rates
% [per frame]');
%%

figure; 
%     title('\lambda: Firing Rates');
set(gca,'XAxisLocation','top');
for i1 = 1:cnum
  subplot(cnum,1,i1)
  plot( 1:gen_lambda_loop, lambda(:,i1))
  grid on; ylim([0,max(max(lambda))]);
  ylabel(sprintf('%d',i1));
end

h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)