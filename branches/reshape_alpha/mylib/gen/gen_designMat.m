function [D] = gen_designMat(env,bases,I,Drow,varargin)
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

global status;


prs.gen_designMat = 2; % prs: parameters
if strcmp('debug','debug')
  histSize = size(bases.ih,1); % default histSize.
end

%%% ==< check size>==
if isempty(varargin)
  if ~( Drow < env.genLoop)
    warning('DEBUG:fatal','4th arg ''Drow'' must be smaller than env.genLoop')
  end

  %% histSize: presume this number of frames is valid history length.
  if ( env.genLoop < ( histSize + Drow ))
    warning('DEBUG:fatal','The number of history windows is too large.');
    if status.DEBUG.level > 0
      fprintf(1,...
              [ ...
                  '%s: %d ',...
                  '%s',...
                  '%s: %d ',...
                  '%s',...
                  '%s: %d ',...
                  '%s',...
                  '\n'], ...
              '( env.genLoop', env.genLoop,...
              '< (',...
              'histSize', histSize,...
              '+',...
              'Drow',Drow,...
              '))'...
              );
    end
    %  error('choose appropriate number of basis.'); %++debug:important
    %%+improve: auto select appropriate number of  basis used.
  elseif ( ( env.genLoop  / prs.gen_designMat ) < ( histSize + Drow )) ...
    % ++debug.1
    %{
    disp(['Number of basis used to estimate, and number of frames ' ...
          'applied to penalty function may be relatively too large for ' ...
          'generated frames.'])
    %}
    warning('WarnTests:convertTest', 'Number of basis used to estimate, and number of frames applied to penalty function\n\t may be relatively too large for generated frames.');
    if status.DEBUG.level > 0
      fprintf(1,...
              [ ...
                  '%s: %d ',...
                  '%s',...
                  '%s: %d ',...
                  '%s',...
                  '%s: %d ',...
                  '%s',...
                  '\n'],...
              '( env.genLoop/ div', env.genLoop/prs.gen_designMat,...
              '< (',...
              'histSize', histSize,...
              '+',...
              'Drow',Drow,...
              '))'...
              );
    end
    %% ++improve: automated preparation for number of basis.
    %  histSize = ;
  end
end
%%% ==</check size>==

%%% ==< calc matrix D >==
reportEvery = 10;
tmp0.showProg=floor(env.cnum/reportEvery);
if tmp0.showProg == 0
  tmp0.showProg = 1;
end

tic
tmp0.count = 0;

C = env.cnum; % # of cells
K = bases.ihbasprs.nbase; % # of bases per a cell
N = histSize; % length of each single basis
D = zeros( Drow, C*K ); % design matrix
T = size( I, 1 ); % length of the time-sequence
idx = (T-Drow+1):T; % time index to be estimated
y = I( idx, : );

if strcmp(bases.type,'glm')
  fprintf(1,'%s : %% ',bases.type);
  for c = 1:C
    if ~mod(c,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    for k = 1:K
      tmp1D = zeros( Drow, 1 );
      for t = 1:Drow
        tmp1D( t ) = dot( bases.ihbasis( 1:N, k ), ...
                          I( idx(t)-(1:N), c ) );
      end
      D( :, (c-1)*K + k ) = tmp1D;
    end
  end
elseif strcmp(bases.type,'bar')
  fprintf(1,'%s : %% ',bases.type);
  for c = 1:C
    if ~mod(c,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    for k = 1:K
      D( :, (c-1)*K + k ) = I( idx -k, c );
    end
  end
  D = double(D);
end
fprintf(1,': past time %d\n',toc);
%%% ==</calc matrix D >==
