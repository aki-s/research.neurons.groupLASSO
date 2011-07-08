%% Main program.
%++debug
profile on -history
global env;
global status;
global rootdir_;   rootdir_ = pwd;
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
end

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
[D penalty] = gen_designMat(env,ggsim,I,Drow);
if strcmp('setLambda_auto','setLambda_auto_')
  DAL.lambda = sqrt(ggsim.ihbasprs.nbase)*100; % DAL.lambda: group LASSO parameter.
else
  DAL.lambda = 2; % DAL.lambda: group LASSO parameter.
end
matlabpool(4);
if strcmp('debug','debug')
  pI= I(end - Drow +1: end,:);
end
status.speedup.DAL =0;
method = 2;
for ii1 = 1:3 % search appropriate parameter.
  DAL.lambda = DAL.lambda*4;
  for i1 = 1:env.cnum % ++parallelization 
    switch  method
      case 1
        %% logistic regression group lasso
        [EKerWeight{i1}, Ebias{i1}, Estatus{i1}] = ...
            dallrgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                     D, penalty(:,i1), DAL.lambda,...
                     opt);
      case 2
        %% poisson regression group lasso
        [pEKerWeight{i1}, pEbias{i1}, pEstatus{i1}] = ...
            dalprgl( zeros(ggsim.ihbasprs.nbase*env.cnum,1), 0,...
                     D, pI(:,i1), DAL.lambda,...
                     'blks',repmat([ggsim.ihbasprs.nbase],[1 env.cnum]));
      case 3
        %% poisson regression group lasso: error? Can't be run.
        [pEKerWeight{i1}, pEbias{i1}, pEstatus{i1}] = ...
            dalprgl( zeros(ggsim.ihbasprs.nbase,env.cnum), 0,...
                     D, pI(:,i1), DAL.lambda,...
                     opt);
    end
  end
  if graph.PLOT_T == 1
    switch method
      case 1
    [ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,strcat(['dallrgl:DAL ' ...
                        'lambda'],num2str(DAL.lambda)));
      case 2
    [ Ealpha ] = plot_Ealpha(pEKerWeight,pEbias,env,ggsim, ...
                             strcat(['dalprgl:DAL lambda'],num2str(DAL.lambda)));
    end
  end
  status.speedup.DAL =1;
end
%[ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,'Estimated_alpha');

status.time.estimate_TrueValue = toc;

matlabpool close

%% reconstruct lambda
if strcmp('reconstruct','reconstruct_')

end


%%% ==< Kim >==
if 1 == 0
  load([rootdir_ 'indir/Simulation/data_sim_9neuron.mat'])
  [L,N] = size(X)
  KDrow = floor(N/4);
  Kenv =struct('cnum',N,'genLoop',L);
  [KD Kpenalty] = gen_designMat(Kenv,ggsim,X,KDrow);
  KDAL.lambda = 0.05; % DAL.lambda: group LASSO parameter.
  for ii1 = 1:1 % search appropriate parameter.
    KDAL.lambda = DAL.lambda/5;
    for i1 = 1:N % ++parallelization 
      %% logistic regression group lasso
      [KEKerWeight{i1}, KEbias{i1}, KEstatus{i1}] = ...
          dallrgl( zeros(ggsim.ihbasprs.nbase,N), -1,...
                   KD, Kpenalty(:,i1), DAL.lambda,...
                   opt);

      %{
      %% poisson regression group lasso
      [Ealpha, Ebias, Estatus] = dalprgl( alpha, alpha0, , ,DAL.lambda);
      %}
    end

    if graph.PLOT_T == 1
      [ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,strcat(['DAL lambda'],num2str(DAL.lambda)));
    end
  end

end
%%% ==</Kim >==

if strcmp('clean','clean')  %++conf
  run([rootdir_ '/mylib/clean.m'])
end

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