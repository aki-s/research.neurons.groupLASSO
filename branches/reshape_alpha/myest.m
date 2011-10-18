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
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.
  [env status ] = conf_IO(env,status);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);
  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

run([rootdir_ '/conf/conf_user.m']);

if  (status.READ_FIRING == 1)
  [env I Tout] = readI(env,status,Tout,'X',2); %+nogood
end

gen_defaultEnv_ask();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%<


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>
if (status.realData ~= 1 )
  if (status.READ_NEURO_CONNECTION == 1) % (status.READ_FIRING ~= 1)
    [alpha_fig,alpha_hash,env,status] = readTrueConnection(env,status);
  else % random network connection
    [alpha_fig,alpha_hash,status] = gen_alpha_hash(env,status);
  end
  Tout = get_neuronType(env,status,alpha_fig,Tout);
else
  status.inStructFile = '';
end

%% ==</ configure >==

%% bases should be loaded from a mat file.
%% large argment make small width of basis.

bases = makeSimStruct_glm(0.2); % Create GLM structure with default params
%% 0.2 : 118

[env status Tout graph DAL] = check_conf(env,status,Tout,graph,bases,DAL);
status = check_genState(status);
echo_initStatus(env,status,Tout)
if ( status.GEN_TrueValues == 1 ) 
  %% 1.  Set parameters and display for GLM % =============================
  %% prepare 'TrueValues'.
  tic;
  [alpha ] = gen_TrueWeightKernel(env,status,alpha_hash);
  [alpha0] = gen_TrueWeightSelf(env,status);
  [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha);
  echo_TrueValueStatus(env,status,lambda,I);

  run([rootdir_ '/mylib/plot/plot_TrueValues']);
  status.time.gen_TrueValue = toc;
end


%% ==< Start estimation with DAL>==

if status.estimateConnection == 1
  useFrameLen = length(env.useFrame);
  if status.parfor_ == 1 && ( matlabpool('size') == 0 )
    matlabpool(8);
  end
  %% matlabpool close force local
  DAL = setDALregFac(env,DAL,bases);
  regFacLen = length(DAL.regFac);
  %  CVE = zeros(useFrameLen,regFacLen);
  %% CVE: cross Validat error
  CVE = zeros(regFacLen,env.cnum,useFrameLen);
  status.time.regFac = zeros(useFrameLen,regFacLen);
  
  CVwhole = zeros(useFrameLen,1);
  idxRfWhole = zeros(useFrameLen,1); %Rf: regularization factor
  CVeach = zeros(useFrameLen,env.cnum);
  idxRfEach = zeros(useFrameLen,env.cnum);
  for i1 =1:length(env.useFrame)  % ( %++parallel? not practical.)
    if env.useFrame(i1) <= env.genLoop
      DAL.Drow = env.useFrame(i1);
      if strcmp('crossValidation','crossValidation')
        %% ==< choose appropriate regFac >==
        %        CVE(i1,1:regFacLen) =
        %        crossVal(env,graph,status.crossVal,DAL,bases,I,i1);
        if status.parfor_ == 1
        [ CVE(1:regFacLen,1:env.cnum,i1) ] =...
            crossVal_parfor(env,graph,status,DAL,bases,I,i1);
else
        [ CVE(1:regFacLen,1:env.cnum,i1), status ] =...
            crossVal(env,graph,status,DAL,bases,I,i1);
end
        %% ==</choose appropriate regFac >==
        [CVwhole(i1),idxRfWhole(i1)]             = min(sum(CVE(:,:,i1),2),[],1);
        [CVeach(i1,1:env.cnum),idxRfEach(i1,1:env.cnum)] = min(CVE(:,:,i1),[],1); % each neuron

      else

        [EKerWeight,Ebias,Estatus,DAL,status] = estimateWeightKernel(env,graph,status,bases,I,DAL,i1);
        %++bug Ebias isn't correct.
        Ealpha = reconstruct_Ealpha(env,DAL,bases,EKerWeight);
        transform_Ealpha(Ealpha,DAL,status,regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2'));
        
        if graph.PLOT_T == 1
          fprintf(1,'\n\n Now plotting estimated kernel\n');
          for i2 = 1:regFacLen
            %          plot_Ealpha(env,graph,Ealpha,DAL,i2,sprintf('elapsed:%s',num2str(status.time.regFac(i1,i2))) )
            plot_Ealpha(env,graph,DAL,bases,EKerWeight,i2,... 
                        sprintf('elapsed:%s',num2str(status.time.regFac(i1,i2))) )
          end
        end
        %% reconstruct lambda
        if strcmp('reconstruct','reconstruct_')
          error('not yet implemented')
          estimateFiringIntensity(I,Ebias,EKerWeight);
        end
      end
      %% ==</Start estimation with DAL>==
    else
      warning('DEBUG:NOTICE','env.useFrame > env.genLoop')
    end
  end
  if status.parfor_ == 1
    matlabpool close
  end
end

%% ==< eval >==
%{
for i1 = 1:regFacLen
  [Ealpha_hash,Ealpha_fig,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,i1,status);
end
%}
if (graph.PLOT_T == 1)
  %{
  plot_CausalMatrix(Ealpha_fig,'Estimated,group LASSO');
  plot_CausalMatrix(alpha_fig,'True connection')
  %}
end
%% ==</eval >==

status.time.end = fix(clock);

if status.save_vars == 1
  fprintf(1,'Saving variables....\n');
  tmp0 = status.time.start;
  mkdirname = [date,'-start-',num2str(tmp0(4)),'_',num2str(tmp0(5))];
  mkdir( [ rootdir_ '/outdir/'],mkdirname)
  savedirname =  [ rootdir_ '/outdir/',mkdirname];
  if status.use.GUI == 1
    uisave(who,strcat(savedirname,'/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));
  else
    tmp.v = datevec(date);
    status.outputfilename = [savedirname,'/',num2str(tmp.v(3)),'_',num2str(tmp.v(2)),'_',num2str(tmp.v(1)),'__',num2str(tmp0(4)),'_',num2str(tmp0(5)),'.mat'];
    save(status.outputfilename);
  end
  fprintf(1,'outputfilename:\n %s\n',status.outputfilename)
end

status.profile=profile('info');


if status.estimateConnection == 1
  mailMe(env,status,DAL,bases,'Finished myest.m')
end

%% ==< save all graph >==
if (graph.SAVE_ALL == 1)
  tmp.figHandles = get(0,'Children');
  tmp.fnames = {'garbage'}; %++bug:not yet implemented.
  if length(tmp.figHandles) == length(tmp.fnames)
    for i1 = 1:length(tmp.fnames)
      print(i1,'-depsc',sprintf('%s/%s',savedirname,tmp.fnames{i1}));
    end
  else
    for i1 = 1:length(tmp.figHandles)
      print(tmp.figHandles(i1),'-depsc',sprintf('%s/%02d',savedirname,i1) );
    end
  end
end 

%% ==< clean >==
if strcmp('clean','clean_')  %++conf
  run([rootdir_ '/mylib/clean.m'])
end

%{
%fin();
t=readTrueConnection(env,status,status.inStructFile);
et=reshape(Ealpha_hash,[],env.cnum);
calcCorrectNum(t,et)
[Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,4);
%}