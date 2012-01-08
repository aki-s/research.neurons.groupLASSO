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
      if (status.crossVal > 1 )
        if tstatus.parfor_ == 1
          %            [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac{i0}(i1,:), EbasisWeight, Ebias ] =...
          [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac(i1,:), EbasisWeight, Ebias ] =...
              crossVal_parfor(tenv,tgraph,tstatus,tDAL,bases,tmpI,i1);
        else %++imcomplete
          error('not yet') %++bug:obsolete?
          %            [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac{i0}(i1,:), EbasisWeight, Ebias ] =...
          [ CVL{i0}(1:tDAL.regFacLen,1:tenv.cnum,i1),tstatus.time.regFac(i1,:), EbasisWeight, Ebias ] =...
              crossVal(tenv,tgraph,tstatus,tDAL,bases,tmpI,i1);%++bug
        end
        if ( tgraph.PLOT_T == 1 ) && ( i1 == env.useFrameLen )
          plot_CVLwhole(tenv,tstatus,tgraph,tDAL,CVL{i0});
        end

      else % don't do model selection (decide regFac with crossValidation)
        [EbasisWeight,Ebias,Estatus,tstatus] = estimateBasisWeight(tenv,tstatus,bases,tmpI,tDAL,i1);
        [EResFunc tgraph] = reconstruct_EResFunc(tenv,tgraph,tDAL,bases,EbasisWeight);
        saveResponseFunc(tenv,tgraph,tstatus,bases,...
                         EbasisWeight,EResFunc,Ebias,tDAL,...
                         regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2'));
        if tgraph.PLOT_T == 1
          fprintf(1,'\n\n Now plotting estimated kernel\n');
          for i2 = 1:DAL.regFacLen
            %%plot_EResFunc();%<-obsolete, %++improve:remove'_parfor'
            plot_EResFunc_parfor(tenv,tgraph,tstatus,tDAL,bases,EbasisWeight,...
                                 sprintf('elapsed:%s',num2str(tstatus.time.regFac(i1,i2))),i2 )
          end
        end
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
%%------------------------------------------------------------------------------------
if (status.crossVal > 1 )
  %%    parfor i0 = 1:env.useNeuroLen %++future
  for i0 = 1:env.useNeuroLen 
    echo_stdoutDivider(1)
    fprintf(1,'#neuron:%5d<-%5d, estimate with best regFac\n', ...
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
      tDAL{i2}.regFac = DAL.regFac(CVLs{i0}.idxTotal(i2)); 

      %      if strcmp('careful','careful')
      if status.crossVal_rough ~= 0
        %% re-estimate using sequent frames, but the 1st-cluster
        %% in cross fold validation is omitted.
        %++improve:speedUp:: loading saved vriables such as EbasisWeight.
        % from the results of cross validation(warning:incomplete ResFunc).
        %        tmpLdir = 'CV';
      elseif strcmp('delicate','delicate')
% $$$         fprintf(1,['Estimate EResfunc with the best regFac using all ' ...
% $$$                    'usable frames.\n']);
        fprintf(1,'Model selection\n')
        %% re-estimate using all sequent frames.
        [EbasisWeight,Ebias,Estatus] = ...
            estimateBasisWeight(tenv,...
                                 tstatus,bases,tmpI,tDAL{i2},i2);
        [EResFunc,tmpGraph] = reconstruct_EResFunc(tenv,tgraph,tDAL{i2},bases,EbasisWeight);
        saveResponseFunc(tenv,tgraph,tstatus,bases,...
                         EbasisWeight,EResFunc,Ebias,tDAL{i2},...
                         regexprep(tstatus.inFiring,'(.*/)(.*)(.mat)','$2')...
                         );
        %        tmpLdir = '';%++improve. make flag if you use 'careful' or 'rough'.
      end
      if tgraph.PLOT_T == 1
        %        S = load_ResFunc(tstatus,tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum,tmpLdir,'graph','env','status','EResFunc');
        S = load_ResFunc(tstatus,tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum,tDAL{i2}.tmpLdir,'graph','env','status','EResFunc');
        plot_ResFunc(S.graph,S.env,S.EResFunc,sprintf('#%5d',tenv.cnum),S.status.savedirname,sprintf('-opt_regFac%09.4f-frame%07d-n%05d',tDAL{i2}.regFac,tDAL{i2}.Drow,tenv.cnum));
      end
    end
    %% ==</extract and plot the best response func for each usedFrameNum from the results of crossValidation>==
  end
end
%%------------------------------------------------------------------------------------
status.time.regFac = tstatus.time.regFac; %% status.time.regFac{i0} is modified.

if 1 == 0%++debug
  if  ( matlabpool('size') > 0 ) % && <no thred running>
    matlabpool close
  end
end
%% =====< SELECT appropriate threshold for evalation function >===
%% SELECT appropriate threshold for evalation function
%%  and completely judge if there's connection or not.  %++future


%% =====</SELECT appropriate threshold for evalation function >===
