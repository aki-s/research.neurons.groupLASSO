%%% default graph options apply to all function
%%> gen_TrueBalue.m plot_alpha.m
if exist('graph')
  if ~isfield(graph,'PLOT_T') % precede user defined value.
    graph.PLOT_T = 1; % graph.PLOT_T: if (graph.PLOT_T == 1)
                      % then plot artificial (True) data.
  end
  if ~isfield(graph,'SAVE_EPS') % precede user defined value.
    graph.SAVE_EPS = 0; % save plotted figures as eps pictures
  end
  if ~isfield(graph,'TIGHT') % precede user defined value.
    graph.TIGHT = 1;
  end
else   %% defalut:
  graph = struct('PLOT_T',1, 'SAVE_EPS',0,'TIGHT',1);
end

%%> Free software graphviz setting
% Set other then null value if you want to 
% name output 'dot' file by yourself.
% Default outputfile name is graphviz.dot.
graph.Graphviz = 0; %++undone
