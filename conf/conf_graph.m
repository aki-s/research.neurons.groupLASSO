%%% default graph options apply to all function
%%> gen_TrueBalue.m plot_alpha.m
if exist('graph')
  if ~isfield(graph,'PLOT_T')
    graph.PLOT_T = 1; % graph.PLOT_T: if (graph.PLOT_T == 1)
                      % then plot artificial (True) data.
  end
  if ~isfield(graph,'SAVE_EPS')
    graph.SAVE_EPS = 1; % save as eps pictures
  end
else
  graph = struct('PLOT_T',1, 'SAVE_EPS', 1);
end

graph.TIGHT =1;

%%> Free software graphviz setting
% Set other then null value if you want to 
% name output 'dot' file by yourself.
% Default outputfile name is graphviz.dot.
graph.Graphviz = 0;
