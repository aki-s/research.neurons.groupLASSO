global kenv;

global kstatus;
kstatus = conf_progress(kstatus);
kstatus.mail = 1;
kstatus.use.GUI = 0;
kstatus.GEN_TrureValues = NaN;
kstatus.GEN_Neuron_individuality = NaN;
kstatus.time.start = fix(clock);

global kgraph;
kgraph = conf_graph();
global kbases;


if ~exist(rootdir_)
  global rootdir_
  %  rootdir_ = pwd;
  error('set ''rootdir_'' to where ''myest.m'' is located');
end
addpath([rootdir_ '/misc']);
addpath([rootdir_ '/misc/compare']);

if strcmp('tweak_to_yours','tweak_to_yours')
  kenv.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
  kenv.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
end

if ~exist('kbases')
  %% Create GLM structure with default params
  kbases = makeSimStruct_glm(0.01);
  warning('NOTICE:speedup','generating kbases was skipped to speed up.')
end

kenv
[kEKerWeight,kEbias,kEstatus,kEalpha,kDAL,kstatus] = ...
    compare_KIM(kbases,[rootdir_ '/indir/Simulation/data_sim_9neuron.mat']);


% judge connection from variance<->mean,median
% (enumerate in term of confidence.)

if exist('alpha_hash')
  [kEalpha_hash] = comp_alpha_ternary(kenv,kEalpha,Ebias,2,alpha_hash);
else
  [kEalpha_hash] = judge_alpha_ternary(kenv,kEalpha);
end
plot_alpha_ternary(kgraph,kenv,kEalpha_hash);

kEalpha_fig = reshape(kEalpha_hash,[],9);
