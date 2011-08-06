function [D penalty] = gen_designMat(env,bases,I,Drow);
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
%% penalty: penalty for discriminant function. returned as matrix.
%%
%% USAGE)
%[D penalty] = gen_designMat(env,bases,I,Drow);
%%

global status;
%%< conf

DEBUG = 0;
DEBUG = 2; % ooD
%%DEBUG = 3;

prs.gen_designMat = 2; % prs: parameters
%%> conf
%%< check size
if ~( Drow < env.genLoop)
  warning('4th arg ''Drow'' must be smaller than env.genLoop')
end

%% histSize: presume this number of frames is valid history length.
if strcmp('debug','debug')
  histSize = size(bases.ih,1); % default histSize.
end
if ( env.genLoop < ( histSize + Drow ))
  warning('The number of history windows is too large.');
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reportEvery = 10;
tmp0.showProg=floor(env.cnum/reportEvery);
if tmp0.showProg == 0
  tmp0.showProg = 1;
end

tic;
C = env.cnum;
B = bases.ihbasprs.nbase;


str=sprintf('D3');
if DEBUG == 1 && strcmp('D3',str)
  tmp0.count = 0;
  fprintf(1,'%10s:\tprogress(%%): ',str);
  D3 = zeros(Drow,C*B);
  penalty = 2*I((end - Drow +1):end,:) -1;

  flipI = flipud(I);

  % ++parallelization
  for i1cellIndex = 1: C % i1cellIndex: for cell index.
    if ~mod(i1cellIndex,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end

    %% Time axis is in descending order.
    tmp1D = zeros(Drow,B); % reset at new bottom right part in matrix D3.
    for i2basisIndex = 1:B % i2basisIndex: for bases.ihbasis( ,i2basisIndex).
      for i3stpt = 1:Drow % i3stpt: ascending time. stand point.
        %% demension reduction with basis function 'bases.ihbasis'.
        tmp1D(1 + Drow - i3stpt,i2basisIndex) = dot( bases.ihbasis(1:histSize, i2basisIndex),...
                                                     flipI(i3stpt-1 +(1:histSize), i1cellIndex) ) ; 
      end %++debug.1
    end
    D3(:,(i1cellIndex-1)*B + (1:B) ) = (tmp1D);
  end
  fprintf(1,': past time %d\n',toc);
end

str=sprintf('D2');
if DEBUG == 1 && strcmp('D2',str)
  tmp0.count = 0;
  fprintf(1,'%10s:\tprogress(%%): ',str);
  D2 = zeros(Drow,C*B);
  penalty = 2*I((end - Drow +1):end,:) -1;

  % ++parallelization
  for i1cellIndex = 1: C % i1cellIndex: for cell index.
    if ~mod(i1cellIndex,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end

    %% Time axis is in descending order.
    tmp1D = zeros(Drow,B); % reset at new bottom right part in matrix D2.
    for i2basisIndex = 1:B % i2basisIndex: for bases.ihbasis( ,i2basisIndex).
      for i3stpt = 0:Drow-1 % i3stpt: ascending time. stand point.
        %% demension reduction with basis function 'bases.ihbasis'.
        tmp1D(Drow -i3stpt,i2basisIndex) = dot( bases.ihbasis(1:histSize,i2basisIndex), I(end +1 -(1:histSize) -i3stpt, i1cellIndex) ) ; 
      end %++debug.1
    end
    D2(:,(i1cellIndex-1)*B + (1:B) ) = tmp1D ;
  end
  fprintf(1,': past time %d\n',toc);
end

str=sprintf('D_');
if DEBUG == 1 && strcmp('D',str)
  tmp0.count = 0;
  fprintf(1,'%10s:\tprogress(%%): ',str);
  D = zeros(Drow,env.cnum*bases.ihbasprs.nbase); 
  penalty = 2*I(end - Drow +1: end,:) -1;

  % ++parallelization
  for i1cellIndex = 1: env.cnum % i1cellIndex: for cell index.
    if ~mod(i1cellIndex,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end

    %% Time axis is in descending order.
    for i2basisIndex = 1:bases.ihbasprs.nbase % i2basisIndex: for bases.ihbasis( ,i2basisIndex).
      tmp1D = zeros(Drow,1); % reset at new bottom right part in matrix D.
      for i3 = 0:Drow-1 % i3: ascending time point.
        %% demension reduction with basis function 'bases.ihbasis'.
        tmp1D(Drow -i3) = dot( bases.ihbasis(1:histSize,i2basisIndex), I(end +1 -(1:histSize) -i3, i1cellIndex) ) ; 
      end %++debug.1
      D(:,(i1cellIndex-1)*bases.ihbasprs.nbase +i2basisIndex ) = tmp1D ;
    end
  end
  fprintf(1,': past time %d\n',toc);
end

str = sprintf('oba');
if DEBUG == 2 && strcmp('oba',str)
  tmp0.count = 0;
  fprintf(1,'%10s:\tprogress(%%): ',str);
  tic
  tmp0.count = 0;

  ooC = env.cnum; % # of cells
  ooK = bases.ihbasprs.nbase; % # of bases per a cell
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
        tmp1D( t ) = dot( bases.ihbasis( 1:ooN, k ), ...
                          I( ooidx(t)-(1:ooN), c ) );
      end
      ooD( :, (c-1)*ooK + k ) = tmp1D;
    end
  end
  fprintf(1,': past time %d\n',toc);
end

str = sprintf('oba1');
if DEBUG == 1 && strcmp('oba1',str)
  tmp0.count = 0;
  fprintf(1,'%10s:\tprogress(%%): ',str);
  tic
  tmp0.count = 0;

  o1C = env.cnum; % # of cells
  o1K = bases.ihbasprs.nbase; % # of bases per a cell
  o1N = histSize; % length of each single basis
  o1D = zeros( Drow, o1C*o1K ); % design matrix
  o1T = size( I, 1 ); % length of the time-sequence
  o1idx = (o1T-Drow+1):o1T; % time index to be estimated
  o1y = I( o1idx, : );
  penalty = 2*o1y-1;
  for c = 1:o1C
    if ~mod(c,tmp0.showProg) %% show progress.
      fprintf(1,'%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    tmp1D = zeros( Drow, o1K );
    for k = 1:o1K
      for t = 1:Drow
        tmp1D( t, k ) = dot( bases.ihbasis( 1:o1N, k ), ...
                             I( o1idx(t)+1 -(1:o1N), c ) );
        %                          I( o1idx(t)-(1:o1N), c ) );
      end
    end
    o1D( :, (c-1)*o1K +(1:o1K) ) = tmp1D;
  end
  fprintf(1,': past time %d\n',toc);
end


if DEBUG == 1
  switch 0 
    case 1
      fprintf(1,'\n gen_designMat:: diff D:  %f\n',...
              sum( (D(:) - D2(:) ).^2 ) );
    case 2
      fprintf(1,'\n gen_designMat:: diff D:  %f\n',...
              sum(sum( (D2 - D3),1 ),2) );
    case 3
      fprintf(1,'\n gen_designMat:: diff D:  %f\n',...
              sum( (ooD(:) - D(:) ).^2 ) );
    case 4
      fprintf(1,'\n gen_designMat:: diff D:  %f\n',...
              sum( (ooD(:) - D2(:) ).^2 ) );
    case 5
      fprintf(1,'\n gen_designMat:: diff D:  %f\n',...
              sum(sum( (ooD - D3),1 ),2) );
    otherwise
      compD(ooD,D3);
      compD(ooD,D2);
      compD(ooD,o1D);
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RETURN %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch 1
  case 1
    D = ooD;
  case 2
    D = D2;
end





function compD(D1,D2);
fprintf(1,'\n gen_designMat:: diff %s %s:  %f\n',...
        D1, D2, sum(sum( (D1(:) - D2(:)),1 ),2) );
