%% usage)
% plot_graphviz
%%

%% ==< TODO >==
% add color representing the number of firing 'I'.
%% ==</TODO >==

if ~exist('rootdir_')
  warning('run ''setpaths.m'' existing in ''conf'' directory.')
end

run([rootdir_ '/conf/conf_graph.m']);

if exist('env') && isfield(env,'spar')
  tmp1connection = [];
  for i1 = 1:length(env.spar.from)
    tmp1connection = [tmp1connection; ... 
                      [num2str( env.spar.from(i1) ), ' -> ', ...
                       num2str( env.spar.to(i1)) , ';'] ...
                     ];
  end

  if env.spar.self == 1
    for i1 = 1:env.cnum
     tmp1connection = [tmp1connection; ...
                       [num2str( i1 ),' -> ', ...
                       num2str( i1 ),';'] ...
                      ];
    end
  end
  %>set output file name.
  filename = 'graphviz.dot'; % default output file name
  if exist('graph') && isfield(graph, 'GRAPHVIZ_NAME_DOT')
    filename = input(['Enter output file name\n (adding extension ' ...
                      '''.dot'' is recommaneded): '],'s');
  end
  if exist('rootdir_')
    filename = [rootdir_ '/outdir/' filename ];
  else % output dot file at current directory.
    ;
  end

  %% == write out ==
  tmp1fid = fopen(filename, 'w');
  fprintf(tmp1fid,'%s',sprintf('%s %s %s\n','digraph ', regexprep(regexprep(filename,'(.*/)(.*)','$2'),'\.','_') ,'{'));
  [nrows,ncols]= size(tmp1connection);
  for row=1:nrows
    fprintf(tmp1fid, '%s\n', tmp1connection(row,:) );
  end
  %  fprintf(tmp1fid,'%s','}\n');
  fprintf(tmp1fid,'%s',sprintf('%s\n','}'));
  fclose(tmp1fid);

  disp(sprintf('%s was wrote.\n',filename));


  if strcmp('clean','clean')
    run([rootdir_ '/mylib/clean.m']);
  end

  if graph.GRAPHVIZ_OUT_FIG == 1
    filename1 = regexprep(filename,'.dot','');
    %    command =    ['dot -Tpng ' filename ' -o ' filename1 '.eps' ];
    command =    ['dot -Teps ' filename ' -o ' filename1 '.eps' ];
    system(command);
  end
else
  warning('set variable ''env.spar'' ')
  warning('graphviz file wasn''t generated')
end
