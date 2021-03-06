function S = makeSimStruct_glm(dt)
%
%  Creates a structure with default parameters for a GLM model
%
%  Input: dt = time binning for sampling post-spike kernel ('ih')
%
%  Struct fields (model params):  
%        'fnlin' - nonlinearity (exponential by default)
%        'ihbas' - basis for alpha
%        'iht' - time lattice for post-spike current
%        'dtsim' - default time bin size for simulation
%        'kbasprs' - basis for stim filter 
%        'ihbasprs' - basis for post-spike current
 
% --- Make basis for post-spike (h) current ------
%run( './conf/conf_makeSimStruct_glm.m'); % load parameters.
global rootdir_
run( [rootdir_ '/conf/conf_makeSimStruct_glm.m']); % load parameters.

% -- Nonlinearity -------
nlinF = @exp;
% Other natural choice:  nlinF = @(x)log(1+exp(x));

[iht,ihbas,ihbasis] = make_basis(ihbasprs,dt);
%% append basis for absolute refractory period.
if(ihbasprs.absref < dt) ihbasprs.nbase = ihbasprs.nbase-1; end 
% $$$ if( isequal(getfield(ihbasprs,'absref'),[]) )
% $$$  ihbasprs.nbase =  ihbasprs.nbase -1;
% $$$ end
ih = ihbasis*[repmat(1,[ihbasprs.nbase 1])];

% Place parameters in structure
S = struct(...
    'type', 'glm', ...
    'nlfun', nlinF, ...  % nonlinearity of x-axis
    'iht', iht, ...      % time indices of aftercurrent
    'ih', ih, ...
    'dt', dt, ...
    'ihbasprs', ihbasprs, ... % params for ih basis
    'ihbas', ihbas, ... % orthogonalized ihbasis
    'ihbasis', ihbasis); ... % basis for current