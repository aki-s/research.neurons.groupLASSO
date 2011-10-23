%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','conf_user_kim.m overrides all configuration variables set after this file.');

DEBUG_s = 'realData'

DAL.regFac_UserDef = 1;
DAL.regFac = [1400 1300 1200 1100 1000 900 800];

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 15;
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.xrange = 1000;
%% extra
graph.PLOT_T = 1;
graph.SAVE_ALL = 1;
graph.prm.Yrange = [-.5 5];
graph.prm.diag_Yrange = [-.5 5];

env.inFiringLabel ='X';
env.inFiringDirect = 2;
env.Hz.video=1000;
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
env.useFrame = [
        100000
        150000
               ];

status.save_vars = 1;
status.realData = 1;
status.GEN_TrueValues = 0;
status.READ_FIRING =1; % read kim FIRING.
status.profiler = 0;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1;
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1; %++bug: not yet implemented.
status.use.GUI = 0; %++bug: not yet implemented.
%status.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];
status.inFiring = [ rootdir_ ['/indir/Real_data/' ...
                    'data_real_catM1.mat']];
