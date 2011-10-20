warning('DEBUG:conf','conf_user_gaya.m.');

DAL.regFac_UserDef = 1;
DAL.regFac = [3000 2000 1500 1000 900 800 700 600 500 400 300];

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 15;
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.xrange = 1000;
graph.PLOT_T = 1;
graph.SAVE_ALL = 1;
graph.prm.Yrange = [-.5 5];
graph.prm.diag_Yrange = [-.5 5];

env.inFiringLabel ='I';
env.inFiringDirect = 2;
env.inFiringUSE = [10 20];
env.Hz.video=1000;
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

status.save_vars = 1;
status.realData = 1;
status.GEN_TrueValues = 0;
status.profiler = 1;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1; %++bug: not yet implemented.
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1; %++bug: not yet implemented.
status.use.GUI = 0; %++bug: not yet implemented.
status.READ_FIRING =1; % read gaya FIRING.
status.inFiring = ['/home/shige-o/rec072b.mat'];

