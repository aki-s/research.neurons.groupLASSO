%% clear all; global rootdir_; rootdir_ = pwd; run misc/compare/demo_compare_KIM.m

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
if isempty(kbases)
  %% Create GLM structure with default params
  kbases = makeSimStruct_glm(0.01);
  warning('NOTICE:speedup','generating kbases was skipped to speed up.')
end

kenv  % print env
[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Simulation/data_sim_9neuron.mat']);
[kalpha_fig,kalpha_hash] = readTrueConnection([rootdir_ '/indir/KimFig1.con']); 

%{
[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Simulation/data_sim_hidden.mat']);

[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Real_data/data_real_catM1.mat']);

[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Real_data/data_real_nonmove.mat'])
%}


%[kEalpha_hash] = comp_alpha_ternary(kenv,kEalpha,kEbias,2,kalpha_hash);

[kEalpha_hash] = judge_alpha_ternary(kenv,kEalpha,kEbias,2,kalpha_hash);

plot_alpha_ternary(kgraph,kenv,kEalpha_hash,'Estimated,group LASSO');
plot_alpha_ternary(kgraph,kenv,kalpha_hash,'Kim: True connection');

kEalpha_fig = reshape(kEalpha_hash,[],9);
