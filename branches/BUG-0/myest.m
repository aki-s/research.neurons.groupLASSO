%% Main program.
%++debug
profile on -history


global env;
global status;
global rootdir_;   rootdir_ = pwd;

status.time.start = clock;

%% ==< configure >==
%% read user custom configuration.
%% This overrides all configurations below.
run([rootdir_ '/conf/conf_user.m']);

if strcmp('configure', 'configure') %++conf
  run([rootdir_ '/conf/setpaths.m']);
  %< gen_TrueValue
  run([rootdir_ '/conf/conf_graph.m']);
  run([rootdir_ '/conf/conf_rand.m']);
  if status.READ_NEURO_CONNECTION == 1
    run([rootdir_ '/mylib/readTrueConnection.m']);
  end

  run([rootdir_ '/conf/conf_gen_TrueValue.m']);
  env
  %> gen_TrueValue
  %< DAL
  run([rootdir_ '/conf/conf_DAL.m']);
  %> DAL
  run([rootdir_ '/conf/conf_mail.m']);
end
%run([rootdir_ '/conf/conf_user.m']);

%% ==</ configure >==

% check configuration
run([rootdir_ '/mylib/check_conf.m']);

if exist('status') && isfield(status,'GEN')
  if ( 0 == getfield(status,'GEN') )
    warning('WarnTests:convertTest', ...
            'Generating [ FiringIntensity, Firing ] was skipped.\n Warning#1');
  end
else
  status.GEN = 1; % default.
end

if status.GEN == 1
  %% 1.  Set parameters and display for GLM % =============================
  if strcmp('genTrueVale','genTrueVale') %++conf
                                         % measure cpu cost
    %% prepare 'TrueValues'.
    tic;
    run([rootdir_ '/mylib/gen/gen_TrueValue.m']);
    status.time.gen_TrueValue = toc;

    ggsim = makeSimStruct_glm(1/env.Hz.video); % Create GLM structure with default params
  end
end

%% Start estimation with DAL.

tic;
if strcmp('allI','allI_')  %++conf
  %%% use all available firing history.
  %% Drow: length of total frames used at loss function.
  Drow = env.genLoop - size(ggsim.iht,1) +1; 
else
  Drow = floor(env.genLoop/4);
end

%% dimension reduction to be estimated.
fprintf('\tGenerating Matrix for DAL\n');
[D penalty] = gen_designMat(env,ggsim,I,Drow);


if strcmp('debug','debug')
  pI= I(end - Drow +1: end,:);
end

%% ==< init variables >==
tmp.method = 3;

pEKerWeight{1} = zeros(ggsim.ihbasprs.nbase,env.cnum);
pEbias{1} = 0;

DAL.speedup =0;
DAL.loop = 5;
DAL.lambda = zeros(1,DAL.loop +1);
if strcmp('setLambda_auto','setLambda_auto')
  DAL.lambda(1) = sqrt(ggsim.ihbasprs.nbase)*10; % DAL.lambda: group LASSO parameter.
else
  DAL.lambda(1) = 1; % DAL.lambda: group LASSO parameter.
end
%% ==</init variables >==

matlabpool(4);
for ii1 = 1:DAL.loop % search appropriate parameter.
  for i1 = 1:env.cnum % ++parallelization 
    switch  tmp.method
      %%+improve: save all data for various tmp.method
      case 1
        %% logistic regression group lasso
        [EKerWeight{i1}, Ebias{i1}, Estatus{i1}] = ...
            dallrgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                     D, penalty(:,i1), DAL.lambda(ii1),...
                     opt);
      case 2
        %% poisson regression group lasso
if DAL.speedup == 0
         [pEKerWeight{i1}, pEbias{i1}, pEstatus{i1}] = ...
             dalprgl( zeros(ggsim.ihbasprs.nbase*env.cnum,1), 0,...
                      D, pI(:,i1), DAL.lambda(ii1),...
                      'blks',repmat([ggsim.ihbasprs.nbase],[1 env.cnum]));
else
        [pEKerWeight{i1}, pEbias{i1}, pEstatus{i1}] = ...
            dalprgl( pEKerWeight{i1}, pEbias{i1}, ...
                     D, pI(:,i1), DAL.lambda(ii1),...
                     'blks',repmat([ggsim.ihbasprs.nbase],[1 env.cnum]));
