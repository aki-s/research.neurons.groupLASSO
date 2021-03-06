function [D] = gen_designMat(env,status,bases,I,Drow,varargin)
%% 
%% Reduce dimension to be estimated 
%% from raw large dimension (number of frames which are coverd with
%% bases.ihbasis )to
%% bases.ihbasprs.nbase new smaller dimension.
%%
%% INPUT)
%% env  :
%% bases: basis function
%% I    : [time,cell] matrix. Firing history flag. 
%% Drow : number of flames to be to be used for penalty.
%%
%% OUTPUT)
%% D	: matrix having info about argument of discriminant function.
%%	: D(i,(#neuron -1)*B + j), j=1:B
%% 	: Suppose each variable is set as following.
%% 	: B:= bases.ihbasprs.nbase (Number of basis)
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
%% penalty: penalty for discriminant function.
%%
%% USAGE)
%[D ] = gen_designMat(env,bases,I,Drow);
%%

histSize = bases.ihbasprs.numFrame; % default histSize.

%%% ==< check size>==
if (status.READ_FIRING ~= 1)
  run gen_designMat_chooseReliableFire
end
%%% ==</check size>==

%%% ==< calc matrix D >==

tic
count = 0;
if isfield(env,'inFiringUSE')
  C = size(I,2);
else
  C = env.cnum; % # of cells
end
K = bases.ihbasprs.nbase; % # of bases per a cell
N = histSize; % length of each single basis
use = Drow - N;
D = zeros( use, C*K ); % design matrix
T = size( I, 1 ); % length of the time-sequence
%%idx = (T-Drow+1):T; % time index to be estimated
idx = (T+1 -use):T; % time index to be estimated
%%y = I( idx, : );
Dcell = cell(1,K);
reportEvery = floor(C/10);
if reportEvery == 0
  reportEvery = 1;
end
parforFlag = status.parfor_;
if strcmp(bases.ihbasprs.basisType,'glm')
  fprintf(1,'%s : %% ',bases.ihbasprs.basisType);
  parfor c = 1:C %++bug:test
  %for c = 1:C %++bug:test
    if parforFlag ~= 1
      if ~mod(c,reportEvery) %% show progress.
                             %{
        count = count +1;
        fprintf(1,'%3.0f ',(count/C)*100)
        %}
        fprintf(1,'.');
      end
    else
      %% run parfor
      %        fprintf(1,'.');
    end
    %{
    for k = 1:K
      tmp1D = zeros( use, 1 );
      for t = 1:use
        tmp1D( t ) = dot( bases.ihbasis( 1:N, k ), ...
                          I( idx(t)-(1:N), c ) );
      end
      D( :, (c-1)*K + k ) = tmp1D;
      %      D( :, (c-1)*K + k ) = D( :, (c-1)*K + k )  + tmp1D;
    end
    %}
    tmp1D = zeros( use, K );
    for k = 1:K
      for t = 1:use
        %{
        %% ++debug
        if (t ==1) || (t==use)
          fprintf(1,'%3d:%3d:%6d\n',c,k,t);
        end
        %}
        tmp1D( t,k ) = dot( bases.ihbasis( 1:N, k ), ...
                            I( idx(t)-(1:N), c ) );
      end
    end
    Dcell{c} = tmp1D;
  end
  for c = 1:C
    D(:, (c-1)*K + (1:K) ) = Dcell{c};
  end
elseif strcmp(bases.ihbasprs.basisType,'bar')
  fprintf(1,'%s : %% ',bases.ihbasprs.basisType);
  for c = 1:C
    if ~mod(c,reportEvery) %% show progress.
  %%      fprintf(1,'%d ',count*10)
      count = count +1;
    end
    for k = 1:K
      D( :, (c-1)*K + k ) = I( idx -k, c );
    end
  end
  D = double(D);
end
fprintf(1,': elapsed %7.2f\n',toc);
%%% ==</calc matrix D >==
