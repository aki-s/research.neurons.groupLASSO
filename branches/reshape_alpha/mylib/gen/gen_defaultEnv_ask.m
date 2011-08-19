function gen_defaultEnv_ask()

global rootdir_
global env
global status

run([rootdir_ '/mylib/gen/gen_defaultEnv.m']);

if exist('status') && ( status.READ_NEURO_CONNECTION ~= 1 )
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
  spar.from = randperm(cnum); % spar.from: connenction from
  spar.from = spar.from(1:floor(spar.level.from*cnum));
  spar.to = randperm(cnum); % spar.to: connection to
  spar.to = spar.to(1:floor(spar.level.from*cnum));
  % Don't make sparse about self-depression.
  % Actual sparsity level is reduced by spar.level.dup.
  spar.level.dup = sum(spar.from == spar.to); %++bug: incorrect value.

  env.spar = spar;

end

if status.READ_NEURO_CONNECTION == 0
  if isfield(env,'cnum')
    cnum = env.cnum; % don't overwrite user defined env.cnum.
  else
    cnum = str2num(input('env.cnum:= ','s'));
  end
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



%% ==< clean variables >==
%  clear env; global env;

env.Hz   = Hz;   clear Hz;
env.hwind = hwind; clear hwind;
env.genLoop = genLoop; clear genLoop;
env.cnum = cnum; clear cnum;
env.hnum = hnum; clear hnum;

env.SELF_DEPRESS_BASE = SELF_DEPRESS_BASE; clear SELF_DEPRESS_BASE;
%% ==</ clean variables >==
%% ==</ CUSTOMIZE:gen_TrueValue.m >==
