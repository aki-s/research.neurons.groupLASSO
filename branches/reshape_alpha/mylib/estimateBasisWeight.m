function [EbasisWeight,Ebias,DALstatus,Ostatus] = estimateBasisWeight(env,status,bases,I,DAL,varargin)
%%
%%
%% return)
%% DAL: DAL.Drow, DAL.regFac
%% Ostatus: Ostatus.time.regFac
% [KerWeight,Ebias,DALstatus,DAL] = ...
% estimateBasisWeight(env,status,graph,bases,I,DAL);
DEBUG = 1;
Ostatus = status;
nargin_NUM = 5;

if nargin < nargin_NUM + 1;
  useFrameIdx = 1;
else
  useFrameIdx = varargin{1};
end

cost1 = tic;
cnum = env.cnum;
nbase = bases.ihbasprs.nbase; % nbase: number of bases.
opt = DAL.opt;

if isfield(DAL,'Drow')
  loopFrame = length(DAL.Drow);
  if  loopFrame > 1
    m =  max(DAL.Drow);
  else
    m = DAL.Drow;
  end
  if ( m > env.genLoop-1) && (status.READ_FIRING == 0)
    error('DAL.Drow > env.genLoop' )
  end
elseif strcmp('auto','auto')
  DAL.Drow = floor(env.genLoop/4); % ODAL

elseif strcmp('allI','allI_')  %++conf
  %%% use all available firing history.
  %% Drow: length of total frames used at loss function.
  %  DAL.Drow = env.genLoop - size(bases.iht,1) -1; 
  DAL.Drow = env.genLoop - bases.ihbasprs.numFrame -1; 
end

%% ==< init variables >==
method = DAL.method;

%% ==</init variables >==

if 1 == 1
  %% dimension reduction to be estimated.
  fprintf('\tGenerating Matrix for DAL\n');
  if ( DAL.Drow > bases.ihbasprs.numFrame )
    [D] = gen_designMat(env,status,bases,I,DAL.Drow);
  else
    error('must be (DAL.Drow > bases.ihbasprs.numFrame)')
  end
  %%+improve:write out for later use and speedup.
  if strcmp(method,'prgl')
        pI= I( (end - DAL.Drow+ bases.ihbasprs.numFrame +1): end,:);%maybe_O.K.
    %    pI = I( (end+1-size(D,1)):end, :); 
  elseif strcmp(method,'lrgl')
    pI =  2 * I( (end - DAL.Drow+ length(bases.iht) +1): end,:) - 1;
  end
  %% must be length(D,1) == length(pI,1) 
end
if strcmp('debug','debug_')
  fprintf(1,'Drow:%d, I:',DAL.Drow);
  fprintf(1,' %d',sum(  I((end+1-DAL.Drow):end,:), 1));
  fprintf(1,'\n');
end
if strcmp('calcDAL','calcDAL')
  PRMS = length(DAL.regFac);
  % == init ==
  switch method
    case 'lrgl'
      DALstatus = cell(zeros(cnum));
      EbasisWeight = cell(1,cnum);
      Ebias = cell(1,cnum);
% $$$       EbasisWeight{1} = zeros(nbase,cnum);
% $$$       Ebias{1} = 0;
    case 'prgl'
      %      EbasisWeight = cell(1,cnum);
      %      EbasisWeight{1} = zeros(nbase,cnum);
      %      EbasisWeight = cell(1,cnum);
      EbasisWeight = cell(PRMS,1);
      if 1==1
        Ebias = zeros(PRMS,cnum);
      else
        Ebias = cell(1,cnum);
      end
      DALstatus = cell(1,cnum);
      %      Ebias{1} = 0;
    otherwise
      error('This function is under developement.')

      EbasisWeight{i1to}{1} = zeros(nbase,cnum);
  end
  %  fprintf(1,'\n');
  DAL.speedup = 0;
  for ii1 = 1:PRMS
    %% search appropriate parameter.
    %% you'd better not to make for-'ii1' parallelize. 
    cost2 = tic;
    fprintf(1,'\t== Reg.factor: %9.4f == frame: %d<-%d : elapsed: ',...
            DAL.regFac(ii1),DAL.Drow,env.genLoop);
    %%    parfor i1to = 1:cnum % ++parallelization  %bug: EbasisWeight{ii1}{i1to}, Ebias(ii1,i1to)
    for i1to = 1:cnum % ++parallelization:strongly recommended to develop.
      switch  method
        %%+improve: save all data for various method
        case 'lrgl'
          %% logistic regression group lasso
          [EbasisWeight{i1to}, Ebias{i1to}, DALstatus{i1to}] = ...
              dallrgl( zeros(nbase,cnum), 0,...
                       D, pI(:,i1to), DAL.regFac(ii1),...
                       opt);

        case 'prgl_provoked'
          %% poisson regression group lasso: blk
          %% Returned EbasisWeight must be [10x9], not be [90x1] %++bug
          if DAL.speedup == 1
            [EbasisWeight{i1to}, Ebias{i1to}, DALstatus{i1to}] = ...
                dalprgl( EbasisWeight{i1to}, Ebias{i1to}, ...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          else
            [EbasisWeight{i1to}, Ebias{i1to}, DALstatus{i1to}] = ...
                dalprgl( zeros(nbase*cnum,1), 0,...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          end

        case 'prgl'
          %% poisson regression group lasso: 
          if status.parfor_ == 1
            if DAL.speedup == 1
              [EbasisWeight{ii1}{i1to}, Ebias(ii1,i1to), DALstatus{i1to}] = ...
                  dalprgl( EbasisWeight{ii1-1}{i1to}, Ebias(ii1-1,i1to), ...
                           D, pI(:,i1to), DAL.regFac(ii1)...
                           ,opt);
            else
              [EbasisWeight{ii1}{i1to}, Ebias(ii1,i1to), DALstatus{i1to}] = ...
                  dalprgl( zeros(nbase,cnum), 0,...
                           D, pI(:,i1to), DAL.regFac(ii1)...
                           ,opt);
            end
          else
            if DAL.speedup == 1
              [EbasisWeight{ii1}{i1to}, Ebias(ii1,i1to), DALstatus{i1to}] = ...
                  dalprgl( EbasisWeight{ii1-1}{i1to}, Ebias(ii1-1,i1to), ...
                           D, pI(:,i1to), DAL.regFac(ii1)...
                           ,opt);
            else
              [EbasisWeight{ii1}{i1to}, Ebias(ii1,i1to), DALstatus{i1to}] = ...
                  dalprgl( zeros(nbase,cnum), 0,...
                           D, pI(:,i1to), DAL.regFac(ii1)...
                           ,opt);
            end
          end
      end
    end
    DAL.speedup = 1;
    if ii1 <= PRMS && DAL.regFac_UserDef ~= 1
      %      DAL.regFac(ii1+1) = DAL.regFac(ii1)/5;
      DAL.regFac(ii1+1) = DAL.regFac(ii1)/DAL.div; % ODAL
    end
    cost2 =  toc(cost2);
    fprintf(1,'%5.1f\n',cost2);
    Ostatus.time.regFac(useFrameIdx,ii1) = cost2;
    %    Ostatus.time.regFac{}(useFrameIdx,ii1) = cost2;
  end 
  Ostatus.time.estimate_TrueKernel = toc(cost1);
end

function debug_(DEBUG,varargin)
if DEBUG == 1
  whos varargin{:}
end
