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
%%	: D(i,(#neuron -1)*B + j), j=1:B
%% 	: Suppose each variable is set as following.
%% 	: B:= ggsim.ihbasprs.nbase (Number of basis)
%% 	: env.cnum:=5
%% 	: ^   |-----------------------------|    |  ~ old time
%% 	: |   |  #  |  #  |  #  |  #  |  #  |    |
%% 	: |   |  n  |  n  |  n  |  n  |  n  |    |
%% 	:Drow |  e  |  e  |  e  |  e  |  e  |    |
%% 	: |   |  u  |  u  |  u  |  u  |  u  |    |
%% 	: |   |  r  |  r  |  r  |  r  |  r  |    |
%% 	: |   |  o  |  o  |  o  |  o  |  o  |    |
%% 	: |   |  n  |  n  |  n  |  n  |  n  |    |
%% 	: |   |  1  |  2  |  3  |  4  |  5  |    |
%% 	: |   |     |     |     |     |     |    |
%% 	: |   |     |     |     |     |     |    |--- i
%% 	: |   | 1:B |     |     |     |     |    |
%% 	:\ /  |<-B->|<-B->|<-B->|<-B->|<-B->|   \ / ~ latest time
%% 	:      1|..B  |     |     |     |  
%% 	:       j     j     j     j     j
%% 	:     \_____________  ______________/  [time]
%% 	:		    \/
%% 	:             matrix  D
%% penalty: penalty for discriminant function. returned as matrix.
%%
%% USAGE)
%[D penalty] = gen_designMat(env,ggsim,I,Drow);
%%

%%< conf
prs.gen_designMat = 2; % prs: parameters
%%> conf
%%< check size
if ~( Drow < env.genLoop)
  warning('4th arg ''Drow'' must be smaller than env.genLoop')
end

%% histSize: presume this number of frames is valid history length.
if strcmp('debug','debug')
  histSize = size(ggsim.ih,1); % default histSize.
end
if ( env.genLoop < ( histSize + Drow ))
  warning('The number of history windows is too large.');
  error('choose appropriate number of basis.');
  %%+improve: auto select appropriate number of  basis used.
elseif ( ( env.genLoop  / prs.gen_designMat ) < ( histSize + Drow )) ...
  % ++debug.1
  %{
  disp(['Number of basis used to estimate, and number of frames ' ...
        'applied to penalty function may be relatively too large for ' ...
        'generated frames.'])
  %}
  warning('WarnTests:convertTest', 'Number of basis used to estimate, and number of frames applied to penalty function\n\t may be relatively too large for generated frames.');
  %% ++improve: automated preparation for number of basis.
  %  histSize = ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  tmp0.showProg=floor(env.cnum/10);
  tmp0.count = 0;
  fprintf(1,'\tprogress(%%): ');


if strcmp('me','me_')
  D = zeros(Drow,env.cnum*ggsim.ihbasprs.nbase); 
  penalty = 2*I(end - Drow +1: end,:) -1;

  % ++parallelization
  for i1cellIndex = 1: env.cnum % i1cellIndex: for cell index.
    if ~mod(i1cellIndex,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end

    %% Time axis is in descending order.
    for i2basisIndex = 1:ggsim.ihbasprs.nbase % i2basisIndex: for ggsim.ihbasis( ,i2basisIndex).
      tmp1D = zeros(Drow,1); % reset at new bottom right part in matrix D.
      for i3 = 0:Drow-1 % i3: ascending time point.
        %% demension reduction with basis function 'ggsim.ihbasis'.
        tmp1D(Drow -i3) = dot( ggsim.ihbasis(1:histSize,i2basisIndex), I(end +1 -(1:histSize) -i3, i1cellIndex) ) ; 
      end %++debug.1
      D(:,(i1cellIndex-1)*ggsim.ihbasprs.nbase +i2basisIndex ) = tmp1D ;
    end
  end

else
  C = env.cnum; % # of cells
  K = ggsim.ihbasprs.nbase; % # of bases per a cell
  N = histSize; % length of each single basis
  D = zeros( Drow, C*K ); % design matrix
  T = size( I, 1 ); % length of the time-sequence
  idx = (T-Drow+1):T; % time index to be estimated
  y = I( idx, : );
  penalty = 2*y-1;
  for c = 1:C
    if ~mod(c,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    for k = 1:K
      tmp1D = zeros( Drow, 1 );
      for t = 1:Drow
        tmp1D( t ) = dot( ggsim.ihbasis( 1:N, k ), ...
                          I( idx(t)-(1:N), c ) );
      end
      D( :, (c-1)*K + k ) = tmp1D;
    end
  end
end