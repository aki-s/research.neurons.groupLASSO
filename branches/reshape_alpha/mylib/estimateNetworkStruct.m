set_matlabpool(status.parfor_,status.crossVal);

%% CVL: cross Validation Log Likelihood ++rename:CVL->CVLL
[CVL CVLs] = init_CVL(env.useNeuroLen,env.inFiringUSE,env.useFrameLen,DAL.regFacLen);
%{
%% if status.crossVal_rough == 0
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
%%    parfor i0 = 1:env.useNeuroLen %++future

for i0 = 1:env.useNeuroLen
  echo_stdoutDivider(1)
  fprintf(1,'#neuron:%5d<-%5d\n',tenv.inFiringUSE(i0),env.cnum);
  tmpI = I(:,1:env.inFiringUSE(i0));
  tenv.cnum = env.inFiringUSE(i0);

  %%< loop:env.useFrameLen >
  for i1 =1:env.useFrameLen
    echo_usingFrame(tenv.useFrame(i1));
    %% ( %++parallel? not practical for biological real data.)
    if ( bases.ihbasprs.numFrame <= tenv.useFrame(i1) ) && ( tenv.useFrame(i1) <= tenv.genLoop )
      tDAL.Drow = tenv.useFrame(i1);
try %++bug:segfault
      if (status.crossVal > 1 )
        [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac(i1,:), EbasisWeight, Ebias ] =...
            crossVal(tenv,tgraph,tstatus,tDAL,bases,tmpI,i1);
        if ( tgraph.PLOT_T == 1 ) && ( i1 == env.useFrameLen )
          plot_CVLwhole(tenv,tstatus,tgraph,tDAL,CVL{i0});
        end

      else % don't do model selection (decide regFac with crossValidation)
        [EbasisWeight,Ebias,Estatus,tstatus] = estimateBasisWeight(tenv,tstatus,bases,tmpI,tDAL,i1);
        [EResFunc tgraph] = reconstruct_EResFunc(tenv.cnum,tgraph,tDAL,bases,EbasisWeight);
        saveResponseFunc(tenv,tgraph,tstatus,bases,...
                         EbasisWeight,EResFunc,Ebias,tDAL,...
                         regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'));
        if tgraph.PLOT_T == 1
          fprintf(1,'\n\n Now plotting estimated kernel\n');
          for i2 = 1:DAL.regFacLen
            plot_EResFunc(tenv,tgraph,tstatus,tDAL,bases,EbasisWeight,...
                          sprintf('elapsed:%s',num2str(tstatus.time.regFac(i1,i2))),i2 )
          end
        end
        %% reconstruct lambda
        if strcmp('reconstruct','reconstruct_')
          error('not yet implemented')
          estimateFiringIntensity(tmpI,Ebias,EbasisWeight);
        end
      end
catch segfault_DAL__  %++bug:segfault
  segfault_DAL__
fprintf('Too small DAL.regFac?\n');
end %++bug:segfault
    else
      warning('DEBUG:NOTICE','( env.useFrame < bases.ihbasprs.numFrame) or (env.genLoop < env.useFrame)')
    end
  end
end
%%</ loop:env.useFrameLen >
%%------------------------------------------------------------------------------------
if (status.crossVal > 1 )
  %%    parfor i0 = 1:env.useNeuroLen %++future
  tstatus = cell(1,env.useNeuroLen);
  for i0 = 1:(env.useNeuroLen)
    tstatus{i0} = status;
    echo_stdoutDivider(1,'\n')
    fprintf('MODEL_SELECTION:#%5d',env.inFiringUSE(i0))
    echo_stdoutDivider(1)

    fprintf(1,'#neuron:%5d<-%5d, estimate with best regFac\n', ...
            tenv.inFiringUSE(i0),env.cnum);
    tmpI = I(:,1:env.inFiringUSE(i0));
    %%++bug: if size(env.inFiringUSE) > 1 ?
% $$$     tmpI = I(:,status.usedNeuronIdx>0);
    tenv.cnum = env.inFiringUSE(i0);

    [CVLs{i0}] = get_CVLsummary(CVL{i0},env.useFrameLen,tenv.inFiringUSE(i0));
    %% ==< extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
    %    tstatus.validUseFrameIdx = sum(~isnan(CVLs{i0}.minTotal));
    tstatus{i0}.validUseFrameIdx = sum(~isnan(CVLs{i0}.minTotal));
    tDAL = cell(1,tstatus{i0}.validUseFrameIdx );
    %%++parallel+bug(global variable: tgraph, tstatus{i0})
    %    parfor i2 = 1:(tstatus{i0}.validUseFrameIdx)
    for i2 = 1:(tstatus{i0}.validUseFrameIdx) %debug: check segfault
      tDAL{i2} = DAL;
      tDAL{i2}.Drow = tenv.useFrame(i2);
      %% choose the best regularization factor
      tDAL{i2}.regFac = DAL.regFac(CVLs{i0}.idxTotal(i2)); 
      tDAL{i2}.regFac = 1;
      if status.crossVal_rough ~= 0
        %% Skip re-calclation to save time by using the prevous result from leave
        %% one-cluster out cross validation.
      else %  strcmp('delicate','delicate')
        %% re-estimate using all sequential frames.
        fprintf(1,'Model selection\n')
        [EbasisWeight,Ebias,Estatus] = ...
            estimateBasisWeight(tenv,...
                                tstatus{i0},bases,tmpI,tDAL{i2},i2);
EbasisWeight
whos EbasisWeight
        [EResFunc,tmpGraph] = reconstruct_EResFunc(tenv.cnum,tgraph,tDAL{i2},bases,EbasisWeight);
        fprintf('debug: check segfault 1.\n')
        saveResponseFunc(tenv,tgraph,tstatus{i0},bases,...
                         EbasisWeight,EResFunc,Ebias,tDAL{i2},...
                         regexprep(tstatus{i0}.inFiring,'(.*/)(.*)(.mat)','$2')...
                         );
        fprintf('debug: check segfault 2.\n')
      end
      try
        %% segfault is caused? by using 'i0' at outrange of parfor?
        if tgraph.PLOT_T == 1
          S = load_ResFunc(tstatus{i0},tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum,tDAL{i2}.tmpLdir,'graph','env','status','EResFunc');
          plot_ResFunc(S.graph,S.env,S.EResFunc,sprintf('#%5d',tenv.cnum),S.status.savedirname,sprintf('Estimated_ResponseFunc-opt_regFac%09.4f-frame%07d-n%05d',tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum));
        end
        fprintf('debug: Past crossval reconstruct_EResFunc 3.\n')
      catch segfault_selectRegFac__  %++bug:segfault
        segfault_selectRegFac__
        fprintf('debug: Past estimateNetworkSruct.m:parfor.error 5\n')
      end
    end
    fprintf('debug: Past estimateNetworkSruct.m:parfor 4\n')
    %% ==</extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
  end
end
%%------------------------------------------------------------------------------------
%++bug:
status.time.regFac = tstatus{env.useNeuroLen}.time.regFac; %% status.time.regFac{i0} is modified.
%%<debug>
% $$$ parfor i0 = 1:(tstatus.validUseFrameIdx)
% $$$   t_cnum = env.inFiringUSE(i0);
% $$$   tDAL{i0} = DAL;
% $$$   tDAL{i0}.Drow = tenv.useFrame(i0);
% $$$   %% choose the best regularization factor
% $$$   tDAL{i0}.regFac = DAL.regFac(CVLs{i0}.idxTotal(i0)); 
% $$$     %% segfault is caused? by using 'i0' at outrange of parfor?
% $$$     if tgraph.PLOT_T == 1
% $$$       S = load_ResFunc(tstatus,tDAL{i0}.regFac,tDAL{i0}.Drow,t_cnum,tDAL{i0}.tmpLdir,'graph','env','status','EResFunc');
% $$$       plot_ResFunc(S.graph,S.env,S.EResFunc,sprintf('#%5d',tenv.cnum),S.status.savedirname,sprintf('Estimated_ResponseFunc-opt_regFac%09.4f-frame%07d-n%05d',tDAL{i0}.regFac,tDAL{i0}.Drow,t_cnum));
% $$$     end
% $$$     fprintf('debug: Past crossval reconstruct_EResFunc 3.\n')
% $$$ end
%%</debug>
fprintf(['debug: Past estimateNetworkSruct.m for all env.useNeuroLen. ' ...
         '6\n'])

if 1 == 0 %++debug
  if  ( matlabpool('size') > 0 ) % && <no thred running>
    matlabpool close
  end
  fprintf('debug: M\n')
end
%% =====< SELECT appropriate threshold for evalation function >===
%% SELECT appropriate threshold for evalation function
%%  and completely judge if there's connection or not.  %++future


%% =====</SELECT appropriate threshold for evalation function >===
