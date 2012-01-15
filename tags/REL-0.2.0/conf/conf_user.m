%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
%% 1: on , 0: off
%% ==< EDIT FOR YOURSELF >==
status.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];% set your mat file containing firing data.
env.inFiringLabel ='X'; % If format of 2-D matrix 'X' is (dimention1,dimention2) = (time,neuron)
env.inFiringDirect=1; % then env.inFiringDirect = 1. else if (dimention1,dimention2) = (neuron,time)
                      % then env.inFiringDirect = 2
env.genLoop = 130000;
env.useFrame = [2000 5000 50000]; % set num of frame used to estimate as vector(or scalar).
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp'; % notify the end of program.
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp'; % set your smtp server
%% ==</EDIT FOR YOURSELF >==

warning('DEBUG:conf','conf_user.m overrides all configuration variables set after this file.');
DEBUG_s = 'conf_user.m' % echo 'DEBUG_s', just for your attention to this file.

status.realData = 1; % notify program of read your firing
status.GEN_TrueValues = 0; % don't generate 
status.estimateConnection = 1; % estimate response function
status.mail = 1; % mail you
status.parfor_ = 1; % use palallelization tool box
status.crossVal_rough = 0; % skip re-calculation for speed up.

env.hwind = 1; % large hwind cause continuous firing of each neuron.
env.hnum = 100; % 
env.Hz.video = 1000; % [1/env.Hz.video sec per frame]

DAL.regFac_UserDef = 1;% notify that regularization factor is manually set
DAL.regFac = [1000 300 100 30 10 3];% regularization factor for group LASSO

graph.PLOT_MAX_NUM_OF_NEURO = 10; % neurons to be plotted per window
graph.PLOT_T = 1; % plot graph
graph.prm.Yrange = [-.5 5]; % yrange of plotted graph
graph.prm.diag_Yrange = [-.5 5];% yrange of plotted graph's diagonal element

%%%%% DEBUG: the following is a test
if 1 == 0
  env.cnum = 14;
  env.SELF_DEPRESS_BASE = 7; 
  env.spar.level.from= .5;
  env.spar.level.to  = .4;
  status.realData = 0;
  status.GEN_TrueValues = 1;
  status.crossVal_rough = 1;
  env.useFrame = [40000 50000];
  DAL.regFac = [1000 500 100];
  %%
  status.inFiring = ''; %++bug:obsolete. depulicated func as status.READ_NEURO_CONNECTION
  status.READ_NEURO_CONNECTION = 0; % gen random connection.
  %% if ~isempty(status.inFiring)
  %%  status.READ_NEURO_CONNECTION = 1; 
  %% end

  %% %%++bug: future
  %% if status.READ_NEURO_CONNECTION == 0
  %%  status.genRandomNetwork = 1;
  %% end
  %% 
  %% 

end
