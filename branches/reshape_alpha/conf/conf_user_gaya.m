warning('DEBUG:conf','conf_user_gaya.m.');

DAL.regFac_UserDef = 1;
%DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 ];
DAL.regFac = [ 128 64 32 16 8];
%DAL.regFac = [30 10];

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 10;% #neuron to be plotted on a figure.
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.xrange = 1000;
graph.PLOT_T = 1;
graph.PRINT_T = 1;%save plotted figure.
graph.SAVE_ALL = 0;
graph.prm.Yrange = [-.5 5];
graph.prm.diag_Yrange = [-.5 5];

env.inFiringLabel = 's';
env.inFiringDirect = 2;
%env.inFiringUSE = [10 20];
env.inFiringUSE = [30 60];
env.Hz.video=1000; %++bug: lookes like set 'nan'
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
