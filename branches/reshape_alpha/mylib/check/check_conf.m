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
  if (bases.ihbasprs.numFrame/env.Hz.video) < 0.1 
    warning('DEBUG:estimate','range of bases seems to be small');
  end
end

%% limit of useFrame
if isfield(env,'useFrame') 
  %% check for variable reduction method.
  ODAL.Drow = env.useFrame;
  %  validIdx = ODAL.Drow > bases.ihbasprs.numFrame;
  validIdx = (env.genLoop >= ODAL.Drow)&(ODAL.Drow > bases.ihbasprs.numFrame);
  Oenv.useFrame = ODAL.Drow(validIdx);
  %% check relations between the length of bases and the length DAL.Drow
  if length(Oenv.useFrame) ~= sum(validIdx)
    warning('DEBUG:autoChange',['env.useFrame (%d) is smaller than bases.ihbasprs.numFrame=%s '...
                        '. invalidated!']...
            , ODAL.Drow( logical(ODAL.Drow.*(~validIdx) > 0 ))...
            , bases.ihbasprs.numFrame ...
            )
  end
  if isempty(Oenv.useFrame) %++bug?
    error('Properly set env.useFrame')
  end
  if ( min(Oenv.useFrame) - bases.ihbasprs.numFrame ) < 1000 
    %% 1000 is set about
    warning('DEBUG:WARNING','env.useFrame is too small for estimation.')
  end
  %  if (Ostatus.GEN_TrueValues == 1) && ( length(Oenv.useFrame) <=
  %  1)
  if (Ostatus.GEN_TrueValues == 1) & ( length(Oenv.useFrame) <=  1)
if  (env.useFrame == env.genLoop)
    error(['Generated firing is not reliable at small time frame. Properly ' ...
           'set env.useFrame at configuration file.'])
end
  end
end

if status.crossVal > 1
  tmp = Oenv.genLoop;
  k = status.crossVal;
  while mod(tmp,k)
    tmp = tmp -1;
  end
  DALmax = tmp * (k-1) / k;
  %% check for cross valication.
  if isfield(env,'useFrame')
    idxUSE = (env.useFrame<=DALmax );
    ODAL.Drow = env.useFrame(idxUSE);
    if ( ~idxUSE )
      warning('DEBUG:autoChange',[ '''env.useFrame'' is '...
              'too large to do cross validation\n'...
                          'make smaller than env.genLoop *' ...
                          '(status.crossVal-1)/(status.crossVal)\n'...
                          'diabled env.useFrame=[%d]',(~idxUSE).*ENV.useFrame]);
  if length(ODAL.Drow) <= 1  %++bug?
    error('Properly set env.useFrame')
  end
    end
  else 
    ODAL.Drow = DALmax;
    Oenv.useFrame = DALmax;
  end
else
  ODAL.Drow = env.useFrame; %++++++++++++++++++++++++++++++++++++++++++++duplicate
end

ODAL = check_DALregFac(ODAL,bases.ihbasprs.nbase); % ++bug?

%% auto color scaling
Oenv.useFrameLen = length(Oenv.useFrame);
if length(graph.prm.myColor) ~= Oenv.useFrameLen
  Ograph.prm.myColor = setMyColor(Oenv.useFrameLen);
end

if status.diary ~= 1
  rmdir([status.savedirname,'/',sprintf('%d_',status.time.start),'diary.txt'])
end

if isfield(env,'inFiringUSE')
  Oenv.useNeuroLen = length(env.inFiringUSE);
else
  Oenv.useNeuroLen = 1;
  env.inFiringUSE = env.cnum;
end
for i1 = 1:env.useNeuroLen
  Ostatus.time.regFac{i1} = zeros(Oenv.useFrameLen,ODAL.regFacLen);
end
