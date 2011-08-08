function  [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL,kstatus] = compare_KIM(kbases,data_of_firing)

STATUS_ = 'test_run';

%% Prerequisite: 
%% 1) load *.mat generated by 'myest.m' or run 'myest.m'
%% 2) run compare_KIM.m
% [kEKerWeight,kEbias,kEstatus,kEalpha,kDAL,kstatus] = compare_KIM(kbases,'data_of_firing')
%%

global kenv;
global kgraph;
global rootdir_

kstatus = conf_progress(kstatus);
kstatus.mail = 1;
kstatus.use.GUI = 0;
% $$$ if strcmp('tweek_to_yours','tweek_to_yours')
% $$$   kenv.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
% $$$   kenv.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
% $$$ end
kstatus.GEN_TrureValues = NaN;
kstatus.GEN_Neuron_individuality = NaN;
kstatus.time.start = fix(clock);
if ~exist('rootdir_')
  rootdir_ = pwd;
end


kDAL = conf_DAL();

tic
%%% ==< Kim >==
kDAL.speedup =0;
opt = kDAL.opt;
nbase = kbases.ihbasprs.nbase;


%load([rootdir_ '/indir/Simulation/data_sim_9neuron.mat']) % load 'X'
load([data_of_firing ]); % load 'X'
%%load([rootdir_ '/indir/Simulation/data_sim_hidden.mat'])
if ( data_of_firing == [rootdir_ '/indir/Simulation/' ...
                      'data_sim_9neuron.mat'] )

end

