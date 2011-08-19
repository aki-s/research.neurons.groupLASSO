function [EKerWeight,Ebias,Estatus,DAL] = estimateWeightKernel(env,graph,bases,I,DAL)
%%
%%
%%
%%
% [KerWeight,Ebias,Estatus,DAL] = ...
% estimateWeightKernel(env,status,graph,bases,I,DAL);

global status;

tic;
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
  if ( m > env.genLoop-1)
    error('DAL.Drow > env.genLoop' )
  end
elseif strcmp('auto','auto')
  DAL.Drow = floor(env.genLoop/4);

elseif strcmp('allI','allI_')  %++conf
  %%% use all available firing history.
  %% Drow: length of total frames used at loss function.
  DAL.Drow = env.genLoop - size(bases.iht,1) -1; 
end

%% ==< init variables >==
method = DAL.method;

%% ==</init variables >==

%if (status.GEN_TrueValues == 1)
  % && ~exist('D')
if 1 == 1
  %% dimension reduction to be estimated.
  fprintf('\tGenerating Matrix for DAL\n');
  [D0] = gen_designMat(env,bases,I,DAL.Drow);
  DAL.D = D0;
  D = D0;
  %  DAL.Drow = Drow.Drow - length(bases.iht);

  if strcmp(method,'prgl')
    pI= I( (end - DAL.Drow+ length(bases.iht) +1): end,:);
  elseif strcmp(method,'lrgl')
    pI =  2 * I( (end - DAL.Drow+ length(bases.iht) +1): end,:) - 1;
  end
elseif    exist('D0')
  warning(BUG:status,'reused Matrix ''DAL.D'''.');
end


if strcmp('calcDAL','calcDAL')
  %  Ealpha = cell(zeros(1,DAL.loop));
  % == init ==
  switch method
    case 'lrgl'
      Estatus = cell(zeros(cnum));
      EKerWeight = cell(1,cnum);
      Ebias = cell(1,cnum);
% $$$       EKerWeight{1} = zeros(nbase,cnum);
% $$$       Ebias{1} = 0;
    case 'prgl'
      %      EKerWeight = cell(1,cnum);
      %      EKerWeight{1} = zeros(nbase,cnum);
      EKerWeight = cell(1,cnum);
      Ebias = cell(1,cnum);
      Estatus = cell(1,cnum);
      %      Ebias{1} = 0;
    otherwise
      error('This function is under developement.')

      EKerWeight = cell(cnum, 1, DAL.loop);
      EKerWeight{i1to}{1} = zeros(nbase,cnum);
      Ebias = cell(DAL.loop,1);
  end
  %  PRMS = length(DAL.loop);%++bug sericous?
  PRMS = length(DAL.regFac);
  %  D = D0;
  for ii1 = 1:PRMS % search appropriate parameter.
    fprintf(1,'\n\n == Regularization factor: %f == \n',DAL.regFac(ii1));
    for i1to = 1:cnum % ++parallelization 
      switch  method
        %%+improve: save all data for various method
        case 'lrgl'
          %% logistic regression group lasso
          [EKerWeight{i1to}, Ebias{i1to}, Estatus{i1to}] = ...
              dallrgl( zeros(nbase,cnum), 0,...
                       D, pI(:,i1to), DAL.regFac(ii1),...
                       opt);
        case 'prgl_provoked'
          %% poisson regression group lasso: blk
          %% Returned EKerWeight must be [10x9], not be [90x1] %++bug
          if DAL.speedup == 1
            [EKerWeight{i1to}, Ebias{i1to}, Estatus{i1to}] = ...
                dalprgl( EKerWeight{i1to}, Ebias{i1to}, ...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          else
            [EKerWeight{i1to}, Ebias{i1to}, Estatus{i1to}] = ...
                dalprgl( zeros(nbase*cnum,1), 0,...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          end
        case 'prgl'
          %% poisson regression group lasso: 
          if DAL.speedup == 1 
            [EKerWeight{i1to}, Ebias{i1to}(ii1), Estatus{i1to}] = ...
                dalprgl( EKerWeight{i1to}, Ebias{i1to}(ii1-1), ...
                         D, pI(:,i1to), DAL.regFac(ii1)...
                         ,opt);
          else
            [EKerWeight{i1to}, Ebias{i1to}(ii1), Estatus{i1to}] = ...
                dalprgl( zeros(nbase,cnum), 0,...
                         D, pI(:,i1to), DAL.regFac(ii1)...
                         ,opt);
          end
      end
    end
    %++improve: plot lambda [title.a]={};
    DAL.speedup = 1;
    if ii1 <= PRMS && DAL.regFac_UserDef ~= 1
      %      DAL.regFac(ii1+1) = DAL.regFac(ii1)/5;
      DAL.regFac(ii1+1) = DAL.regFac(ii1)/DAL.div;
    end
  end
  
  status.time.estimate_TrueKernel = toc;
end

