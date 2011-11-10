function [Ograph] = conf_graph()
%%% default Ograph options apply to all function
%%> gen_TrueBalue.m plot_alpha.m
global graph

Ograph = graph;
if exist('Ograph')
  if ~isfield(Ograph,'OGRAPHVIZ_NAME_DOT')
    %% 0: name output dot file as 'Ographviz.dot'.
    Ograph.OGRAPHVIZ_NAME_DOT=0;
  end
  if ~isfield(Ograph,'OGRAPHVIZ_OUT_FIG')
    %% 0: output eps file from Ographviz dot file.
    Ograph.OGRAPHVIZ_OUT_FIG=0;
  end
  if ~isfield(Ograph,'PLOT_MAX_NUM_OF_NEURO') % precede user defined value.
    Ograph.PLOT_MAX_NUM_OF_NEURO = 10;
  end
  if ~isfield(Ograph,'PLOT_T') % precede user defined value.
    Ograph.PLOT_T = 1; % Ograph.PLOT_T: if (Ograph.PLOT_T == 1)
                      % then plot artificial (True) data.
  end
  %%+bug: duplicate function? PRINT_T SAVE_EPS
  %% When you mail Ograph data, print as eps is inconvenient.
  %% SAVE_EPS is almost obsolete.
  if ~isfield(Ograph,'PRINT_T') % precede user defined value.
    Ograph.PRINT_T = 0; 
  end
  if ~isfield(Ograph,'SAVE_EPS') % precede user defined value.
    Ograph.SAVE_EPS = 0; % save plotted figures as eps pictures
  end
  if ~isfield(Ograph,'SAVE_ALL') % precede user defined value.
    Ograph.SAVE_ALL = 0;
  end
  if ~isfield(Ograph,'TIGHT') % precede user defined value.
    Ograph.TIGHT = 0; % 0: each Ograph is plotted with absolute scale.
  end
  if ~isfield(Ograph,'prm')
    Ograph.prm.Xrange      = [0,0.2];
    Ograph.prm.Yrange      = [-2,2];
    Ograph.prm.diag_Yrange = [-10,3];
    Ograph.prm.Yrange_auto = Ograph.prm.Yrange;
    Ograph.prm.diag_Yrange_auto = Ograph.prm.diag_Yrange;
    Ograph.prm.auto = 1;
  end
else   %% defalut:
  Ograph = struct('PLOT_T',1 ...
                 ,'PRINT_T',0 ...
                 ,'PLOT_MAX_NUM_OF_NEURO',10' ...
                 , 'SAVE_EPS',0 ...
                 , 'SAVE_ALL',0 ...
                 ,'TIGHT',0 ...
                 ,'prm.Xrange',[0,0.3] ...
                 ,'prm.Yrange',[-2,2] ...
                 ,'prm.diag_Yrange',[0,0] ...
                 ,'prm.Yrange_auto',[0,0] ...
                 ,'prm.diag_Yrange_auto',[0,0] ...
                 ,'Ograph.prm.auto', 1 ...
                 );
end

%%> Free software Ographviz setting
% Set other then null value if you want to 
% name output 'dot' file by yourself.
% Default outputfile name is Ographviz.dot.
Ograph.Ographviz = 0; %++undone
Ograph.xrange=2000; %x plot range of Ograph.
