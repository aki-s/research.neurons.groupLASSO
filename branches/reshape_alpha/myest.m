%% Main program.
%% HowTo)
%% close all; clear all; myest
global env;
global status;
global Tout;
global graph;
global rootdir_;   rootdir_ = pwd;

status.time.start = fix(clock);
run([rootdir_ '/conf/setpaths.m']);
[status.savedirname] = setSavedirName(rootdir_,status);
diary([status.savedirname,'/',sprintf('%d_',status.time.start),'diary.txt'])%log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%<
%% ==< configure >==
if strcmp('configure', 'configure')
  conf_progress();
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.
  [env status ] = conf_IO(env,status);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);
  bases = conf_makeSimStruct_glm(); % load parameters.
  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

%% Reading user custom configuration file
%%  overrides all configurations previously set.
if strcmp('gaya','gaya')
  status.userDef = [rootdir_ '/conf/conf_user_gaya.m'];
elseif strcmp('kim','kim_')
  %  status.userDef = [rootdir_ '/conf/conf_user_kim.m'];
  status.userDef = [rootdir_ '/conf/conf_user_kim_20111110_185429.m']; %
elseif strcmp('aki','aki_')
  status.userDef = [rootdir_ '/conf/conf_user_aki.m'];
else
  %% set null file till user defines.
  status.userDef = [rootdir_ '/conf/conf_user.m'];
end
run(status.userDef);
%% ==</ configure >==

if  (status.READ_FIRING == 1)
  [env I Tout] = readI(env,status,Tout);
end

gen_defaultEnv_ask(); % set default params (compliment missing params)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>
if (status.realData ~= 1 )
  if (status.READ_NEURO_CONNECTION == 1) % from I/O % (status.READ_FIRING ~= 1)
    %% e.g. Enter 'indir/KimFig1.con' when asked.
    [ResFunc_fig,ResFunc_hash,env,status] = readTrueConnection(env,status);
    Tout = get_neuronType(env,status,ResFunc_fig,Tout);
  elseif (status.GEN_TrueValues == 1)  % generate artifical random network connection
    [ResFunc_fig,ResFunc_hash,status] = gen_ResFunc_hash(env,status);
    Tout = get_neuronType(env,status,ResFunc_fig,Tout);
  end
else
  status.inStructFile = '';
end

%%++improve
%% bases should be loaded from a mat file.
%% large argment of makeSimStruct_glm() make small width of basis.
bases = makeSimStruct_glm(bases,1/env.Hz.video); % Create GLM structure with default params

[env status Tout graph DAL] = check_conf(env,status,Tout,graph,bases,DAL);
status = check_genState(status);
echo_initStatus(env,status,Tout)

if ( status.GEN_TrueValues == 1 ) 
  %% 1.  Set parameters and display for GLM % =============================
  %% prepare 'TrueValues'.
  tic;
  [ResFunc ] = gen_TrueWeightKernel(env,status,ResFunc_hash);
  [ResFunc0] = gen_TrueWeightSelf(env,status);
  [I,lambda,loglambda] = gen_TrueI(env,ResFunc0,ResFunc);
  echo_TrueValueStatus(env,status,lambda,I);

  run([rootdir_ '/mylib/plot/plot_TrueValues']);
  status.time.gen_TrueValue = toc;
end


%% ==< Start estimation with DAL>==

