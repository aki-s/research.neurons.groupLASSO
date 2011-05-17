% 110401
%clear all; close all;
%% ==< configure >==
  if strcmp('configure', 'configure')
    global rootdir_;
    rootdir_ = pwd;
    %    global env;
    %env = struct();
    run([rootdir_ '/conf/setpaths.m'])
    %< gen_TrueValue
    run([rootdir_ '/conf/conf_graph.m'])
    run([rootdir_ '/conf/conf_rand.m']);
    run([rootdir_ '/conf/conf_gen_TrueValue.m'])
    %> gen_TrueValue
    %< DAL
    run([rootdir_ '/conf/conf_DAL.m'])
    %> DAL
  end

  %% ==</ configure >==

if exist('status') && ( 0 == getfield(status,'GEN'))
  warning('Generating true value is skipped.');
else
  status.GEN = 1;
end

if status.GEN == 1
  %% 1.  Set parameters and display for GLM % =============================
  if strcmp('tmp','tmp_')
    gg = makeSimStruct_glm(1/100);
  end

  if strcmp('genTrueVale','genTrueVale')
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
%
if strcmp('allI','allI_')
  %% use all available firing history.
  Drow = env.genLoop - size(ggsim.iht,1) +1; 
else
  Drow = floor(env.genLoop/2);
end

[D penalty] = gen_designMat(env,ggsim,I,Drow);
DAL.lambda = 30;
for ii1 = 1:5
  DAL.lambda = DAL.lambda/(1.5);
  for i1 = 1:env.cnum
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

  [ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,strcat('DAL\lambda',num2str(DAL.lambda)));
end
%[ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,'Estimated_alpha');

if strcmp('clean','clean')
  run([rootdir_ '/mylib/clean.m'])
end

if strcmp('saveInterActive','saveInterActive')
  uisave(who,strcat(rootdir_ , 'outdir/mat/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));

  % uisave(who,strcat(rootdir_ , 'outdir/mat/', '...
  %   '  'frame', num2str(sprintf('%05d',env.genLoop)),' ...
  %   '  'hwind', num2str(sprintf('%04d',env.hwind)), '...
  %   '  'hnum' , num2str(sprintf('%02d',env.hnum)))) ;

else
  save( [ rootdir_ '/outdir/myestOut.mat']);
end
