function gen_defaultEnv_ask()

global rootdir_
global env
global status

run([rootdir_ '/mylib/gen/gen_defaultEnv_preset.m']);

if exist('status') && ( status.GEN_TrueValues == 1 )
  if isfield(env,'spar') && isfield(env.spar,'level') && isfield(env.spar.level,'from')
    spar.level.from = env.spar.level.from; % don't overwrite user defined env.spar.level.from
  else
    spar.level.from = str2num(input('env.spar.level.from (0< <1):= ','s'));
  end

  if isfield(env,'spar') && isfield(env.spar,'level') && isfield(env.spar.level,'to')
    spar.level.to = env.spar.level.to; % don't overwrite user defined env.spar.level.to
  else
    spar.level.to = str2num(input('env.spar.level.to (0< <1):= ','s'));
  end
  if isfield(env,'cnum')
    cnum = env.cnum;
  end
  spar.from = randperm(cnum);
  spar.from = spar.from(1:floor(spar.level.from*cnum));
  spar.to = randperm(cnum); % spar.to: connection receive rate
  spar.to = spar.to(1:floor(spar.level.from*cnum));
  % Don't make sparse about self-depression.
  % Actual sparsity level is reduced by spar.level.diag
  spar.level.diag = sum(spar.from == spar.to)/cnum; %++bug: incorrect value.

  env.spar = spar;

end

if isfield(env,'cnum')
  cnum = env.cnum; % don't overwrite user defined env.cnum.
else
  cnum = str2num(input('env.cnum:= ','s'));
end

if isfield(env,'genLoop')
  genLoop = env.genLoop; % don't overwrite user defined env.genLoop.
else
  genLoop = str2num(input('env.genLoop:= ','s'));
end

if isfield(env,'hnum')
  hnum = env.hnum; % don't overwrite user defined env.hnum.
else
  hnum = str2num(input('env.hnum:= ','s'));
end

if isfield(env,'hwind')
  hwind = env.hwind; % don't overwrite user defined env.hwind.
else
  hwind = str2num(input('env.hwind:= ','s'));
end

if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz.video = env.Hz.video; % don't overwrite user defined env.Hz.video.
else
  Hz.video = str2num(input('env.Hz.video:= ','s'));
end

if isfield(env,'SELF_DEPRESS_BASE')
  SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE; % don't overwrite user defined env.SELF_DEPRESS_BASE.
else
  SELF_DEPRESS_BASE = str2num(input('env.SELF_DEPRESS_BASE:= ','s'));
end
if ~isfield(env,'useFrame') & ( status.crossVal <= 1 )
  env.useFrame = genLoop; % assume inFiring is all usable and use all firing
elseif ~isfield(env,'useFrame') & ( status.crossVal > 1 )
  tmp = env.genLoop;
  cv = status.crossVal;
  while mod(tmp,cv) % devide in equal size.
    tmp = tmp -1;
  end
  tmp = tmp * (cv-1) / cv;

  env.useFrame = floor(tmp* (cv - 1 )/ cv);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
env.Hz   = Hz;   clear Hz;
env.hwind = hwind; clear hwind;
env.genLoop = genLoop; clear genLoop;
env.cnum = cnum; clear cnum;
env.hnum = hnum; clear hnum;

env.SELF_DEPRESS_BASE = SELF_DEPRESS_BASE;

