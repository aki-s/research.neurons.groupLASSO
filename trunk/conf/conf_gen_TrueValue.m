%% ==< CUSTOMIZE:gen_TrueValue.m >==
if strcmp('doTuning','doTuning')
  %% ==< plot >==
  %%  graph.PLOT_T = 1; % graph.PLOT_T: if (graph.PLOT_T == 1) then
  % plot artificial (True)  data.
  %%  graph.SAVE_EPS = 1; % save as eps pictures
  %% ==</ plot >==


  %% SET SPARSITY LEVEL ( 0 < sparse.level < 1 )
  %% < default values >
  spar = struct('from',[],'to',[],'level',[]);
  spar.level.from = .5;
  spar.level.to = .5;

  %< genLoop: number of frames of 'lambda'(neuronal firing
  %> rate per flame) to be generated. [frame]

  genLoop = 1000;

  %< hnum = HistSec * Hz.v / hwind
  hnum = 50; % hnum: the number of history window [frame]
  hwind = 2; % hwind: the number of frames in a history window

  cnum = 6;% cnum: number of cell

  Hz = struct('video',100, ... % video Hz: [frame/sec]
              'neuro',30, ...  % Hz of neuronal firing: [rate/sec]
              'fn',[]);    % Hz of firing per frame: [rate/frame]

  SELF_DEPRESS_BASE = 2;
%{
  spar.from = randperm(cnum); % spar.from: connenction from
  spar.from = spar.from(1:floor(spar.level.from*cnum));
  spar.to = randperm(cnum); % spar.to: connection to
  spar.to = spar.to(1:floor(spar.level.from*cnum));
  % Don't make sparse about self-depression.
  % Actual sparsity level is reduced by spar.level.dup.
  spar.level.dup = sum(spar.from == spar.to);
%}
  %% </ default values >

  %% Use user pre-defined variable 'env' if exist.
  %% Override program default values.
  if exist('env')

    if isfield(env,'Hz') && isfield(env.Hz,'video')
      Hz.video = env.Hz.video; % don't overwrite user defined env.Hz.video.
    else
      Hz.video = str2num(input('env.Hz.video:= ','s'));
      %      env.Hz.video = Hz.video;
    end

    if isfield(env,'genLoop')
      genLoop = env.genLoop; % don't overwrite user defined env.genLoop.
    else
      genLoop = str2num(input('env.genLoop:= ','s'));
      %      env.genLoop = genLoop;
    end

    if isfield(env,'hwind')
      hwind = env.hwind; % don't overwrite user defined env.hwind.
    else
      hwind = str2num(input('env.hwind:= ','s'));
      %      env.hwind = hwind;
    end

    if isfield(env,'hnum')
      hnum = env.hnum; % don't overwrite user defined env.hnum.
    else
      hnum = str2num(input('env.hnum:= ','s'));
      %      env.hnum = hnum;
    end

    if isfield(env,'cnum')
      cnum = env.cnum; % don't overwrite user defined env.cnum.
    else
      cnum = str2num(input('env.cnum:= ','s'));
      %      env.cnum = cnum;
    end

    if isfield(env,'SELF_DEPRESS_BASE')
      SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE; % don't overwrite user defined env.SELF_DEPRESS_BASE.
    else
      % SELF_DEPRESS_BASE = str2num(input('env.SELF_DEPRESS_BASE:= ','s'));
      % env.SELF_DEPRESS_BASE = SELF_DEPRESS_BASE;
      SELF_DEPRESS_BASE = str2num(input('env.SELF_DEPRESS_BASE:= ','s'));
    end

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
    %    env.spar = spar;
  end
end
  spar.from = randperm(cnum); % spar.from: connenction from
  spar.from = spar.from(1:floor(spar.level.from*cnum));
  spar.to = randperm(cnum); % spar.to: connection to
  spar.to = spar.to(1:floor(spar.level.from*cnum));
  % Don't make sparse about self-depression.
  % Actual sparsity level is reduced by spar.level.dup.
  spar.level.dup = sum(spar.from == spar.to);

  %% ==< clean variables >==
  env.Hz   = Hz;   clear Hz;
  env.hwind = hwind; clear hwind;
  env.genLoop = genLoop; clear genLoop;
  env.cnum = cnum; clear cnum;
  env.hnum = hnum; clear hnum;

  env.spar = spar; clear spar;
  env.SELF_DEPRESS_BASE = SELF_DEPRESS_BASE; clear SELF_DEPRESS_BASE;
  %% ==</ clean variables >==
%% ==</ CUSTOMIZE:gen_TrueValue.m >==
