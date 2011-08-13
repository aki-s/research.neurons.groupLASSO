
warning('DEBUG:conf',['conf_user.m overrides all configuration ' ...
                    'variables set before this file.']);

kgraph.prm.Yrange      = [-.5,.5];
kgraph.prm.diag_Yrange = kgraph.prm.Yrange;
%kgraph.prm.diag_Yrange = [-1,1];
kgraph.SAVE_ALL = 1;

kDAL.opt.display = 0; % suppress solver from outputing state.

%kstatus.profiler = 1; profiler on;
