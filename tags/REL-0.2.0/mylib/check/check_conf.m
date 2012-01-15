function [Oenv Ostatus OenvSummary Ograph ODAL] = check_conf(env,status,envSummary,graph,bases,DAL)

Oenv    = env    ;
Ostatus = status ;
OenvSummary   = envSummary   ;
Ograph  = graph  ;
ODAL    = DAL    ;

if (graph.PLOT_T == 0 ) && ( graph.SAVE_EPS == 1) %++obsolete
  warning('DEBUG:conf','configuration error. graph.SAVE_EPS=1 was deactivated.');
  Ograph.SAVE_EPS = 0;
elseif (graph.PLOT_T == 0 ) && (graph.PRINT_T == 1 )
  Ograph.PRINT_T = 0; 
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
  OenvSummary.effectiveHistorySec = (env.hnum*env.hwind)/env.Hz.video;
  SEC = 0.1; % SEC [<sec>] == SEC/env.Hz.video [ 1/env.Hz.video*<sec> ]
  %%  SEC = 0.05; % SEC [<sec>] == SEC/env.Hz.video [ 1/env.Hz.video*<sec> ]
  if OenvSummary.effectiveHistorySec < SEC % history kernel size [sec]
    fprintf(1,'History size which have efflect on the next firing seems to be small: %e [sec]\n',OenvSummary.effectiveHistorySec);
    fprintf(1,'%s > %d seems to be appropriate.\n','(env.hnum*env.hwind)/env.Hz.video',SEC)
  end
  if env.genLoop < 40000 % threshold from huristic knowledge
    warning('DEBUG:estimation','Time of simulation may be small')
  end
  OenvSummary.simtime = env.genLoop/env.Hz.video;
  OenvSummary.effectiveHistorySec = (env.hnum*env.hwind)/env.Hz.video;
  %% AUTO firing rate in [sec]
  OenvSummary.hypoAutoFiringRate =  (1-exp(-exp(env.SELF_DEPRESS_BASE)/env.Hz.video))*env.Hz.video; 
  if (status.realData == 1)%++bug?
    error(['confliction: Do you want to estimate with realData or ' ...
           'with simulation data?'])
  end
end

if isfield(env,'Hz') && isfield(env.Hz,'video') % check ability of expression.
  if (bases.ihbasprs.numFrame/env.Hz.video) < 0.1 
    warning('DEBUG:estimation','range of bases seems to be small');
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
  if isempty(Oenv.useFrame)
    error(['Properly set env.useFrame to be env.genLoop - bases.ihbasprs.numFrame > env.useFrame > than bases.ihbasprs.numFrame'])
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
                          'diabled env.useFrame=[%d]',(~idxUSE).*env.useFrame]);
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
  Ograph.prm.myColor = set_myColor(Oenv.useFrameLen);
end

if status.diary ~= 1
  rmdir([status.savedirname,'/',sprintf('%d_',status.time.start),'diary.txt'])
end

if isfield(env,'inFiringUSE')
  Oenv.useNeuroLen = length(env.inFiringUSE);
else % use all neurons. (This is a default config.)
  Oenv.useNeuroLen = 1;
  Oenv.inFiringUSE = env.cnum;
end
if ~isfield(status,'inFiring')
  env.inFiringLabel = '';
  env.inFiringDirect='';
end

if strcmp('save_calctime','save_calctime_')%++bug
  Ostatus.time.regFac = cell(1,Oenv.useNeuroLen);
  for i1 = 1:Oenv.useNeuroLen
    Ostatus.time.regFac{i1} = zeros(Oenv.useFrameLen,ODAL.regFacLen);
  end
else %++bug: not useable when 'length(env.inFiringUSE) > 1' is.
  Ostatus.time.regFac = zeros(Oenv.useFrameLen,ODAL.regFacLen);
end

if 1==0%++bug: debugging now
  if ~strcmp(lower(status.inFiring),'aki')
    try 
      load(status.inFiring)
    catch err

    end
  end
end

if status.crossVal_rough ~= 0
        ODAL.tmpLdir = 'CV';
else
        ODAL.tmpLdir = '';
end
