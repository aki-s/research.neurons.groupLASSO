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
%% ==< configure >==
%% read user custom configuration.
%% This overrides all configurations below.

if strcmp('configure', 'configure') %++conf
  conf_progress();
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.
  [env status ] = conf_IO(env,status);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);
  bases = conf_makeSimStruct_glm(); % load parameters.
  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

if strcmp('gaya','gaya_')
  status.userDef = [rootdir_ '/conf/conf_user_gaya.m'];
elseif strcmp('kim','kim_')
  status.userDef = [rootdir_ '/conf/conf_user_kim.m'];
elseif strcmp('aki','aki')
  status.userDef = [rootdir_ '/conf/conf_user_aki.m'];
else
  %% set null file till user defines.
  status.userDef = [rootdir_ '/conf/conf_user.m'];
end
run(status.userDef);

if  (status.READ_FIRING == 1)
  [env I Tout] = readI(env,status,Tout);
end

gen_defaultEnv_ask(); % set default params

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%<

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>
if (status.realData ~= 1 )
  if (status.READ_NEURO_CONNECTION == 1) % from I/O % (status.READ_FIRING ~= 1)
    %% e.g. Enter 'indir/KimFig1.con' when asked.
    [alpha_fig,alpha_hash,env,status] = readTrueConnection(env,status);
    Tout = get_neuronType(env,status,alpha_fig,Tout);
  elseif (status.GEN_TrueValues == 1)  % generate artifical random network connection
    [alpha_fig,alpha_hash,status] = gen_alpha_hash(env,status);
    Tout = get_neuronType(env,status,alpha_fig,Tout);
  end
else
  status.inStructFile = '';
end

%% ==</ configure >==
%%++improve
%% bases should be loaded from a mat file.
%% large argment of makeSimStruct_glm() make small width of basis.
if 1==1 
bases = makeSimStruct_glm(bases,1/env.Hz.video); % Create GLM structure with default params
else
bases = makeSimStruct_glm(0.2); % Create GLM structure with default params
end
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
  if isfield(env,'inFiringUSE')
    useNeuroLenIdx = length(env.inFiringUSE);
  else
    useNeuroLenIdx = 1;
    env.inFiringUSE(1) = size(I,2);
  end
  useFrameLen = length(env.useFrame);
  if status.parfor_ == 1 && ( matlabpool('size') == 0 )
    matlabpool(8);
  end
  %% matlabpool close force local
  DAL = setDALregFac(env,DAL,bases);
  regFacLen = length(DAL.regFac);% DAL.prm.regFacLen =
  %% CVL: cross Validation error
  CVL = cell(1,useNeuroLenIdx);
  status.time.regFac = zeros(useFrameLen,regFacLen);
  CVwhole = cell(1,useNeuroLenIdx);
  RfWholeIdx = cell(1,useNeuroLenIdx);
  CVeach     = cell(1,useNeuroLenIdx);
  RfEachIdx  = cell(1,useNeuroLenIdx);
  %{
  %% not yet
  EbasisWeight = cell(1,useNeuroLenIdx);
  Ebias = cell(1,useNeuroLenIdx);
  Ealpha =  cell(1,useNeuroLenIdx);
  %}
  tmpI = I;
