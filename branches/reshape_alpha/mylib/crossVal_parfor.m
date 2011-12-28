function [cv,cost,EbasisWeight,Ebias] = crossVal_parfor(env,graph,status_cvDiv,DAL,bases,varargin)

%% k: upper 'k' results file from 'infile' is used to do crossValidation.
%% k-hold crossValidation.
%%
%% Tlen: Total frame length used for crossValidation.
%% 
%% vargin)
%% vargin{1} infile: text file containing filename lists, or directory name
%% under which all data is to be examined.
%% vargin{2}: index, designate number of frames used to estimate
%% vargin{3}: number of frames used to estimate
status = status_cvDiv;
k = status_cvDiv.crossVal;
parfor_flag = status.parfor_;

tmpEnv = env;
argNum = 5;
histSize = bases.ihbasprs.numFrame;

if (nargin >= argNum+1 )
  if ismatrix(varargin{1})
    %% varargin{1} is 'I'. 
    I = varargin{1};
  elseif ischar(varargin{1}) %++bug:notyet
    %% read a fire or directory, then use the contents of it for
    %% cross validation.
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
  len = env.genLoop; % env.genLoop == size(I,1)
else % artificially generated firing is not reliable at small frame index.
  %% env.genLoop == size(I,1) + 'init_condition_of_I'
  prm = 0.666;%++bug: user wouldn't know why 'len < env.genLoop' is.
  len = floor(env.genLoop * prm);
  %% len ~ env.genLoop - 4000 ?
  %%++bug: may cause 'len > DAL.Drow'.
end

if( nargin >= (argNum + 2) ) %++needless?
  useFrameIdx = varargin{2};
else
  useFrameIdx = 1; % noncommittal
end

if( nargin > (argNum + 3) ) %++needless?
  Tlen = varargin{3};
  if Tlen > len
    error(['number of frame demanded for cross validation is too ' ...
           'large. Tlen > len'])
  end
end

%% ==< crossVal check >==
  tmp = len;
  while mod(tmp,k)
    tmp = tmp -1;
  end
  Tlen = tmp;
  if ( len ~= Tlen )
    fprintf(1,'To make equally dividable, not all firng was used.\n');
    fprintf(1,'(use %10d out of %10d) <- Original%10d\n',DAL.Drow,Tlen,env.genLoop); 
  end
%% ==</crossVal check >==
%% set valid I
I = I((end+1-Tlen):end,:);

Width = Tlen/k;
%% taints tmpEnv.genLoop. crossValidation specific problem.
tmpEnv.genLoop = Tlen - Width;
regFacLen = length(DAL.regFac);
if isfield(env,'inFiringUSE')
  cnum = size(I,2);
  tmpEnv.cnum = cnum;
else
  cnum = env.cnum;
end
EbasisWeight = cell(1,k);
Ebias  = cell(1,k);
Estatus = cell(1,k);
%{
[useFrameLen dum1] = size(env.useFrame);
cost = zeros(useFrameLen,regFacLen);
%}
cost = zeros(1,regFacLen);
status_tmp = cell(1,k);
err = zeros(regFacLen,cnum,k);
if (tmpEnv.genLoop < DAL.Drow)
  warning('DEBUG:NOTICE',...
          'env.useFrame=%s is too large for crossValidation, skipping...',DAL.Drow)
  cv = nan(regFacLen,cnum);
  cost = nan(1,regFacLen);
else
  parfor i1 = 1:k % crossValidation ( %++parallel)
    %%for i1 = 1:k % crossValidation ( %++parallel)
    fprintf(1,'crossValidation index:%2d',i1);
    omit = zeros(1,Tlen);
    omit( (1 + (i1-1)*Width ) : (i1*Width) ) = ( (1 + (i1-1)*Width ) : (i1*Width) ) ;
    USE = (1:Tlen);
    USE = USE - omit;
    USE = USE(USE >0);
    Icut = I(USE,:);
    [EbasisWeight{i1},Ebias{i1},Estatus{i1},dum1,status_tmp{i1}] =...
        estimateWeightKernel(tmpEnv,graph,status,bases,Icut,DAL,useFrameIdx);
    cost = cost + status_tmp{i1}.time.regFac(useFrameIdx,:);
    [Ealpha Ograph] = reconstruct_Ealpha(tmpEnv,graph,DAL,bases,EbasisWeight{i1});
    %    histSize = bases.ihbasprs.numFrame;
    %% warning: not exact response function is write out.
    if strcmp('incomplete_RF','incomplete_RF') % RF: response function
      saveResponseFunc(env,Ograph,status,bases,...
                       EbasisWeight{i1},Ealpha,Ebias{i1},DAL,...
                       regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2'),...
                       'CV',i1);% for later use 
    end
    [Ealpha_] = EalphaCell2Mat(tmpEnv,Ealpha,regFacLen);
    for i2 = 1:regFacLen
      loglambda = cell(tmpEnv.genLoop-histSize,1);
      %%++parallel strongly recommended. Especially if 'k' is small
      %% leave 'for-i3' out as 'parfor-i3' may be good.
      for i3 = (1+histSize): ( tmpEnv.genLoop)
        nIs = Icut(i3 - (1:histSize), 1:cnum);
        %        loglambda(i3,1:cnum) = Ebias(i2,1:cnum) + sum( Ealpha_(:,1:cnum,i2) .*repmat(reshape(nIs,[],1), [1 cnum]) ,1);
        loglambda{i3}(1:cnum) = Ebias{i1}(i2,1:cnum) + sum( Ealpha_(:,1:cnum,i2) .*repmat(reshape(nIs,[],1), [1 cnum]) ,1);
      end
      loglambda = cell2mat(loglambda);
      if parfor_flag == 1
        err(i2,:,i1) = err(i2,:,i1) + calcLogLikelihood(loglambda,Icut((histSize+1:end),:));
      end
    end
    %% save(EbasisWeight,Ebias,status,loglambda) 
  end
  %%cv = sum(err,3)/k;
  cv = sum(err,3)/k/env.useFrame(useFrameIdx);
  %%  ---> cnum
  %%  | cv
  %% \/
  %% regFac
  cost = cost/k;
end
