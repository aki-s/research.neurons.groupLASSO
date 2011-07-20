%% Main program.
global env;
global status;
global Tout;
global rootdir_;   rootdir_ = pwd;

status.time.start = fix(clock);

run([rootdir_ '/conf/setpaths.m']);

%% ==< configure >==
%% read user custom configuration.
%% This overrides all configurations below.
%run([rootdir_ '/conf/conf_user.m']);

if strcmp('configure', 'configure') %++conf

  run([rootdir_ '/conf/conf_progress.m']);

  run([rootdir_ '/conf/conf_graph.m']);
  run([rootdir_ '/conf/conf_rand.m']);
  if status.READ_NEURO_CONNECTION == 1
    run([rootdir_ '/mylib/readTrueConnection.m']);
  end

  [DAL] = conf_DAL(); % configuration for solver 'DAL'.

  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

run([rootdir_ '/conf/conf_user.m']);

gen_defaultEnv_ask(env,status);


env

%% ==</ configure >==

% check configuration
run([rootdir_ '/mylib/check/check_conf.m']);
status = check_genState(status);

if status.GEN_TrureValues == 1
  %% 1.  Set parameters and display for GLM % =============================
  if strcmp('genTrueVale','genTrueVale') %++conf
    %% prepare 'TrueValues'.
    tic;
    if 1 == 1
      [alpha ] = gen_TrueWeightKernel(env,status,alpha_hash);
      [alpha0] = gen_TrueWeightSelf(env);
      [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha);
      run([rootdir_ '/mylib/plot/plot_TrueValues']);
      get_neuronType(env,status,alpha_fig);
      echo_TrueValueStatus(env,status);
    else
      run([rootdir_ '/mylib/gen/gen_TrueValue.m']);
    end
    status.time.gen_TrueValue = toc;

  end
end

%% bases should be loaded from mat file.
bases = makeSimStruct_glm(1/env.Hz.video); % Create GLM structure with default params

%% ==< Start estimation with DAL>==

if status.estimateConnection == 1
  %% matlabpool close force local
  matlabpool(8);

  [KerWeight,Ebias,Estatus,Ealpha,DAL] = estimateWeightKernel(env,status,graph,bases,I,DAL);
  %% reconstruct lambda
  if strcmp('reconstruct','reconstruct_')
    
  end

% $$$ [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = compare_KIM(env,status,graph,bases,DAL);

  matlabpool close
  %% ==</Start estimation with DAL>==
end

status.time.end = fix(clock);

if status.estimateConnection == 1
  mailMe(env,status,DAL)
end

tmp0 = status.time.start;
if strcmp('saveInterActive','saveInterActive')  %++conf
  uisave(who,strcat(rootdir_ , 'outdir/mat/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));

  % uisave(who,strcat(rootdir_ , 'outdir/mat/', '...
  %   '  'frame', num2str(sprintf('%05d',env.genLoop)),' ...
  %   '  'hwind', num2str(sprintf('%04d',env.hwind)), '...
  %   '  'hnum' , num2str(sprintf('%02d',env.hnum)))) ;

else
  save( [ rootdir_ '/outdir/',date,tmp0(4),tmp0(5),'.mat']);
end

status.profile=profile('info');



%% ==< clean >==
if strcmp('clean','clean')  %++conf
  run([rootdir_ '/mylib/clean.m'])
end


