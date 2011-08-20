%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','conf_user.m overrides all configuration variables set after this file.');
DEBUG_s = 3

if 1 == 0
  status.READ_NEURO_CONNECTION = 0;
  env.cnum = 5;
  env.spar.level.from= .9;
  env.spar.level.to  = .8;
else
  status.READ_NEURO_CONNECTION = 1;
end

if 1 == 1
  DAL.regFac_UserDef = 1;
  %%
  % KFAM reflects DAL.regFac
  %DAL.regFac = [10 1 0.1 0.01] 
  DAL.regFac = [1000 100 50 10 1];
  %  DAL.regFac = [10 100000];
  %  DAL.regFac = [ 100000 10];
  %  DAL.regFac = [ 50 ];
  %DAL.regFac = [ exp(3) exp(2) exp(1)];
  %DAL.regFac = [3000  1000 300 ];
  % DAL.Drow = [2000 20000 90000]; %++yet
end
%DAL.Drow = 2000;

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 11;
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.SAVE_ALL = 0;
graph.xrange = 1000;

switch DEBUG_s
  case 0    %Aki method Aki firing
    env.genLoop = 110000;
    status.GEN_TrueValues = 1;
    status.estimateConnection = 1;
    env.hnum = 100;
    env.hwind = 1; % large hwind cause continuous firing of each neuron.
    env.Hz.video = 1000;
    graph.PLOT_T = 0;
  case 3 % Aki method Kim firing
    status.GEN_TrueValues = 0;
    status.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];
    status.READ_FIRING =1; % read kim FIRING.
    env.Hz.video=1000;
    graph.PLOT_T = 0;
  case 1
    %kim 
    env.genLoop = 100000;
    status.GEN_TrueValues = 1;
    
    env.hnum = 50;
    env.hwind = 1; % large hwind cause continuous firing of each neuron.
    env.Hz.video = 100;
  case 2
    env.genLoop = 400000;
    status.GEN_TrueValues = 1;
    env.hnum=1000;
    env.hwind=1;
    env.Hz.video=100;
  case 4 % compare aki and stevenson
    env.genLoop =  20000;
    status.GEN_TrueValues = 0;

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
    status.GEN_TrueValues = 1;

    env.hnum=50;
    env.hwind= 1; % large hwind cause continuous firing of each neuron.
    env.Hz.video=(100);
    status.estimateConnection = 1;
    graph.GRAPHVIZ_OUT_FIG = 0;
end

%{
env.Hz.neuro=;
env.Hz.fn=;
%}
% (1-exp(-exp(env.SELF_DEPRESS_BASE)/env.Hz.video))*env.Hz.video
%env.SELF_DEPRESS_BASE = 4.3; % 1 Hz
%env.SELF_DEPRESS_BASE = 10; % all cells always firing
%env.SELF_DEPRESS_BASE = 8; % o.k.
%env.SELF_DEPRESS_BASE = 7; % o.k. Hz % a little too much
env.SELF_DEPRESS_BASE = 6.5; % good.
                             %env.SELF_DEPRESS_BASE = 6; % o.k. 15Hz

% log(2) == 0.7
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

status.profiler = 1;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1; %++bug: not yet implemented.

status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1; %++bug: not yet implemented.
status.use.GUI = 0; %++bug: not yet implemented.