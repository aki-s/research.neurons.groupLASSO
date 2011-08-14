%% Main program.
%% HowTo)
%% close all; clear all; myest
global env;
global status;
global Tout;
global graph; %++bug: global
global rootdir_;   rootdir_ = pwd;

status.time.start = fix(clock);

run([rootdir_ '/conf/setpaths.m']);

%% ==< configure >==
%% read user custom configuration.
%% This overrides all configurations below.
%run([rootdir_ '/conf/conf_user.m']);

if strcmp('configure', 'configure') %++conf

  %  run([rootdir_ '/conf/conf_progress.m']);
  %  status = conf_progress(status);
  conf_progress();

  %  run([rootdir_ '/conf/conf_graph.m']);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.

  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

run([rootdir_ '/conf/conf_user.m']);
gen_defaultEnv_ask();

if status.READ_NEURO_CONNECTION == 1
   [alpha_fig,alpha_hash] = readTrueConnection();
else 
  [alpha_fig,alpha_hash] = gen_alpha_hash();
end
get_neuronType(env,status,alpha_fig);

%% ==</ configure >==

% check configuration
if 1== 0
  check_conf(env,status,Tout,graph);
else
  check_conf();
end
status = check_genState(status);

echo_initStatus(env,status,Tout)


%% bases should be loaded from a mat file.
bases = makeSimStruct_glm(0.01); % Create GLM structure with default params

if status.GEN_TrureValues == 1
  %% 1.  Set parameters and display for GLM % =============================
  if strcmp('genTrueVale','genTrueVale') %++conf
    %% prepare 'TrueValues'.
    tic;
    if 1 == 1
      [alpha ] = gen_TrueWeightKernel(env,status,alpha_hash);
      [alpha0] = gen_TrueWeightSelf(env);
      [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha);
      %      Tout = get_neuronType(env,status,alpha_fig);
      echo_TrueValueStatus(env,status,lambda,I);

      run([rootdir_ '/mylib/plot/plot_TrueValues']);
    end
    status.time.gen_TrueValue = toc;

  end
end

%% ==< Start estimation with DAL>==

if status.estimateConnection == 1
  %% matlabpool close force local
  matlabpool(8);

  DAL = setDALregFac(DAL,bases);
  [EKerWeight,Ebias,Estatus,DAL] = estimateWeightKernel(env,graph,bases,I,DAL);
  %++bug Ebias isn't correct.
  Ealpha = reconstruct_Ealpha(env,DAL,bases,EKerWeight);
  if graph.PLOT_T == 1
    fprintf(1,'\n\n Now plotting estimated kernel\n');
    for i1 = 1:length(DAL.regFac)
    plot_Ealpha(env,graph,Ealpha{i1},...
                strcat(['dallrgl:DAL regFac=  '], num2str(DAL.regFac(i1))));
    end
  end
  %% reconstruct lambda
  if strcmp('reconstruct','reconstruct_')
    error('not yet implemented')
    estimateFiringIntensity(Ebias,EKerWeight);
  end

  %% compare results from group LASSO and GCM by KIM
% $$$ [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = compare_KIM(env,status,graph,bases,DAL);

  matlabpool close
  %% ==</Start estimation with DAL>==
end


%[Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,2,alpha_hash,Ebias);
[Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,2);

if (graph.PLOT_T == 1)
plot_CausalMatrix(reshape(Ealpha_hash,[],env.cnum),'');
% $$$   plot_alpha_ternary(graph,env,Ealpha_hash,'Estimated,group LASSO');
plot_CausalMatrix(alpha_fig,'')
% $$$   plot_alpha_ternary(graph,env,alpha_hash,' True connection');
end

status.time.end = fix(clock);

if status.estimateConnection == 1
  mailMe(env,status,DAL,'Finished myest.m')
end

fprintf(1,'Saving variables....\n');
tmp0 = status.time.start;
mkdirname = [date,num2str(tmp0(4)),num2str(tmp0(5))];
mkdir( [ rootdir_ '/outdir/'],mkdirname)
savedirname =  [ rootdir_ '/outdir/',mkdirname];
if status.use.GUI == 1
  uisave(who,strcat(savedirname,'/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));
else
  save([savedirname,'/',date,num2str(tmp0(4)),num2str(tmp0(5)),'.mat']);
end

status.profile=profile('info');

%% ==< save all graph >==
if (graph.SAVE_ALL == 1)
  tmp.figHandles = get(0,'Children');
  tmp.fnames = {''}; %++bug:not yet implemented.
  if length(tmp.figHandles) == length(tmp.fnames)
    for i1 = 1:length(tmp.fnames)
      print(i1,[savedirname,tmp.fnames(i1)],'eps');
    end
  else
    for i1 = 1:length(tmp.figHandles)
      print(tmp.figHandles(i1),'-depsc',sprintf('%s/%02d',savedirname,i1) );
    end
  end
end 

%% ==< clean >==
if strcmp('clean','clean')  %++conf
  run([rootdir_ '/mylib/clean.m'])
end

%fin();
