

fprintf(1,'\nplotting generated "True Values"\n\n')

%%% ===== PLOT alpha ===== START =====
if ( 1 == graph.PLOT_T )
  %% ++bug: func plot_alpha must be given 'env'.
  plot_alpha(graph,env,alpha,'response functions');
end
if graph.PRINT_T == 1
  print('-depsc','-tiff',[rootdir_ '/outdir/true_alpha.eps'])
end


%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(graph,env,lambda,'\lambda: Firing Rates [sec]');
  %%% ===== PLOT LAMBDA ===== END =====
  %% write out eps file
  if graph.PRINT_T == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_lambda.eps'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(status,graph,env,I,'I(t): Spikes [sec]')
  %%% ===== PLOT I(t) ===== END =====
  %% write out eps file
  if graph.PRINT_T == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_I.eps'])
  end
end
%%% ===== PLOT I(t) ===== START =====
