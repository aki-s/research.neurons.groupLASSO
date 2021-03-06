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

%% limit of useFrame
if isfield(env,'useFrame') 
  %% check for variable reduction method.
  ODAL.Drow = env.useFrame;
  %  validIdx = ODAL.Drow > bases.ihbasprs.NumFrame;
  validIdx = (env.genLoop > ODAL.Drow)&(ODAL.Drow > bases.ihbasprs.NumFrame);
  Oenv.useFrame = ODAL.Drow(validIdx);
  if length(Oenv.useFrame) ~= sum(validIdx)
    warning('DEBUG:autoChange',['regularization factor more than bases.ihbasprs.NumFrame=%s '...
            'is invalidated']...
            ,bases.ihbasprs.NumFrame,ODAL.Drow( logical(ODAL.Drow.*(~validIdx) > 0 ))...
                                               )
  end

end
if isfield(status,'crossVal')
  tmp = Oenv.genLoop;
  k = status.crossVal;
  while mod(tmp,k)
    tmp = tmp -1;
  end
  DALmax = tmp * (k-1) / k;
  %% check for cross valication.
  if isfield(env,'useFrame')
    before = length(env.useFrame);
    ODAL.Drow = env.useFrame(env.useFrame<=DALmax);
    if (before ~= length(ODAL.Drow) )
      warning('DEBUG:autoChange','demanded frame is large to do cross validation\n make smaller than env.genLoop *(status.crossVal-1)/(status.crossVal)');
    end
  else 
    ODAL.Drow = DALmax;
    Oenv.useFrame = DALmax;
  end
else
  ODAL.Drow = env.useFrame;
end

if ~isfield(env,'inFiringUSE') % num. of use neuron (subset)
  env.inFiringUSE = env.cnum;
end

%% auto color scaling
useFrameLen = length(env.useFrame);
if length(graph.prm.myColor) ~= useFrameLen
  Ograph.prm.myColor = setMyColor(useFrameLen);
end
