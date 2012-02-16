if  (graph.prm.auto ~= 1) %% set yrange manually.
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange      = graph.prm.Yrange;
  zeroFlag = 0;
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
  fprintf('^auto \n\n\n')
else % you'd better collect max and min range of response functions
     % in advance.
  fprintf('auto \n\n\n')
  diag_Yrange = graph.prm.diag_Yrange_auto;
  Yrange      = graph.prm.Yrange_auto;     
  newYrange = [ min(Yrange(1),diag_Yrange(1))/3 max(Yrange(2),diag_Yrange(2)) ];
  if newYrange == 0
    newYrange = [-0.1 0.1 ];
    zeroFlag = 1;
  else
    zeroFlag = 0;
  end
end
