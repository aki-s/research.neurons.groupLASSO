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
  %% ++improve: automated preparation for number of basis.
  %  histSize = ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reportEvery = 10;
tmp0.showProg=floor(env.cnum/reportEvery);
if tmp0.showProg == 0
  tmp0.showProg = 1;
end
tmp0.count = 0;

tic;
if strcmp('me','me_')
  fprintf(1,'\tprogress(%%): ');
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
  fprintf(1,': past time %d\n',toc);
end

if strcmp('oba','oba')
  fprintf(1,'\tprogress(%%): ');
  tic
  tmp0.count = 0;

  ooC = env.cnum; % # of cells
  ooK = ggsim.ihbasprs.nbase; % # of bases per a cell
  ooN = histSize; % length of each single basis
  ooD = zeros( Drow, ooC*ooK ); % design matrix
  ooT = size( I, 1 ); % length of the time-sequence
  ooidx = (ooT-Drow+1):ooT; % time index to be estimated
  ooy = I( ooidx, : );
  penalty = 2*ooy-1;
  for c = 1:ooC
    if ~mod(c,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    for k = 1:ooK
      tmp1D = zeros( Drow, 1 );
      for t = 1:Drow
        tmp1D( t ) = dot( ggsim.ihbasis( 1:ooN, k ), ...
                          I( ooidx(t)-(1:ooN), c ) );
      end
      ooD( :, (c-1)*ooK + k ) = tmp1D;
    end
  end
  fprintf(1,': past time %d\n',toc);
end


if strcmp('debug','debug_')
  fprintf(1,'\n gen_designMat:: diff D:  %f\n',sum( (ooD(:) - D(:) ...
                                                    ).^2 ) );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RETURN %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = ooD;

