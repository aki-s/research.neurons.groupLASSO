

fprintf(1,'\nplotting generated "True Values"\n\n')

%%% ===== PLOT ResFunc ===== START =====
if ( graph.PLOT_T == 1 )
  plot_ResFunc(graph,env,ResFunc,'response functions',status.savedirname,'ResponseFunc_generated');
end

%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(graph,env,lambda,'\lambda: Firing Rates [sec]');
  %%% ===== PLOT LAMBDA ===== END =====
  if graph.PRINT_T == 1
    print('-dpng',[status.savedirname '/FiringRate_generated.png'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(status,graph,env,Iorg,'I(t): Spikes [sec]')
  %%% ===== PLOT I(t) ===== END =====
  if graph.PRINT_T == 1
    print('-dpng',[status.savedirname '/SpikeTrain_generated.png'])
  end
end
%%% ===== PLOT I(t) ===== START =====
