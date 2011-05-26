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
%%
%% USAGE)
%[D penalty] = gen_designMat(env,ggsim,I,Drow);
%%

%%< check size
if ~( Drow < env.genLoop)
  warning('4th arg ''Drow'' must be smaller than env.genLoop')
end

%histSize=env.cnum*env.hwind;
histSize = size(ggsim.ih,1);
D = []; 
penalty = [];
for i1cellIndex = 1: env.cnum % i1cellIndex: for cell index.
  %% Time axis is in descending order.
  tmp1penalty = 2*I( end-Drow + (1:Drow) ,i1cellIndex) - 1;
  penalty = [ penalty , tmp1penalty];
  for i2baseIndex = 1:ggsim.ihbasprs.nbase % i2baseIndex: for ggsim.baisis( ,i2baseIndex).
    tmp1D = []; % reset at new bottom right part in matrix D.
% $$$     for i3 = env.genLoop +1  - (1:Drow) % i3: for upstream time.
     for i3 = 0:Drow-1 % i3: for upstream time.
      %% demension reduction with basis function 'ggsim.ihbasis'.
% $$$       tmp1D = [ dot( ggsim.ihbasis(1:histSize,i2baseIndex), I(end +1 -(1:histSize) -i3,i1cellIndex) ) ; tmp1D ];
       tmp1D = [ dot( ggsim.ihbasis(1:histSize,i2baseIndex), I(end +1 -(1:histSize) -i3, i1cellIndex) ) ; tmp1D ];
    end
    D = [ D, tmp1D ];
  end
end