end
      case 3
        %% poisson regression group lasso: error? Can't be run.
        [pEKerWeight{i1}, pEbias{i1}, pEstatus{i1}] = ...
            dalprgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                     D, pI(:,i1), DAL.lambda(ii1),...
                     opt);
    end
  end
  DAL.lambda(ii1+1) = DAL.lambda(ii1)/5;
  %  DAL.lambda{} = DAL.lambda*3;
  %++improve: plot lambda [title.a]={};
  if graph.PLOT_T == 1
    switch tmp.method
      case 1
        [ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,strcat(['dallrgl:DAL ' ...
                            'lambda'],num2str(DAL.lambda(ii1))));
      case {2,3}
        [ Ealpha ] = plot_Ealpha(pEKerWeight,pEbias,env,ggsim, ...
                                 strcat(['dalprgl:DAL lambda'],num2str(DAL.lambda(ii1))));
    end
  end
  DAL.speedup = 1;
end
%[ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,'Estimated_alpha');

status.time.estimate_TrueValue = toc;

matlabpool close

%% reconstruct lambda
if strcmp('reconstruct','reconstruct_')

end


%%% ==< Kim >==
if 1 == 0
  load([rootdir_ '/indir/Simulation/data_sim_9neuron.mat'])
  [L,N] = size(X);
  KDrow = floor(N/4);
  Kenv =struct('cnum',N,'genLoop',L);
  fprintf('\tGenerating Matrix for DAL\n');
  [KD Kpenalty] = gen_designMat(Kenv,ggsim,X,KDrow);
  %  kDAL.lambda = 3; % DAL.lambda: group LASSO parameter.
  kDAL.lambda = DAL.lambda;
  for ii1 = 1:3 % search appropriate parameter.
    kDAL.lambda = kDAL.lambda*3;
    for i1 = 1:N % ++parallelization 
      switch  tmp.method
        case 1
          %% logistic regression group lasso
          [kEKerWeight{i1}, kEbias{i1}, kEstatus{i1}] = ...
              dallrgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                       D, penalty(:,i1), kDAL.lambda,...
                       opt);
        case 2
          %% poisson regression group lasso
          [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
              dalprgl( zeros(ggsim.ihbasprs.nbase*env.cnum,1), 0,...
                       D, pI(:,i1), kDAL.lambda,...
                       'blks',repmat([ggsim.ihbasprs.nbase],[1 env.cnum]));
        case 3
          %% poisson regression group lasso: error? Can't be run.
          [kpEKerWeight{i1}, kpEbias{i1}, kpEstatus{i1}] = ...
              dalprgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                       D, pI(:,i1), kDAL.lambda,...
                       opt);
      end
    end

    if graph.PLOT_T == 1
      switch tmp.method
        case 1
          [ kEalpha ] = plot_Ealpha(kEKerWeight,kEbias,env,ggsim,strcat(['Kim:dallrgl:kDAL ' ...
                              'lambda'],num2str(kDAL.lambda)));
        case {2,3}
          [ kEalpha ] = plot_Ealpha(kpEKerWeight,kpEbias,env,ggsim, ...
                                    strcat(['Kim:dalprgl:kDAL lambda'],num2str(kDAL.lambda)));
      end
    end
  end

end
%%% ==</Kim >==

if strcmp('clean','clean')  %++conf
  run([rootdir_ '/mylib/clean.m'])
end


if status.mail == 1
  setpref('Internet','SMTPServer',mail.smtp);
  sendmail(mail.to,'Finished myest.m',status.time.start);
end
status.time.end = clock;

if strcmp('saveInterActive','saveInterActive')  %++conf
  uisave(who,strcat(rootdir_ , 'outdir/mat/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));

  % uisave(who,strcat(rootdir_ , 'outdir/mat/', '...
  %   '  'frame', num2str(sprintf('%05d',env.genLoop)),' ...
  %   '  'hwind', num2str(sprintf('%04d',env.hwind)), '...
  %   '  'hnum' , num2str(sprintf('%02d',env.hnum)))) ;

else
  save( [ rootdir_ '/outdir/myestOut.mat']);
end

status.profile=profile('info');
