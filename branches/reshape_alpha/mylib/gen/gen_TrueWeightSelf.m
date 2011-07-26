function      [alpha0] = gen_TrueWeightSelf(env);

SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
cnum = env.cnum;
Hz = env.Hz;

%% alpha0: (1,cnum) matrix. correspond to auto firing of each cell.
env.Hz.neuro = exp(SELF_DEPRESS_BASE); %++bug

if 1
  alpha0 = repmat(SELF_DEPRESS_BASE,[1 cnum]);
elseif   strcmp('gen_individuality','gen_individuality')
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = Hz.fn*(1 + rand(1,cnum) ); % alpha0: self firing-depress weight.
else
  env.Hz.fn = env.Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = repmat(Hz.fn,1,cnum);
end
