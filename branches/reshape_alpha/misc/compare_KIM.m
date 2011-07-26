%function  [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = compare_KIM(env,status,graph,bases,DAL);


%% Prerequisite: 
%% 1) load *.mat generated by 'myest.m' or run 'myest.m'
%% 2) run compare_KIM.m
% [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = compare_KIM(env,status,graph,bases,DAL);

global rootdir_;
global env;
global graph;

nbase = bases.ihbasprs.nbase;

run([rootdir_ '/conf/conf_DAL.m']);
tic
%%% ==< Kim >==
if strcmp('kim','kim')
  %  kDAL = DAL;
  %  kenv = env;  %++bug: ?.
  kDAL.speedup =0;
  opt = DAL.opt;


  load([rootdir_ '/indir/Simulation/data_sim_9neuron.mat'])
  [L,N] = size(X);
  DIV = 100;
  %  kDrow = floor(L/3);
  kDrow = floor(L/DIV);
  kenv.genLoop = L;
  kenv.cnum = N;
  fprintf('\tGenerating Matrix for DAL\n');
  [kD kpenalty] = gen_designMat(kenv,bases,X,kDrow);

  kpEKerWeight{1} = zeros(nbase,kenv.cnum);
  kpEbias{1} = 0;

  if strcmp('dalprgl','dalprgl')
    kpI= X((end - kDrow +1): end,:);
  end
  %% ==< init variables >==
  kDAL.Drow = kDrow;

  tmp.kmethod = 3;
  kDAL.speedup =0;
  kDAL.loop = 3;
  kDAL.regFac = zeros(1,kDAL.loop); % kDAL.regFac: regularization factor.
  if strcmp('setRegFac_auto','setRegFac_auto')
    %  kDAL.regFac(1) = sqrt(nbase)*10; % kDAL.regFac: group LASSO parameter.
    %  kDAL.regFac(1) = sqrt(nbase); % kDAL.regFac:
    kDAL.regFac(1) = uint32(sqrt(kDAL.Drow)); % kDAL.regFac:
  else
    kDAL.regFac(1) = 1; % kDAL.regFac: group LASSO parameter.
  end
  kDAL.div = uint8(sqrt(kDAL.regFac(1)));
  %% ==</init variables >==

  for ii1 = 1:kDAL.loop % search appropriate parameter.
    for i1 = 1:N % ++parallelization 
      fprintf(1,'%d',  tmp.kmethod);
      switch  tmp.kmethod
        case 1
          %% logistic regression group lasso
          [kEKerWeight{i1}, kEbias{i1}, kEstatus{i1}] = ...
              dallrgl( zeros(nbase,kenv.cnum), 0,...
                       kD, kpenalty(:,i1), kDAL.regFac(ii1),...
                       opt);
        case 2
          %% poisson regression group lasso
          if kDAL.speedup == 0
            [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
                dalprgl( zeros(nbase*kenv.cnum,1), 0,...
                         kD, kpI(:,i1), kDAL.regFac(ii1),...
                         'blks',repmat([nbase],[1 kenv.cnum]));
          else
            [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
                dalprgl( kpEKerWeight{i1}, kpEbias{i1}, ...
                         kD, kpI(:,i1), kDAL.regFac(ii1),...
                         'blks',repmat([nbase],[1 kenv.cnum]));
          end
        case 3
          %% poisson regression group lasso: error? Can't be run.
          if kDAL.speedup == 0
            [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
                dalprgl( zeros(nbase,kenv.cnum), 0,...
                         kD, kpI(:,i1), kDAL.regFac(ii1),...
                         opt);
          else
            [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
                dalprgl( kpEKerWeight{i1}, kpEbias{i1}, ...
                         kD, kpI(:,i1), kDAL.regFac(ii1)...
                         ,opt);

          end
      end


      kDAL.speedup = 1;
      if ii1 < kDAL.loop
        %        kDAL.regFac(ii1+1) = kDAL.regFac(ii1)/5;
        kDAL.regFac(ii1+1) = kDAL.regFac(ii1)/kDAL.div;
      end
    end
      switch tmp.method
        case 1
          for i1to = 1:cnum
            for i2from = 1:cnum
              Ealpha{ii1}{i1to}{i2from} = (bases.ihbasis* EKerWeight{i1to}(:,i2from));
            end
          end
          
        case 3
          for i1to = 1:cnum
            for i2from = 1:cnum
              Ealpha{ii1}{i1to}{i2from} = (bases.ihbasis* pEKerWeight{i1to}(:,i2from));
            end
          end
          
        otherwise
      end

    if graph.PLOT_T == 1
          plot_Ealpha(kenv,graph,Ealpha{ii1},...
                                         strcat(['Kim:dalprgl:kDAL regFac'],num2str(kDAL.regFac(ii1))));
      end
    end
  end
end
kEKerWeight = kpEKerWeight;
kEbias = kpEbias;
kEstatus = kpEstatus;

%%% ==</Kim >==
fprintf(1,'%s',toc)