function [Oenv Ostatus OTout Ograph ODAL] = check_conf(env,status,Tout,graph,bases,DAL)

Oenv    = env    ;
Ostatus = status ;
OTout   = Tout   ;
Ograph  = graph  ;
ODAL    = DAL    ;

if (graph.PLOT_T == 0 ) && ( graph.SAVE_EPS == 1) %++obsolete
  warning('DEBUG:conf','configuration error. graph.SAVE_EPS=1 was deactivated.');
  Ograph.SAVE_EPS = 0;
elseif (graph.PLOT_T == 0 ) && (graph.PRINT_T == 1 )
  Ograph.PRINT_T = 0; 
  %%++refactoring
  %% if (graph.PLOT_T) == 1
  %%   if (graph.PRINT_T) == 1
  %%   end
  %% end
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
  Ostatus.GEN_Neuron_individuality = '';%++bug?
  if ( status.realData == 1)
    %%    Ostatus.GEN_Neuron_individuality = '';
    Ostatus.GEN_TrueValues = '';
    Ostatus.READ_NEURO_CONNECTION = '';
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
elseif isfield(status,'crossVal')
  tmp = Oenv.genLoop;
  k = status.crossVal;
  while mod(tmp,k)
    tmp = tmp -1;
  end
  DALmax = tmp * (k-1) / k;
  if isfield(env,'useFrame')
    before = length(env.useFrame);
    ODAL.Drow = env.useFrame(env.useFrame<=DALmax);
    if (before ~= length(ODAL.Drow) )
      warning('DEBUG:notice','demanded frame is large to do cross validation\n make smaller than env.genLoop *(status.crossVal-1)/(status.crossVal)');
    end
  else 
    ODAL.Drow = DALmax;
    Oenv.useFrame = DALmax;
  end
else
  ODAL.Drow = env.useFrame;
end
