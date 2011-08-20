function [Oenv Ostatus OTout Ograph ODAL] = check_conf(env,status,Tout,graph,bases,DAL)

Oenv    = env    ;
Ostatus = status ;
OTout   = Tout   ;
Ograph  = graph  ;
ODAL    = DAL    ;

if ( graph.SAVE_EPS == 1) && (graph.PLOT_T == 0 )
  warning('DEBUG:conf','configuration error. graph.SAVE_EPS=1 was deactivated.');
  Ograph.SAVE_EPS = 0;
end

if (status.READ_FIRING == 1)
% $$$   Ostatus.GEN_Neuron_individuality = NaN;
% $$$   Ostatus.GEN_TrueValues = NaN;
% $$$   Oenv.spar = NaN;
% $$$   Oenv.hnum = NaN;
% $$$   Oenv.hwind = NaN;
% $$$   Oenv.SELF_DEPRESS_BASE = NaN;
  if  (status.GEN_TrueValues == 1)
    warning('DEBUG:conf',['conflicts (status.READ_FIRING == 1) and  ' ...
                        '(status.GEN_TrueValues == 1). '...
                        'status.READ_FIRING was deactivated.']);
    error(' check your conf')
  end
elseif (status.GEN_TrueValues == 1)
  Tout.weightKernelSec = (env.hnum*env.hwind)/env.Hz.video;
  SEC = 0.05;
  if Tout.weightKernelSec < SEC % history kernel size [sec]
    fprintf(1,'Weight Kernel size seems to be small: %e [sec]\n',Tout.weightKernelSec);
    fprintf(1,'%s > %d seems to be appropriate.\n','(env.hnum*env.hwind)/env.Hz.video',SEC)
  end
  OTout.simtime = env.genLoop/env.Hz.video;
  OTout.weightKernelSec = (env.hnum*env.hwind)/env.Hz.video;
  %% AUTO firing rate in [sec]
  OTout.hypoAutoFiringRate =  (1-exp(-exp(env.SELF_DEPRESS_BASE)/env.Hz.video))*env.Hz.video; 
  Ostatus.inFiring = 'Aki';

end

if isfield(env,'Hz') && isfield(env.Hz,'video') % check ability of expression.
  if (bases.ihbasprs.NumFrame/env.Hz.video) < 0.1 
    warning(DEBUG:estimate,'range of bases seems to be small');
  end
end

if isfield(DAL,'Drow')
  Oenv.useFrame = DAL.Drow;
else
  ODAL.Drow = env.useFrame;
end
