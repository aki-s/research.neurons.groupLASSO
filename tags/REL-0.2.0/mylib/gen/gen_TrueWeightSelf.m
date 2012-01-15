function      [ResFunc0] = gen_TrueWeightSelf(env,status)

global envSummary;

SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
cnum = env.cnum;
Hz = env.Hz;

%% ResFunc0: (1,cnum) matrix. correspond to auto firing of each cell.
env.Hz.neuro = exp(SELF_DEPRESS_BASE); %++bug

if (status.GEN_Neuron_individuality == 1 )
  if 1 == 1
    seeds = SELF_DEPRESS_BASE * (1 + 0.1*rand(1,cnum) );
  else % test
    seeds = SELF_DEPRESS_BASE * (1 + 0.05* [.1 .2 .3 .4 .1 .6 .7 .8 .9 .0] );
  end
  envSummary.hypoAutoFiringRate = (1-exp(-exp( seeds )/env.Hz.video))*env.Hz.video; 
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  ResFunc0 = env.Hz.fn * seeds ; % ResFunc0: self firing-depress weight.
else
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  ResFunc0 = repmat(env.Hz.fn,1,cnum);
end
