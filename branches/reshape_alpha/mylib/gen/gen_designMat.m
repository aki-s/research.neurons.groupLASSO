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

%global status;


prs.gen_designMat = 2; % prs: parameters
if strcmp('debug','debug')
  histSize = size(bases.ih,1); % default histSize.
end

%%% ==< check size>==
if (status.READ_FIRING ~= 1)
  if (Drow > env.genLoop)
    warning('DEBUG:fatal','4th arg ''Drow'' must be smaller than env.genLoop')
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
    error('choose appropriate number of basis.'); %++debug:important
    %%+improve: auto select appropriate number of  basis used.
  elseif ( ( env.genLoop  / prs.gen_designMat ) < (  Drow )) ...
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
showProg=floor(env.cnum/reportEvery);
if showProg == 0
  showProg = 1;
end

tic
count = 0;

C = env.cnum; % # of cells
K = bases.ihbasprs.nbase; % # of bases per a cell
N = histSize; % length of each single basis
use = Drow - N;
if 1 == 1
D = zeros( use, C*K ); % design matrix
else

end
T = size( I, 1 ); % length of the time-sequence
%%idx = (T-Drow+1):T; % time index to be estimated
idx = (T+1 -use):T; % time index to be estimated
%%y = I( idx, : );
Dcell = cell(1,K);
if strcmp(bases.type,'glm')
  fprintf(1,'%s : %% ',bases.type);
  parforFlag = status.parfor_;
  parfor c = 1:C %++bug:test
    if parforFlag ~= 1
      if ~mod(c,showProg) %% show progress.
        fprintf(1,'%3.0f ',(count/C)*100)
        %count = count +1;
        tmp = count +1;
        count = tmp;
      end
    else

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
        tmp1D( t,k ) = dot( bases.ihbasis( 1:N, k ), ...
                          I( idx(t)-(1:N), c ) );
      end
    end
    Dcell{c} = tmp1D;
  end
  for c = 1:C
    D(:, (c-1)*K + (1:K) ) = Dcell{c};
  end
elseif strcmp(bases.type,'bar')
  fprintf(1,'%s : %% ',bases.type);
  for c = 1:C
    if ~mod(c,showProg) %% show progress.
      fprintf(1,'%d ',count*10)
      count = count +1;
    end
    for k = 1:K
      D( :, (c-1)*K + k ) = I( idx -k, c );
    end
  end
  D = double(D);
end
%fprintf(1,': elapsed %7.2f\n',toc);
fprintf(1,': elapsed %7.2f',toc);
%%% ==</calc matrix D >==
