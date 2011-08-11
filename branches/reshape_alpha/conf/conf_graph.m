function [graph] = conf_graph()
%%% default graph options apply to all function
%%> gen_TrueBalue.m plot_alpha.m

global graph;

if exist('graph')
  if ~isfield(graph,'GRAPHVIZ_NAME_DOT')
    %% 0: name output dot file as 'graphviz.dot'.
    graph.GRAPHVIZ_NAME_DOT=0;
  end
  if ~isfield(graph,'GRAPHVIZ_OUT_FIG')
    %% 0: output eps file from graphviz dot file.
    graph.GRAPHVIZ_OUT_FIG=0;
  end
  if ~isfield(graph,'PLOT_MAX_NUM_OF_NEURO') % precede user defined value.
    graph.PLOT_MAX_NUM_OF_NEURO = 10;
  end
  if ~isfield(graph,'PLOT_T') % precede user defined value.
    graph.PLOT_T = 1; % graph.PLOT_T: if (graph.PLOT_T == 1)
                      % then plot artificial (True) data.
  end
  if ~isfield(graph,'PRINT_T') % precede user defined value.
    graph.PRINT_T = 0; 
  end
  if ~isfield(graph,'SAVE_EPS') % precede user defined value.
    graph.SAVE_EPS = 0; % save plotted figures as eps pictures
  end
  if ~isfield(graph,'SAVE_ALL') % precede user defined value.
    graph.SAVE_ALL = 0;
  end
  if ~isfield(graph,'TIGHT') % precede user defined value.
    graph.TIGHT = 0; % 0: each graph is plotted with absolute scale.
  end
  graph.prm.Yrange      = [-5,5];
  graph.prm.diag_Yrange = [-40,10];
else   %% defalut:
  graph = struct('PLOT_T',1 ...
                 ,'PRINT_T',0 ...
                 ,'PLOT_MAX_NUM_OF_NEURO',10' ...
                 , 'SAVE_EPS',0 ...
                 , 'SAVE_ALL',0 ...
                 ,'TIGHT',0 ...
                 );
end

%%> Free software graphviz setting
% Set other then null value if you want to 
% name output 'dot' file by yourself.
% Default outputfile name is graphviz.dot.
graph.Graphviz = 0; %++undone
graph.xrange=2000; %x plot range of graph.
