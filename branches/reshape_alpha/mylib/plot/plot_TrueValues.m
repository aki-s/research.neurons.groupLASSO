

fprintf(1,'\nplotting generated "True Values"\n\n')

%%% ===== PLOT ResFunc ===== START =====
if ( 1 == graph.PLOT_T )
  %% ++bug: func plot_ResFunc must be given 'env'.
  plot_ResFunc(graph,env,status.savedirname,ResFunc,'response functions');
end
if graph.PRINT_T == 1
  print('-depsc','-tiff',[status.savedirname '/true_responseFunc.eps'])
end


%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(graph,env,lambda,'\lambda: Firing Rates [sec]');
  %%% ===== PLOT LAMBDA ===== END =====
  %% write out eps file
  if graph.PRINT_T == 1
    print('-depsc','-tiff',[status.savedirname '/artificial_FiringRate.eps'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(status,graph,env,I,'I(t): Spikes [sec]')
  %%% ===== PLOT I(t) ===== END =====
  %% write out eps file
  if graph.PRINT_T == 1
    print('-depsc','-tiff',[status.savedirname '/artificial_SpikeTrain.eps'])
  end
end
%%% ===== PLOT I(t) ===== START =====
