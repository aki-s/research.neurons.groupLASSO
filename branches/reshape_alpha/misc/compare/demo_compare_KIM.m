%% HowTo)
%% close all; clear all; run conf/setpaths.m;  global rootdir_; rootdir_ = pwd; run misc/compare/demo_compare_KIM.m

global kenv;

global kstatus;
kstatus = conf_progress();
kstatus.mail = 1;
kstatus.use.GUI = 0;
kstatus.GEN_TrureValues = NaN;
kstatus.GEN_Neuron_individuality = NaN;
kstatus.time.start = fix(clock);

global kgraph;
kgraph = conf_graph();
global kbases;


if strcmp('tweak_to_yours','tweak_to_yours')
  kenv.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
  kenv.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
end
%% == ==
run( [rootdir_ '/misc/compare/conf_compare_KIM_user.m'] );

%% == == 
if ~isempty(kbases)
  warning('NOTICE:speedup','generating kbases was skipped to speed up.')
  %% Create GLM structure with default params
else
  kbases = makeSimStruct_glm(0.01);
end

kenv  % print env
data_of_firing = [rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];
%[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
[kEKerWeight,kEbias,kEstatus,kDAL] = ...
    compare_KIM(kbases, data_of_firing);
kEalpha = reconstruct_Ealpha(kenv,kDAL,kbases,kEKerWeight);

%{
[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Simulation/data_sim_hidden.mat']);

[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Real_data/data_real_catM1.mat']);

[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Real_data/data_real_nonmove.mat'])
%}


%[kEalpha_hash] = comp_alpha_ternary(kenv,kEalpha,kEbias,2,kalpha_hash);

[kalpha_fig,kalpha_hash] = readTrueConnection([rootdir_ '/indir/KimFig1.con']); 

[kEalpha_hash,threshold,Econ] = judge_alpha_ternary(kenv,kEalpha,kalpha_hash,2,kEbias);

plot_alpha_ternary(kgraph,kenv,kEalpha_hash,'Estimated,group LASSO');
plot_alpha_ternary(kgraph,kenv,kalpha_hash,'Kim: True connection');

kEalpha_fig = reshape(kEalpha_hash,[],9);


%% ==< post process >==
kstatus.time.end = fix(clock);

if kstatus.estimateConnection == 1
  mailMe(kenv,kstatus,kDAL,'Finished demo_compare_KIM.m')
end

tmp0 = kstatus.time.start;
mkdirname = [date,num2str(tmp0(4)),num2str(tmp0(5))];
mkdir( [ rootdir_ '/outdir/Kim'],mkdirname)
savedirname =  [ rootdir_ '/outdir/Kim/',mkdirname];
if kstatus.use.GUI == 1
  uisave(who,savedirname);
else
  save([savedirname,'/',date,num2str(tmp0(4)),num2str(tmp0(5)),'-ALL_VARS-',sprintf('%d',kDAL.Drow),'-',regexprep(data_of_firing,'(.*/)(.*)','$2')]);
end

kstatus.profile=profile('info');

%% ==< save all graph >==
if (kgraph.SAVE_ALL == 1)
  figHandles = get(0,'Children');
  fnames = {''}; %++bug:not yet implemented.
  if length(figHandles) == length(fnames)
    for i1 = 1:length(fnames)
      print(i1,[savedirname,fnames(i1)],'eps');
    end
  else
    for i1 = 1:length(figHandles)
      print(figHandles(i1),'-depsc',sprintf('%s/%02d',savedirname,i1) );
    end
  end
end 
