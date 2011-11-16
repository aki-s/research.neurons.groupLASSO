%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','conf_user.m overrides all configuration variables set after this file.');

DEBUG_s = 'generate_firing'

DAL.regFac_UserDef = 1;
DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1 0.5 0.25 0.125];

switch DEBUG_s
  case 'generate_firing'    %Aki method Aki firing
    env.genLoop = 110000;
    graph.PLOT_T = 0;
  otherwise
    fprintf(1,['not_DEBUG_MODE -- set variables used to estimate ' ...
               'randomly generated network\n']);
end
env.SELF_DEPRESS_BASE = 6.5; % good. c.a. generate firing of 30Hz.
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
env.hwind = 1; % large hwind cause continuous firing of each neuron.
env.hnum = 100;
env.cnum = 5;
env.spar.level.from= .9; %++bug
env.spar.level.to  = .8; %++bug
env.Hz.video = 1000;

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 10; % num of neuron per window for connection matrix
graph.SAVE_ALL = 0;
graph.xrange = 1000;

status.realData = 0;
status.READ_NEURO_CONNECTION = 1;
status.GEN_TrueValues = 1;
status.estimateConnection = 1;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1; %++bug: not yet implemented.
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1;
status.use.GUI = 0; %++bug: not yet implemented.
status.profiler = 0; % run MATLAB profiler
