
warning('DEBUG:conf',['conf_user.m overrides all configuration ' ...
                    'variables set before this file.']);

kgraph.prm.Yrange      = [-.5,.5];
kgraph.prm.diag_Yrange = kgraph.prm.Yrange;
%kgraph.prm.diag_Yrange = [-1,1];
kgraph.SAVE_ALL = 1;


%kstatus.profiler = 1; profiler on;

global kDAL
kDAL = conf_DAL;
kDAL.opt.display = 1; % suppress solver from outputing state.
kDAL.regFac_UserDef = 1;
kDAL.regFac = [100 50 10 5]; %++bug?
% kDAL.Drow = [2000 20000 90000]; %++yet
kDAL.Drow = 2000
