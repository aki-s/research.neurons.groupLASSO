function      [alpha0] = gen_TrueWeightSelf(env);

global Tout;

SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
cnum = env.cnum;
Hz = env.Hz;

%% alpha0: (1,cnum) matrix. correspond to auto firing of each cell.
env.Hz.neuro = exp(SELF_DEPRESS_BASE); %++bug

if 0
  alpha0 = repmat(SELF_DEPRESS_BASE,[1 cnum]);
elseif   strcmp('gen_individuality','gen_individuality')
if 1 == 1
  seeds = SELF_DEPRESS_BASE * (1 + 0.1*rand(1,cnum) );
else
  seeds = SELF_DEPRESS_BASE * (1 + 0.05* [.1 .2 .3 .4 .1 .6 .7 .8 .9 .0] );
end
  Tout.hypoAutoFiringRate = (1-exp(-exp( seeds )/env.Hz.video))*env.Hz.video; 
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = env.Hz.fn * seeds ; % alpha0: self firing-depress weight.
else
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = repmat(Hz.fn,1,cnum);
end
