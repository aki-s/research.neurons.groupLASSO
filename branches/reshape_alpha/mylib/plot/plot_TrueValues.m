%%% ===== PLOT alpha ===== START =====
if ( 1 == graph.PLOT_T )
  %% ++bug: func plot_alpha must be given 'env'.
  plot_alpha(graph,env,alpha0,alpha,'\alpha: Spatio-temporal Kernels');
end
if graph.SAVE_EPS == 1
  print('-depsc','-tiff',[rootdir_ '/outdir/true_alpha.eps'])
end


%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(graph,env,lambda,'\lambda: Firing Rates [per frame]');
  %%% ===== PLOT LAMBDA ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_lambda.eps'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(graph,env,I,'I(t): Spikes [per frame]')
  %%% ===== PLOT I(t) ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_I.eps'])
  end
end
%%% ===== PLOT I(t) ===== START =====
