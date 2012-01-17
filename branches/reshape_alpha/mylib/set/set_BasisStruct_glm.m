function S = set_BasisStruct_glm(Sin,dt)
%% arg1) Sin.ihbasprs have configured parameters.
%% arg2) time[sec] per frame?
%% e.g.
%% if dt==0.2 ,then 118 == length(bases)

ihbasprs = Sin.ihbasprs;

if isfield(Sin,'ihbasprs') && strcmp(ihbasprs.basisType,'bar')
  nlinF = NaN;
  ih = NaN;
  ihbasprs.hpeaks = NaN;
  ihbasprs.b = NaN;
  ihbas = NaN;
  ihbasis = ones(ihbasprs.nbase,1);
  ihbasis.nbase = 100;
  ihbasprsOrg = ihbasprs;
else
  % -- Nonlinearity -------
  nlinF = @exp;
  % Other natural choice:  nlinF = @(x)log(1+exp(x));

if strcmp('old','old_')
  ihbasprsOrg = ihbasprs;
  [ihbas,ihbasis,ihbasprs] = make_basis(ihbasprs,0.2);
elseif strcmp('variable_nbase','variable_nbase')
  ihbasprsOrg = ihbasprs;
  [ihbas,ihbasis,ihbasprs] = make_basis1(ihbasprs,dt,0.065);
elseif strcmp('static_nbase','static_nbase')%++bug:critical
  ihbasprsOrg = ihbasprs;
  [ihbas,ihbasis,ihbasprs] = make_basis2(ihbasprs,dt,0.01);
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
    'ihbasprsOrg', ihbasprsOrg, ... % params for ih basis
    'ihbas', ihbas, ... % orthogonalized ihbasis
    'ihbasis', ihbasis); ... % basis
