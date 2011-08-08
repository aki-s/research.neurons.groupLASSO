function [pEKerWeight,pEbias,pEstatus,Ealpha,DAL] = estimateWeightKernel(env,graph,bases,I,DAL)
%%
%%
%%
%%
% [KerWeight,Ebias,Estatus,Ealpha,DAL] = ...
% estimateWeightKernel(env,status,graph,bases,I,DAL);

global status;

tic;
cnum = env.cnum;
nbase = bases.ihbasprs.nbase; % nbase: number of bases.
opt = DAL.opt;

if strcmp('allI','allI_')  %++conf
  %%% use all available firing history.
  %% Drow: length of total frames used at loss function.
  DAL.Drow = env.genLoop - size(bases.iht,1) +1; 
else
  DAL.Drow = floor(env.genLoop/4);
end

%% ==< init variables >==
tmp.method = DAL.method;

DAL.speedup =0;
DAL.loop = 3;
DAL.regFac = zeros(1,DAL.loop); % DAL.regFac: regularization factor.
if strcmp('setRegFac_auto','setRegFac_auto')
 if 1==1
   DAL.regFac(1) = sqrt(nbase)*10; % DAL.regFac: group LASSO parameter.
 else
   DAL.regFac(1) = sqrt(nbase); % DAL.regFac:
 end
 %  DAL.regFac(1) = uint32(sqrt(DAL.Drow)); % DAL.regFac:
 %  DAL.regFac(1) = uint32(sqrt(DAL.Drow)*nbase); % DAL.regFac:
else
  DAL.regFac(1) = 1; % DAL.regFac: group LASSO parameter.
end

%DAL.div = uint8(sqrt(DAL.regFac(1)));
DAL.div = 2;
%% ==</init variables >==

if status.GEN_TrureValues == 1
  %% dimension reduction to be estimated.
  fprintf('\tGenerating Matrix for DAL\n');
  [D penalty] = gen_designMat(env,bases,I,DAL.Drow);
  DAL.D = D;
  DAL.penalty = penalty;

  if strcmp('dalprgl','dalprgl')
    pI= I( (end - DAL.Drow +1): end,:);
  end

elseif    exist('D') && exist('penalty')
  warning(BUG:status,'reused Matrix ''DAL.D'' and ''DAL.penalty''.');
end


if strcmp('calcDAL','calcDAL')

  % == init ==
  Ealpha = cell(zeros(1,DAL.loop));
  switch tmp.method
    case 'lrgl'
      Estatus = cell(zeros(cnum));
      EKerWeight = cell(1,cnum);
      Ebias = cell(1,cnum);
% $$$       EKerWeight{1} = zeros(nbase,cnum);
% $$$       Ebias{1} = 0;
    case {2,'prgl'}
      %      pEKerWeight = cell(1,cnum);
      %      pEKerWeight{1} = zeros(nbase,cnum);
      pEKerWeight = cell(1,cnum);
      pEbias = cell(1,cnum);
      pEstatus = cell(1,cnum);
      %      pEbias{1} = 0;
    otherwise
      error('This function is under developement.')

      EKerWeight = cell(cnum, 1, DAL.loop);
      EKerWeight{i1to}{1} = zeros(nbase,cnum);
      pEbias = cell(DAL.loop,1);
  end
  for ii1 = 1:DAL.loop % search appropriate parameter.
    fprintf(1,'\n\n == Regularization factor: %f == \n',DAL.regFac(ii1));
    for i1to = 1:cnum % ++parallelization 
      switch  tmp.method
        %%+improve: save all data for various tmp.method
        case 'lrgl'
          %% logistic regression group lasso
          [EKerWeight{i1to}, Ebias{i1to}, Estatus{i1to}] = ...
              dallrgl( zeros(nbase,cnum), 0,...
                       D, penalty(:,i1to), DAL.regFac(ii1),...
                       opt);
        case 2
          %% poisson regression group lasso: blk
          %% Returned pEKerWeight must be [10x9], not be [90x1] %++bug
          if DAL.speedup == 1
            [pEKerWeight{i1to}, pEbias{i1to}, pEstatus{i1to}] = ...
                dalprgl( pEKerWeight{i1to}, pEbias{i1to}, ...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          else
            [pEKerWeight{i1to}, pEbias{i1to}, pEstatus{i1to}] = ...
                dalprgl( zeros(nbase*cnum,1), 0,...
                         D, pI(:,i1to), DAL.regFac(ii1),...
                         'blks',repmat(nbase,[1 cnum]));
          end
        case 'prgl'
          %% poisson regression group lasso: 
          if DAL.speedup == 1 
            [pEKerWeight{i1to}, pEbias{i1to}(ii1), pEstatus{i1to}] = ...
                dalprgl( pEKerWeight{i1to}, pEbias{i1to}(ii1-1), ...
                         D, pI(:,i1to), DAL.regFac(ii1)...
                         ,opt);
          else
            [pEKerWeight{i1to}, pEbias{i1to}(ii1), pEstatus{i1to}] = ...
                dalprgl( zeros(nbase,cnum), 0,...
                         D, pI(:,i1to), DAL.regFac(ii1)...
                         ,opt);
          end
      end
    end
    %++improve: plot lambda [title.a]={};
      switch tmp.method
        case 'lrgl'
          for i1to = 1:cnum
            for i2from = 1:cnum
              Ealpha{ii1}{i1to}{i2from} = (bases.ihbasis* EKerWeight{i1to}(:,i2from));
            end
          end
          
        case 'prgl'
          for i1to = 1:cnum
            for i2from = 1:cnum
              Ealpha{ii1}{i1to}{i2from} = (bases.ihbasis* pEKerWeight{i1to}(:,i2from));
            end
          end
          
        otherwise
      end

% $$$       if graph.PLOT_T == 1
% $$$           plot_Ealpha(env,graph,Ealpha{ii1},...
% $$$                       strcat(['dallrgl:DAL regFac=  '],num2str(DAL.regFac(ii1))));
% $$$       end
      DAL.speedup = 1;
      if ii1 < DAL.loop
        %      DAL.regFac(ii1+1) = DAL.regFac(ii1)/5;
        DAL.regFac(ii1+1) = DAL.regFac(ii1)/DAL.div;
      end
  end
  
  status.time.estimate_TrueKernel = toc;
end

switch tmp.method
  case 'lrgl'
    pEKerWeight = EKerWeight;
    pEbias = Ebias;
    pEstatus = Estatus;
end