if status.estimateConnection == 1
  set_matlabpool(status.parfor_,status.crossVal);

  %% CVL: cross Validation Log Likelihood ++rename:CVL->CVLL
  [CVL CVLs] = init_CVL(env.useNeuroLen,env.inFiringUSE,env.useFrameLen,DAL.regFacLen);
  %{
  %% not yet
  EbasisWeight = cell(1,env.useNeuroLen);
  Ebias = cell(1,env.useNeuroLen);
  EResFunc =  cell(1,env.useNeuroLen);
  %}
  %%< prepare for 'parfor' >
  tenv    = env; %% make 'env' global to local variable 'tenv'
  tgraph  = graph; %% make 'graph' global to local variable 'tgraph'
  tstatus = status;%% make 'status' global to local variable 'tstatus'
  tDAL    = DAL;
  %%</prepare for 'parfor' >
  for i0 = 1:env.useNeuroLen
    fprintf('%s\n',repmat('=',[30 1]));
    fprintf(1,'#neuron:%5d<-%5d\n',tenv.inFiringUSE(i0),env.cnum);
    tmpI = I(:,1:env.inFiringUSE(i0));
    tenv.cnum = env.inFiringUSE(i0);

    %%< loop:env.useFrameLen >
    for i1 =1:env.useFrameLen
      echo_usingFrame(tenv.useFrame(i1));
      %% ( %++parallel? not practical for biological real data.)
      if ( bases.ihbasprs.numFrame <= tenv.useFrame(i1) ) && ( tenv.useFrame(i1) <= tenv.genLoop )
        tDAL.Drow = tenv.useFrame(i1);
        if (status.crossVal > 1 )
          if tstatus.parfor_ == 1
            [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac{i0}(i1,:), EbasisWeight, Ebias ] =...
                crossVal_parfor(tenv,tgraph,tstatus,tDAL,bases,tmpI,i1);
          else %++imcomplete
            error('not yet') 
            [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac{i0}(i1,:), EbasisWeight, Ebias ] =...
                crossVal(tenv,tgraph,tstatus,tDAL,bases,tmpI,i1);%++bug
          end
          if ( tgraph.PLOT_T == 1 ) && ( i1 == env.useFrameLen )
            plot_CVLwhole(tenv,tstatus,tgraph,tDAL,CVL{i0});
          end

        else % don't do crossValidation
          [EbasisWeight,Ebias,Estatus,tstatus] = estimateWeightKernel(tenv,tstatus,bases,tmpI,tDAL,i1);
          %++bug Ebias isn't correct?

          [EResFunc tgraph] = reconstruct_EResFunc(tenv,tgraph,tDAL,bases,EbasisWeight);
          saveResponseFunc(tenv,tgraph,tstatus,bases,...
                           EbasisWeight,EResFunc,Ebias,tDAL,...
                           regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'));
          if tgraph.PLOT_T == 1
            fprintf(1,'\n\n Now plotting estimated kernel\n');
            for i2 = 1:DAL.regFacLen
              plot_EResFunc(tenv,tgraph,tstatus,tDAL,bases,EbasisWeight,...
                            sprintf('elapsed:%s',num2str(tstatus.time.regFac{i0}(i1,i2))),i2 )
            end
          end
          %% ==</Start estimation with DAL>==
          %% reconstruct lambda
          if strcmp('reconstruct','reconstruct_')
            error('not yet implemented')
            estimateFiringIntensity(tmpI,Ebias,EbasisWeight);
          end
        end
      else
        warning('DEBUG:NOTICE','( env.useFrame < bases.ihbasprs.numFrame) or (env.genLoop < env.useFrame)')
      end
    end
  end
  %%</ loop:env.useFrameLen >

  %  if (tstatus.parfor_ == 1 ) && (status.crossVal > 1 )
  if (status.crossVal > 1 )
    %    parfor i0 = 1:env.useNeuroLen
    for i0 = 1:env.useNeuroLen
      fprintf('%s\n',repmat('=',[30 1]));
      fprintf(1,'#neuron:%5d<-%5d, select best regFac\n', ...
              tenv.inFiringUSE(i0),env.cnum);
      tmpI = I(:,1:env.inFiringUSE(i0));
      tenv.cnum = env.inFiringUSE(i0);

      [CVLs{i0}] = get_CVLsummary(CVL{i0},env.useFrameLen,tenv.inFiringUSE(i0));
      %% ==< extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
      tstatus.validUseFrameIdx = sum(~isnan(CVLs{i0}.minTotal));
      tDAL = cell(1,tstatus.validUseFrameIdx );
      %%++parallel+bug(global variable: tgraph, tstatus)
      parfor i2 = 1:tstatus.validUseFrameIdx  
        tDAL{i2} = DAL;
        tDAL{i2}.Drow = tenv.useFrame(i2);
        %% choose the best regularization factor
        if 1 == 1
          tDAL{i2}.regFac = DAL.regFac(CVLs{i0}.idxTotal(i2)); 
        else % save all reconstructed response function.
          %% for DEBUG
          tDAL{i2}.regFac = DAL.regFac;
        end
        if 1 == 1
          [EbasisWeight,Ebias,Estatus] = ...
              estimateWeightKernel(tenv,...
                                   tstatus,bases,tmpI,tDAL{i2},i2);
          [EResFunc,tmpGraph] = reconstruct_EResFunc(tenv,tgraph,tDAL{i2},bases,EbasisWeight);
          saveResponseFunc(tenv,tgraph,tstatus,bases,...
                           EbasisWeight,EResFunc,Ebias,tDAL{i2},...
                           regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2')...
                           );
        else 
          %++improve:speedUp:: loading saved vriables such as EbasisWeight.
          % from the results of cross validation(warning:incomplete ResFunc).
          S = load([tstatus.savedirname,'/',tstatus.method,'-',...
                    sprintf('%7d',tDAL{i2}.regFac),...
                    '-',regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'),...
                    sprintf('-%07d',frame),...
                    sprintf('-%03d',cnum),...
                    '.mat'],'EbasisWeight','graph','env');
          EbasisWeight = S.EbasisWeight; % name rename transit EbasisWeight->EbasisWeight
          tmpGraph = S.graph;
          tmpEnv = S.env;
        end
        if tgraph.PLOT_T == 1
% $$$           try
% $$$             fprintf(1,'estimated rename func:'); %??
% $$$             plot_EResFunc_parfor(tenv,tmpGraph,tstatus,tDAL{i2},bases,EbasisWeight,...
% $$$                                  sprintf('elapsed:%s', ...
% $$$                                          num2str(tstatus.time.regFac{i0}(i2,CVLs{i0}.idxTotal(i2)))),...
% $$$                                  CVLs{i0}.idxTotal(i2) )
% $$$           catch indexError %++bug
% $$$             disp(sprintf('CVLs.idxTotal: %d',CVLs{i0}.idxTotal(i2) ))
% $$$           end
          S = load_ResFunc(tstatus,tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum,'graph','env','EResFunc');
          plot_ResFunc(S.graph,S.env,S.status,S.ResFunc,sprintf('#%s',tenv.cnum));
        end
      end
      %% ==</extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
    end
  end
% $$$   end
% $$$   %%</ loop:env.useFrameLen >
  %  env = tmpEnv;
  status.time.regFac = tstatus.time.regFac; %% status.time.regFac{i0} is modified.
  if status.parfor_ == 1
    matlabpool close
  end
end
%% ==< eval >==
%{
for i1 = 1:DAL.regFacLen
  [EResFunc_hash,EResFunc_fig,threshold,Econ] = judge_ResFunc_ternary(env,EResFunc,ResFunc_hash,i1,status);
end
%}
if (graph.PLOT_T == 1)
  %{
  plot_CausalMatrix(EResFunc_fig,'Estimated,group LASSO');
  plot_CausalMatrix(ResFunc_fig,'True connection')
  %}
end
%% ==</eval >==

status.time.end = fix(clock);

%% ==< bulk save all plotted graph  >==
if (graph.SAVE_ALL == 1)
  tmp.figHandles = get(0,'Children');
  tmp.fnames = {'garbage'}; %++bug:not yet implemented.
  if length(tmp.figHandles) == length(tmp.fnames)
    for i1 = 1:length(tmp.fnames)
      %      print(i1,'-depsc',sprintf('%s/%s',status.savedirname,tmp.fnames{i1}));
      print(i1,'-dpng',sprintf('%s/%s',status.savedirname,tmp.fnames{i1}));
    end
  else
    for i1 = 1:length(tmp.figHandles)
      %      print(tmp.figHandles(i1),'-depsc',sprintf('%s/%02d',status.savedirname,i1) );
      print(tmp.figHandles(i1),'-dpng',sprintf('%s/%02d',status.savedirname,i1) );
    end
  end
end 

%% ==< clean >==
%% clean variables before save
if status.clean == 1
  run  clean
end

%% ==< save >==
if status.save_vars == 1
  fprintf(1,'Saving variables....\n');
  if status.use.GUI == 1
    my_uisave(status.savedirname,status.time);
  else 
    status.outputfilename = setSavedDataName(status.savedirname,status.time);
    save(status.outputfilename);
    fprintf(1,'outputfilename:\n %s\n',status.outputfilename)
  end
end

status.profile=profile('info');


if status.estimateConnection == 1
  mailMe(env,status,DAL,bases,'Finished myest.m')
end

diary off;

%{
%fin();
t=readTrueConnection(env,status,status.inStructFile);
et=reshape(EResFunc_hash,[],env.cnum);
calcCorrectNum(t,et)
[EResFunc_hash,threshold,Econ] = judge_ResFunc_ternary(env,EResFunc,ResFunc_hash,4);
%}
