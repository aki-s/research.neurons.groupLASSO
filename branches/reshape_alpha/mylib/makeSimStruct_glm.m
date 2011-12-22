%function S = makeSimStruct_glm(dt)
function S = makeSimStruct_glm(Sin,dt)
%
ihbasprs = Sin.ihbasprs;

%global rootdir_
%run( [rootdir_ '/conf/conf_makeSimStruct_glm.m']); % load parameters.

if isfield(Sin,'ihbasprs') && strcmp(ihbasprs.basisType,'bar')
  nlinF = NaN;
  ih = NaN;
  ihbasprs.hpeaks = NaN;
  ihbasprs.b = NaN;
  ihbas = NaN;
  ihbasis = ones(ihbasprs.nbase,1);
  ihbasis.nbase = 100;
  ihbasprsOld = ihbasprs;
else
  % -- Nonlinearity -------
  nlinF = @exp;
  % Other natural choice:  nlinF = @(x)log(1+exp(x));

if strcmp('old','old_')
  [ihbas,ihbasis,ihbasprs] = make_basis(ihbasprs,0.2);
ihbasprsOld = ihbasprs;
else
  ihbasprsOld = ihbasprs
  [ihbas,ihbasis,ihbasprs] = make_basis1(ihbasprs,dt,0.01);
ihbasprs
end
  %% append basis for absolute refractory period.
  if (ihbasprs.absref < dt) 
    ihbasprs.nbase = ihbasprs.nbase-1;
  end 
  ih = ihbasis*ones(size(ihbasis,2), 1);
end

% Place parameters in structure
S = struct(...
    'nlfun', nlinF, ...  % nonlinearity of x-axis
    'ih', ih, ...
    'dt', dt, ...
    'ihbasprs', ihbasprs, ... % params for ih basis
    'ihbasprsOld', ihbasprsOld, ... % params for ih basis
    'ihbas', ihbas, ... % orthogonalized ihbasis
    'ihbasis', ihbasis); ... % basis
