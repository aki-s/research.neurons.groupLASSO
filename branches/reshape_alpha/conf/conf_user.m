%% Set freely your configuration.
warning('DEBUG:conf','conf_user.m overrides all configuration variables set after this file.');
DEBUG_s = 4


graph.TIGHT = 0;
graph.PLOT_T = 1;
graph.PLOT_MAX_NUM_OF_NEURO = 11;
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.xrange = 1000;

env.cnum = 9;
env.spar.level.from= .9;
env.spar.level.to  = .8;

switch DEBUG_s
  case 1
    %kim only
    env.genLoop = 100000;
    status.GEN_TrureValues = 0;

    env.hnum = 50;
    env.hwind = 2; % large hwind cause continuous firing of each neuron.
    env.Hz.video = 100;
  case 2
    env.genLoop = 400000;
    status.GEN_TrureValues = 1;
    env.hnum=1000;
    env.hwind=1;
    env.Hz.video=100;
  case 3
    env.genLoop = 200000;
    status.GEN_TrureValues = 1;

    env.hnum=50;
    env.hwind = 1; % large hwind cause continuous firing of each neuron.
    env.Hz.video=1000;
    status.estimateConnection = 1;
  case 4
    env.genLoop =  20000;
    status.GEN_TrureValues = 1;

    if 1 == 0
      % load to plot() is heavy. && one neuron depress firing of others.
      % This cause error.
      env.hnum=(3000);
    elseif 1 == 0
      env.hnum = 300;
    elseif 1 == 1
      env.hnum=100;
    else
      env.hnum=(50);
    end
    env.hwind=(1); % large hwind cause continuous firing of each neuron.
    env.Hz.video=(1000);
    status.estimateConnection = 1;
    graph.GRAPHVIZ_OUT_FIG = 1;
  case 5
    env.genLoop =  2000;
    status.GEN_TrureValues = 1;

    env.hnum=(300);
    env.hwind= 2; % large hwind cause continuous firing of each neuron.
    env.Hz.video=(100);
    status.estimateConnection = 1;
    graph.GRAPHVIZ_OUT_FIG = 1;
end

%{
env.Hz.neuro=;
env.Hz.fn=;
%}
% (1-exp(-exp(env.SELF_DEPRESS_BASE)/env.Hz.video))*env.Hz.video
%env.SELF_DEPRESS_BASE = 4.3; % 1 Hz
%env.SELF_DEPRESS_BASE = 10; % all cells always firing
%env.SELF_DEPRESS_BASE = 8; % o.k.
env.SELF_DEPRESS_BASE = 7; % o.k. Hz
%env.SELF_DEPRESS_BASE = 6; % o.k. 15Hz

% log(2) == 0.7
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

status.profiler = 1;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1; %++bug: not yet implemented.

if 1 == 0
  status.READ_NEURO_CONNECTION = 0;
else
  status.READ_NEURO_CONNECTION = 1;
end
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 0; %++bug: not yet implemented.
status.use.GUI = 0; %++bug: not yet implemented.