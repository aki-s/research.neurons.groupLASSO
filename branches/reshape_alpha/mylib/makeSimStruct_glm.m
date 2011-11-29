function S = makeSimStruct_glm(dt)
%

global rootdir_
run( [rootdir_ '/conf/conf_makeSimStruct_glm.m']); % load parameters.

if strcmp(basisType,'bar')
  nlinF = NaN;
  ih = NaN;
  ihbasprs.hpeaks = NaN;
  ihbasprs.b = NaN;
  ihbas = NaN;
  %  ihbasis = ones(1,iht);
  ihbasis = ones(1,50);
else
  % -- Nonlinearity -------
  nlinF = @exp;
  % Other natural choice:  nlinF = @(x)log(1+exp(x));

  [iht,ihbas,ihbasis] = make_basis(ihbasprs,dt);

  %% append basis for absolute refractory period.
  if (ihbasprs.absref < dt) 
    ihbasprs.nbase = ihbasprs.nbase-1;
  end 
  ih = ihbasis*[repmat(1,[ihbasprs.nbase 1])];
  ihbasprs.NumFrame = length(iht);
end

% Place parameters in structure
S = struct(...
    'type', basisType, ...
    'nlfun', nlinF, ...  % nonlinearity of x-axis
    'iht', iht, ...      % time indices
    'ih', ih, ...
    'dt', dt, ...
    'ihbasprs', ihbasprs, ... % params for ih basis
    'ihbas', ihbas, ... % orthogonalized ihbasis
    'ihbasis', ihbasis); ... % basis
