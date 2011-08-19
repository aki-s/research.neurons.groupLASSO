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

if strcmp('configure', 'configure') %++conf
  conf_progress();
  [env status ] = conf_IO(env,status);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.
  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

run([rootdir_ '/conf/conf_user.m']);
gen_defaultEnv_ask();

if status.READ_NEURO_CONNECTION == 1
  [alpha_fig,alpha_hash,env,status] = readTrueConnection(env,status);
else 
  if  (status.READ_FIRING == 1)
    [env I Tout] = readI(env,status,Tout);
  end
  [alpha_fig,alpha_hash,status] = gen_alpha_hash(env,status);
end
get_neuronType(env,status,alpha_fig);

%% ==</ configure >==

%% bases should be loaded from a mat file.
%% large argment make small width of basis.
bases = makeSimStruct_glm(0.2); % Create GLM structure with default params
%% 0.2 : 118

[env status Tout graph] = check_conf(env,status,Tout,graph,bases);
status = check_genState(status);
echo_initStatus(env,status,Tout)
if ( status.GEN_TrueValues == 1 ) 
  %% 1.  Set parameters and display for GLM % =============================
  %% prepare 'TrueValues'.
  tic;
  [alpha ] = gen_TrueWeightKernel(env,status,alpha_hash);
  [alpha0] = gen_TrueWeightSelf(env);
  [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha);
  echo_TrueValueStatus(env,status,lambda,I);

  run([rootdir_ '/mylib/plot/plot_TrueValues']);
  status.time.gen_TrueValue = toc;
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

  matlabpool close
  %% ==</Start estimation with DAL>==
end


for i1 = 1:length(DAL.regFac)
  [Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,i1,status);
end

if (graph.PLOT_T == 1)
  plot_CausalMatrix(reshape(Ealpha_hash,[],env.cnum),'Estimated,group LASSO');
  plot_CausalMatrix(alpha_fig,'True connection')
end

status.time.end = fix(clock);

fprintf(1,'Saving variables....\n');
tmp0 = status.time.start;
mkdirname = [date,'-start-',num2str(tmp0(4)),'_',num2str(tmp0(5))];
mkdir( [ rootdir_ '/outdir/'],mkdirname)
savedirname =  [ rootdir_ '/outdir/',mkdirname];
if status.use.GUI == 1
  uisave(who,strcat(savedirname,'/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));
else
  status.outputfilename = [savedirname,'/',date,'-',num2str(tmp0(4)),'_',num2str(tmp0(5)),'.mat'];
  save(status.outputfilename);
end
fprintf(1,'outputfilename:\n %s\n',status.outputfilename)

status.profile=profile('info');


if status.estimateConnection == 1
  mailMe(env,status,DAL,bases,'Finished myest.m')
end

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

%{
%fin();
t=readTrueConnection(env,status,status.inStructFile);
et=reshape(Ealpha_hash,[],env.cnum);
calcCorrectNum(t,et)
[Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,4);
%}