%%< prepare for 'parfor' >
tenv = env; %% make 'env' global to local variable 'tenv'
tgraph = graph; %% make 'graph' global to local variable 'tgraph'
tstatus = status;%% make 'status' global to local variable 'tstatus'
%%</prepare for 'parfor' >
  for i0 = 1:useNeuroLenIdx
    fprintf(1,'#neuron:%5d<-%5d\n',tenv.inFiringUSE(i0),env.cnum);
    I = tmpI(:,1:env.inFiringUSE(i0));
    tenv.cnum = size(I,2);
      CVL{i0}        = nan(regFacLen,tenv.cnum,useFrameLen);
      CVwhole{i0}    = nan(useFrameLen,1);
      RfWholeIdx{i0} = nan(useFrameLen,1); %Rf: regularization factor
      CVeach{i0}     = nan(useFrameLen,tenv.cnum);
      RfEachIdx{i0}  = nan(useFrameLen,tenv.cnum);
    %%< loop:useFrameLen >
    for i1 =1:useFrameLen
      fprintf('%s',repmat('=',[30 1]));
      fprintf(' useFrame:%08d ',tenv.useFrame(i1));
      fprintf('%s',repmat('=',[30 1]));
      fprintf('\n');

      %% ( %++parallel? not practical for biological real data.)
      if ( bases.ihbasprs.numFrame <= tenv.useFrame(i1) ) && ( tenv.useFrame(i1) <= tenv.genLoop )
        DAL.Drow = tenv.useFrame(i1);
        if (status.crossVal > 1 )
          %% ==< choose appropriate regFac >==
          if tstatus.parfor_ == 1
            %++bug? calc CVL
            [ CVL{i0}(1:regFacLen,1:tenv.cnum,i1),tstatus.time.regFac(i1,:), EbasisWeight, Ebias ] =...
                crossVal_parfor(tenv,tgraph,tstatus,DAL,bases,I,i1);
          else %++imcomplete
            error('not yet')
            [ CVL{i0}(1:regFacLen,1:tenv.cnum,i1),tstatus.time.regFac(i1,:), EbasisWeight, Ebias ] =...
                crossVal(tenv,tgraph,tstatus,DAL,bases,I,i1);%++bug
          end
          %% ==</choose appropriate regFac >==
          [CVwhole{i0}(i1),RfWholeIdx{i0}(i1)]    = min(sum(CVL{i0}(:,:,i1),2),[],1);
          %% corresponding regularization factor: DAL.regFac(RfWholeIdx{i0})
          [CVeach{i0}(i1,1:tenv.cnum),RfEachIdx{i0}(i1,1:tenv.cnum)] = min(CVL{i0}(:,:,i1),[],1); % each neuron
          if ( tgraph.PLOT_T == 1 ) && ( i1 == useFrameLen )
            plot_CVLwhole(tenv,tstatus,tgraph,DAL,CVL{i0});
          end

        else %
          [EbasisWeight,Ebias,Estatus,DAL,tstatus] = estimateWeightKernel(tenv,tgraph,tstatus,bases,I,DAL,i1);
          %++bug Ebias isn't correct.

          [Ealpha tgraph] = reconstruct_Ealpha(tenv,tgraph,DAL,bases,EbasisWeight);
          saveResponseFunc(tenv,tgraph,tstatus,bases,...
                           EbasisWeight,Ealpha,Ebias,DAL,...
                           regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'));
          if tgraph.PLOT_T == 1
            fprintf(1,'\n\n Now plotting estimated kernel\n');
            for i2 = 1:regFacLen
              plot_Ealpha(tenv,tgraph,tstatus,DAL,bases,EbasisWeight,...
                          sprintf('elapsed:%s',num2str(tstatus.time.regFac(i1,i2))),i2 )
            end
          end
          %% reconstruct lambda
          if strcmp('reconstruct','reconstruct_')
            error('not yet implemented')
            estimateFiringIntensity(I,Ebias,EbasisWeight);
          end
        end
        %% ==</Start estimation with DAL>==
      else
        warning('DEBUG:NOTICE','( env.useFrame < bases.ihbasprs.numFrame) or (env.genLoop < env.useFrame)')
      end
    end
    %    if (tstatus.parfor_ == 1 ) && strcmp('crossValidation','crossValidation')
    if (tstatus.parfor_ == 1 ) && (status.crossVal > 1 )
     %% ==< extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
      tstatus.validUseFrameIdx = sum(~isnan(CVwhole{i0}));
      tmpDAL = cell(1,tstatus.validUseFrameIdx );
      %%++parallel+bug(global variable: tgraph, tstatus)
      parfor i2 = 1:tstatus.validUseFrameIdx  
        tmpDAL{i2} = DAL;
        tmpDAL{i2}.Drow = tenv.useFrame(i2);
        %% choose the best regularization factor
        if 1 == 0
          tmpDAL{i2}.regFac = DAL.regFac(RfWholeIdx{i0}(i2)); 
        else % save all reconstructed response function.
          tmpDAL{i2}.regFac = DAL.regFac;
        end
        if 1 == 1
          [EbasisWeight,Ebias,Estatus,tmpDAL{i2}] = ...
              estimateWeightKernel(tenv,tgraph,...
                                   tstatus,bases,I,tmpDAL{i2},i2);
          [Ealpha,tmpGraph] = reconstruct_Ealpha(tenv,tgraph,tmpDAL{i2},bases,EbasisWeight);
          saveResponseFunc(tenv,tgraph,tstatus,bases,...
                           EbasisWeight,Ealpha,Ebias,tmpDAL{i2},...
                           regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2')...
                           );
        else 
          %++improve:speedUp:: loading saved vriables such as EbasisWeight.
          % from the results of cross validation.
          S = load([tstatus.savedirname,'/',tstatus.method,'-',...
                    sprintf('%7d',tmpDAL{i2}.regFac),...
                    '-',regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'),...
                    sprintf('-%07d',frame),...
                    sprintf('-%03d',cnum),...
                    '.mat'],'EbasisWeight','graph','env');
          EbasisWeight = S.EbasisWeight; % name rename transit EbasisWeight->EbasisWeight
          tmpGraph = S.graph;
          tmpEnv = S.env;
        end
        if tgraph.PLOT_T == 1
          try
            fprintf(1,'estimated rename func:'); %??
            plot_Ealpha_parfor(tenv,tmpGraph,tstatus,tmpDAL{i2},bases,EbasisWeight,...
                               sprintf('elapsed:%s', ...
                                       num2str(tstatus.time.regFac(i2,RfWholeIdx{i0}(i2)))),...
                               RfWholeIdx{i0}(i2) )%++bug? why '1'
          catch indexError %++bug
            disp(sprintf('RfWholeIdx: %d',RfWholeIdx{i0}(i2) ))
          end
        end
      end
      %% ==</extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
    end
  end
  %%</ loop:useFrameLen >
  I = tmpI;
  %  env = tmpEnv;
  status = tstatus; %% status.time.regFac is modified.
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


%% ==< clean >==
%% clean variables before save
if status.clean == 1
  run([rootdir_ '/mylib/clean.m'])
end

%% ==< save >==
if status.save_vars == 1
  fprintf(1,'Saving variables....\n');
  if status.use.GUI == 1
    uisave(who,strcat(status.savedirname,'/', 'frame', num2str(sprintf('%05d',env.genLoop)), 'hwind', num2str(sprintf('%04d',env.hwind)), 'hnum' , num2str(sprintf('%02d',env.hnum))));
  else 
    tmp.v = datevec(date);
    status.outputfilename = [status.savedirname,'/',num2str(tmp.v(3)),'_',num2str(tmp.v(2)),'_',num2str(tmp.v(1)),'__',num2str(status.time.start(4)),'_',num2str(status.time.start(5)),'.mat'];
    save(status.outputfilename);
  end
  fprintf(1,'outputfilename:\n %s\n',status.outputfilename)
end

status.profile=profile('info');


if status.estimateConnection == 1
  mailMe(env,status,DAL,bases,'Finished myest.m')
end

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
%{
%% ==< clean >==
if status.clean == 1
  run([rootdir_ '/mylib/clean.m'])
end
%}
%{
%fin();
t=readTrueConnection(env,status,status.inStructFile);
et=reshape(Ealpha_hash,[],env.cnum);
calcCorrectNum(t,et)
[Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,alpha_hash,4);
%}
