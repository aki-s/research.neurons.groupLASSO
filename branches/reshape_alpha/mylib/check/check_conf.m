%function check_conf(env,status,Tout,graph);
function check_conf()

%{
global env
global status
global Tout
global graph
%}
global env
global status
global Tout
global graph

if ( graph.SAVE_EPS == 1) && (graph.PLOT_T == 0 )
  warning('configuration error. graph.SAVE_EPS=1 was deactivated.');
  graph.SAVE_EPS = 0;
end

Tout.weightKernelSec = (env.hnum*env.hwind)/env.Hz.video;
if Tout.weightKernelSec < 0.1 % history kernel size [sec]
  fprintf(1,'Weight Kernel size seems to be small: %d [sec]\n',Tout.weightKernelSec);
  fprintf(1,'%s > 0.1 seems to be appropriate.\n','(env.hnum*env.hwind)/env.Hz.video')
end

Tout.simtime = env.genLoop/env.Hz.video;

Tout.weightKernelSec = (env.hnum*env.hwind)/env.Hz.video;

%% AUTO firing rate in [sec]
Tout.hypoAutoFiringRate =  (1-exp(-exp(env.SELF_DEPRESS_BASE)/env.Hz.video))*env.Hz.video; 
