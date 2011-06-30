%% Main program.

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
    tmp1Cpu = cputime();
    run([rootdir_ '/mylib/gen/gen_TrueValue.m']);
    status.time.gen_TrueValue = cputime() - tmp1Cpu;

    ggsim = makeSimStruct_glm(1/env.Hz.video); % Create GLM structure with default params
  end
end

%% Start estimation with DAL.
% measure cpu cost
%cputime
tmp1Cpu = cputime();

if strcmp('allI','allI_')  %++conf
  %%% use all available firing history.
  %% Drow: length of total frames used at loss function.
  Drow = env.genLoop - size(ggsim.iht,1) +1; 
else
  Drow = floor(env.genLoop/2);
end

tmp2Cpu = cputime();
%% dimension reduction to be estimated.
[D penalty] = gen_designMat(env,ggsim,I,Drow);
if strcmp('setLambda_auto','setLambda_auto')
  DAL.lambda = sqrt(ggsim.ihbasprs.nbase)*100; % DAL.lambda: group LASSO parameter.
else
  DAL.lambda = 100; % DAL.lambda: group LASSO parameter.
end
for ii1 = 1:3 % search appropriate parameter.
  DAL.lambda = DAL.lambda/5;
  for i1 = 1:env.cnum % ++parallelization 
    %% logistic regression group lasso
    [EKerWeight{i1}, Ebias{i1}, Estatus{i1}] = ...
        dallrgl( ones(ggsim.ihbasprs.nbase,env.cnum), -1,...
                 D, penalty(:,i1), DAL.lambda,...
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
%[ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,'Estimated_alpha');

status.time.estimate_TrueValue = cputime() - tmp2Cpu;

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
