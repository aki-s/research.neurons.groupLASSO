%%++improve: share code with 'set_subplot_variables.m'
% $$$ if DEBUG == 1
% $$$   title = 'DEBUG';
% $$$ end
LIM = graph.PLOT_MAX_NUM_OF_NEURO;
cnum = env.cnum;
if isfield(env,'hwind') && ~isnan(env.hwind)
  hwind = env.hwind;
else
  hwind = 1;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end


if  isfield(env,'hnum') && isnan(env.hnum) && ~iscell(ResFunc)
  hnum = size(ResFunc,3); % realdata
elseif size(ResFunc,3) > 1
  hnum = size(ResFunc,3); % simulation, estimated (3D matrix loaded from matfile
elseif iscell(ResFunc)
  if exist('bases','var')
    hnum =  bases.ihbasprs.numFrame;
  end
elseif ~isnan(env.hnum)
  hnum = env.hnum; % simulation, true value
end
