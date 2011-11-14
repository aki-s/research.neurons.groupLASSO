function [cv,cost,EbasisWeight,Ebias] = crossVal(env,graph,status_cvDiv,DAL,bases,varargin)
%function [cv,status] = crossVal(env,graph,status_cvDiv,DAL,bases,varargin)

%% k: upper 'k' results file from 'infile' is used to do crossValidation.
%% k-hold crossValidation.
%%
%% Tlen: Total frame length used for crossValidation.
%% 
%% vargin)
%% vargin{1} infile: text file containing filename lists, or directory name
%% under which all data is to be examined.
%% 

status = status_cvDiv;
k = status_cvDiv.crossVal;
%parfor_flag = status.parfor_;

tmpEnv = env;
baseN = 5;
if (nargin >= baseN+1 )
  if ismatrix(varargin{1})
    %% varargin{1} is 'I'. 
    I = varargin{1};
  elseif ischar(varargin{1})
    infile = varargin{1};

    %inRoot_ = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir'
    %infile ='/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/Real_data/crossVal_dataLists.txt'

    infile_root = '';
    if isdir(infile)
      %% load firng data from all  m-files under directory 'infile'.
      infile_ = textscan(ls(infile),'%s','delimiter','\t\n ');
      infile_ = infile_{:};
    else
      count = 1;
      fid = fopen(infile);
      tline = fgets(fid);
      infile_ = cell(k,1);
      while ( ischar(tline) && (count <= k) )
        infile_{count} = tline;
        tline = fgets(fid);
        count = count +1;
      end
      fclose(fid);
      if isdir(infile_{1})
        %    infile_root = regexprep(infile_{1},'(.*/)(.*$)','$1');
      else
        %% abolute path isn't used.
        %% suppoese all file is under the same directory 'infile_root'.
        infile_root = regexprep(infile,'(.*/)(.*$)','$1');
      end
    end

    %% crossValidation
    init_crossVal(infile_root,infile_);
    %{
    I = [];
    for i1 = 1:num(regFac)
      I = [I;readI()];
    end
    tmpEnv.useFrame = 10000;
    %}
    DAL.regFac =  [10 3 1]; %++bug?
    bases = makeSimStruct_glm(0.2); % Create GLM structure with default params
  end
end

if ( status.READ_FIRING == 1 )
  len = env.genLoop;
else % artificially generated firing is not reliable at small frame index.
  prm = 0.666;
  len = floor(env.genLoop * prm);
end

if( nargin >= (baseN + 2) ) %++needless?
  tmp = len;
  while mod(tmp,k)
    tmp = tmp -1;
  end
  Tlen = tmp;
  if ( len ~= Tlen )
    fprintf(1,'To make equally dividable, not all firng was used.\n');
    fprintf(1,'(use %10d out of %10d) <- %10d\n',DAL.Drow,Tlen,env.genLoop); 
  end
  useFrameIdx = varargin{2};
else
  useFrameIdx = 1; % noncommittal
end

if( nargin > (baseN + 2) ) %++needless?
  Tlen = varargin{3};
  if Tlen > len
    error('Tlen > len')
  end
end

Width = Tlen/k;
tmpEnv.genLoop = env.genLoop - Width;
regFacLen = length(DAL.regFac);
cnum = env.cnum;
loglambda = zeros(tmpEnv.genLoop,cnum);
%  err = zeros(k,regFacLen);
err = zeros(regFacLen,cnum,k);
if (tmpEnv.genLoop < DAL.Drow)
  warning('DEBUG:NOTICE',...
          'env.useFrame is too large for crossValidation, skipping...')
else
  for i1 = 1:k % crossValidation ( %++parallel)
    fprintf(1,'crossValidation index:%2d',i1);
    omit = zeros(1,Tlen);
    omit( (1 + (i1-1)*Width ) : (i1*Width) ) = ( (1 + (i1-1)*Width ) : (i1*Width) ) ;
    USE = (1:Tlen);
    USE = USE - omit;
    USE = USE(USE >0);
    [EbasisWeight,Ebias_,Estatus,dum1,status] =...
        estimateWeightKernel(tmpEnv,graph,status,bases,I(USE,:),DAL,regFacIdx);
    %    tic;fprintf(1,'Eapha2Mat:\t');
    Ealpha = reconstruct_Ealpha(tmpEnv,DAL,bases,EbasisWeight);
    histSize = bases.ihbasprs.NumFrame;
    [Ealpha_] = EalphaCell2Mat(tmpEnv,Ealpha,regFacLen);
    %    toc
    %{
    fprintf(1,'Ebias2Mat:\t')
    Ebias_ = Ebias2Mat(tmpEnv,Ebias,regFacLen);
    %}
    for i2 = 1:regFacLen
      tic
      for i3 = 1: tmpEnv.genLoop %++parallel
        nIs = I(i3 + histSize - (1:histSize), 1:cnum);
        loglambda(i3,1:cnum) = Ebias_(i2,1:cnum) + sum( Ealpha_(:,1:cnum,i2) .*repmat(reshape(nIs,[],1), [1 cnum]) ,1);
      end
      toc
        err(i2,:,i1) = err(i2,:,i1) + calcLikelihood(loglambda,I(USE,:));
    end
    %% save(EbasisWeight,Ebias_,status,loglambda) 
  end
end
%  cv = sum(err,1)/k;
cv = sum(err,3)/k;
%%  ---> cnum
%%  | cv
%% \/
%% regFac
