function plot_I(graph,env,I,title)
%%
%% input)
%% arg1 : the number of cells
%% arg2 : the number of all generated frames 
%% arg3 : the number of variable 'wind'
%% arg4 : the number of frames each 'wind' has.
%% arg5 : variable I representing nurons' fring.
%% arg6 : string. plot window title.
%%
%% Example)
% plot_I(env.cnum,env.gen_lambda_loop,env.hnum,env.wind,I,'title')
%%
gen_lambda_loop = env.genLoop;
cnum = env.cnum;
hnum = env.hnum;
wind = env.hwind;
xrange = graph.xrange;

DEBUG =1;

figure;
tmp1spacing = floor(gen_lambda_loop/hnum) ;
for i1 = 1:cnum
  subplot(cnum,1,i1)
  %% I(:,:): first hnum*wind history is all zero.
    bar( 1 :gen_lambda_loop + hnum*wind , I(:,i1))
    %  set(gca,'Xtick',-hnum*wind+1:20:gen_lambda_loop)
    set(gca,'Xtick',-hnum*wind+1: tmp1spacing :gen_lambda_loop)
  grid off;
  ylim([0,1]);
if DEBUG == 1
    xlim([hnum*wind - 3, hnum*wind + 3000]);
else
  if gen_lambda_loop > 100000
    warning(['graph.xrange is too large. I''ve tweeked to appropriate ' ...
             'range.']);
    xlim([-hnum*wind+1,gen_lambda_loop/hnum]);
  else
    xlim([0,xrange]);
  end
end
  ylabel(sprintf('%d',i1));
end

%% ==< set xlabel >==
h = axes('Position',[0 0 1 1],'Visible','off');
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
%% ==</ set xlabel >==