%%load([rootdir_ '/indir/Real_data/data_real_catM1.mat;'])
% Dimension of X (# Channels x # Samples x # Trials)
% [CHN SMP TRL] = size(X);
%%load([rootdir_ '/indir/Real_data/data_real_nonmove.mat'])

[L,kenv.cnum] = size(X);
DIV = 10;
kDrow = floor(L/DIV);
kenv.genLoop = L;
kenv.Hz.video = 100;

kenv
kstatus
%% ============================================================
plot_I(kstatus,kgraph,kenv,X,' Firing from KIM''s neuron')

fprintf('\tGenerating Matrix for DAL\n');
[kD kpenalty] = gen_designMat(kenv,kbases,X,kDrow);

% $$$ kpEKerWeight{1} = zeros(nbase,kenv.cnum);
% $$$ kpEbias{1} = 0;

if strcmp('dalprgl','dalprgl')
  pI= X((end - kDrow +1): end,:);
end
%% ==< init variables >==
kDAL.Drow = kDrow;

tmp.kmethod = 3;
kDAL.speedup =0;
kDAL.loop = 3;
kDAL.regFac = zeros(1,kDAL.loop); % kDAL.regFac: regularization factor.
if strcmp('setRegFac_auto','setRegFac_auto')
  if 1 ==1
    kDAL.regFac(1) = sqrt(nbase)*10; % kDAL.regFac: group LASSO parameter.
  else
    kDAL.regFac(1) = sqrt(nbase); % kDAL.regFac:
  end                                %  kDAL.regFac(1) = uint32(sqrt(kDAL.Drow)); % kDAL.regFac:
else
  kDAL.regFac(1) = 1; % kDAL.regFac: group LASSO parameter.
end
kDAL.div = 2;
%% ==</init variables >==

kDAL
%% ==================================================================
matlabpool(8);
for ii1 = 1:kDAL.loop % search appropriate parameter.
  fprintf(1,'\n\n == Regularization factor: %f == \n',kDAL.regFac(ii1));
  for i1to = 1:kenv.cnum % ++parallelization 
    switch  tmp.kmethod
      case 1
        %% logistic regression group lasso
        [kEKerWeight{i1to}, kEbias{i1to}, kEstatus{i1to}] = ...
            dallrgl( zeros(nbase,kenv.kenv.cnum), 0,...
                     kD, kpenalty(:,i1to), kDAL.regFac(ii1to),...
                     opt);
      case 2
        %% poisson regression group lasso: blk
        %% Returned pEKerWeight must be [10x9], not be [90x1] %++bug
        if kDAL.speedup == 1
          [kpEKerWeight{i1to}, kpEbias{i1to}, kpEstatus{i1to}] = ...
              dalprgl( kpEKerWeight{i1to}, kpEbias{i1to}, ...
                       kD, pI(:,i1to), kDAL.regFac(ii1),...
                       'blks',repmat(nbase,[1 kenv.cnum]));
        else
          [kpEKerWeight{i1to}, kpEbias{i1to}, kpEstatus{i1to}] = ...
              dalprgl( zeros(nbase*kenv.cnum,1), 0,...
                       kD, pI(:,i1to), kDAL.regFac(ii1),...
                       'blks',repmat(nbase,[1 kenv.cnum]));
        end

      case 3
        if kDAL.speedup == 1 
          [kpEKerWeight{i1to}, kpEbias{i1to}(ii1), kpEstatus{i1to}] = ...
              dalprgl( kpEKerWeight{i1to}, kpEbias{i1to}(ii1-1), ...
                       kD, pI(:,i1to), kDAL.regFac(ii1)...
                       ,opt);
        else
          [kpEKerWeight{i1to}, kpEbias{i1to}(ii1), kpEstatus{i1to}] = ...
              dalprgl( zeros(nbase,kenv.cnum), 0,...
                       kD, pI(:,i1to), kDAL.regFac(ii1)...
                       ,opt);
        end
    end
  end

  kDAL.speedup = 1;
  if ii1 < kDAL.loop
    %        kDAL.regFac(ii1+1) = kDAL.regFac(ii1)/5;
    kDAL.regFac(ii1+1) = kDAL.regFac(ii1)/kDAL.div;
  end

  switch tmp.kmethod
    case 1
      for i1to = 1:kenv.cnum
        for i2from = 1:kenv.cnum
          kEalpha{ii1}{i1to}{i2from} = (kbases.ihbasis* kEKerWeight{i1to}(:,i2from));
        end
      end
      
    case 3
      for i1to = 1:kenv.cnum
        for i2from = 1:kenv.cnum
          kEalpha{ii1}{i1to}{i2from} = (kbases.ihbasis* kpEKerWeight{i1to}(:,i2from));
        end
      end
      
    otherwise
  end

% $$$   if graph.PLOT_T == 1
% $$$     plot_Ealpha(kenv,graph,Ealpha{ii1},...
% $$$                 strcat(['Kim:dalprgl:kDAL regFac'],num2str(kDAL.regFac(ii1))));
% $$$   end
end
matlabpool close

kEKerWeight = kpEKerWeight;
kEbias = kpEbias;
kEstatus = kpEstatus;

%%% ==</Kim >==
kstatus.time.estimate_TrueKernel = toc;
fprintf(1,'%s',kstatus.time.estimate_TrueKernel);

fprintf(1,'\n\n Now plotting estimated kernel\n');

if strcmp('plot_True','plot_True')
  [kalpha_fig,kalpha_hash] = readTrueConnection([rootdir_ '/indir/KimFig1.con']); 
  plot_alpha_ternary(kgraph,kenv,kalpha_hash);
end
if kgraph.PLOT_T == 1
  for i1 = 1:length(kDAL.regFac)
    plot_Ealpha(kenv,kgraph,kEalpha{i1},...
                strcat('dallrgl:DAL regFac=  ', num2str(kDAL.regFac(i1))));
  end
end

kstatus.time.end = fix(clock);

if strcmp('mailMe','mailMe')
  mailMe(kenv,kstatus,kDAL,'Finished compare_KIM.m')
end

tmp0 = kstatus.time.start;
if kstatus.use.GUI == 1
  uisave(who,strcat(rootdir_ , 'outdir/Kim/'));
else
  save( [ rootdir_ '/outdir/Kim',date,num2str(tmp0(4)), ...
          num2str(tmp0(5)),'-',regexprep(data_of_firing,'(.*/)(.*)','$2')]);
end


% $$$ 
% $$$ %% judge connection from variance<->mean,median (enumerate)
% $$$ if strcmp('test_run',STATUS_)
% $$$   %[kEalpha_hash] = judge_alpha_ternary(kenv,kEalpha,kEbias,2,alpha_hash)
% $$$ else
% $$$ [kEalpha_hash] = judge_alpha_ternary(kenv,kEalpha);
% $$$ end
% $$$ plot_alpha_ternary(kgraph,kenv,kEalpha_hash);
% $$$ 
% $$$ kEalpha_fig = reshape(kEalpha_hash,[],[9]);
