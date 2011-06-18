function [D penalty] = gen_designMat(env,ggsim,I,Drow);
%% 
%% Reduce dimension to be estimated 
%% from raw large dimension (number of frames which are coverd with
%% ggsim.ihbasis )to
%% ggsim.ihbasprs.nbase new smaller dimension.
%%
%% INPUT)
%% env  :
%% ggsim: basis function
%% I    : [time,cell] matrix. Firing history flag. 
%% Drow : number of flames to be to be used for penalty.
%%
%% OUTPUT)
%% D	: matrix having info about argument of discriminant function.
%% penalty: penalty for discriminant function. returned as matrix.
%%
%% USAGE)
%[D penalty] = gen_designMat(env,ggsim,I,Drow);
%%

%%< conf
pars.gen_designMat = 2;
%%> conf
%%< check size
if ~( Drow < env.genLoop)
  warning('4th arg ''Drow'' must be smaller than env.genLoop')
  %error();
end

%% histSize: presume this number of frames is valid history length.
histSize = size(ggsim.ih,1); % default histSize.
if ( env.genLoop < ( histSize + Drow ))
  warning('The number of history windows is too large.');
  error('choose appropriate number of basis.');
elseif ( ( env.genLoop  / pars.gen_designMat ) < ( histSize + Drow )) ...
  % ++debug.1
  %{
  disp(['Number of basis used to estimate, and number of frames ' ...
        'applied to penalty function may be relatively too large for ' ...
        'generated frames.'])
  %}
warning('Number of basis used to estimate, and number of frames applied to penalty function\n may be relatively too large for generated frames.');
  %% ++improve: automated preparation for number of basis.
  %  histSize = ;
end
D = []; 
%penalty = [];
penalty = 2*I(end - Drow +1: end,:) -1;
% ++parallelization
for i1cellIndex = 1: env.cnum % i1cellIndex: for cell index.
  %% Time axis is in descending order.
% $$$   tmp1penalty = 2*I( end-Drow + (1:Drow) ,i1cellIndex) - 1;
% $$$   penalty = [ penalty , tmp1penalty];
  for i2basisIndex = 1:ggsim.ihbasprs.nbase % i2basisIndex: for ggsim.ihbasis( ,i2basisIndex).
    tmp1D = []; % reset at new bottom right part in matrix D.
% $$$     for i3 = env.genLoop +1  - (1:Drow) % i3: for upstream time.
     for i3 = 0:Drow-1 % i3: ascending time point.
      %% demension reduction with basis function 'ggsim.ihbasis'.
% $$$       tmp1D = [ dot( ggsim.ihbasis(1:histSize,i2basisIndex), I(end +1 -(1:histSize) -i3,i1cellIndex) ) ; tmp1D ];
      tmp1D = [ dot( ggsim.ihbasis(1:histSize,i2basisIndex), I(end +1 -(1:histSize) -i3, i1cellIndex) ) ; tmp1D ];
    end %++debug.1
    D = [ D, tmp1D ];
  end
end
