global kenv;
global kgraph;
global kbases;

if ~exist(rootdir_)
  global rootdir_
  rootdir_ = pwd;
end


if strcmp('tweek_to_yours','tweek_to_yours')
  kenv.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
  kenv.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
end

if ~exist('kbases')
  %% Create GLM structure with default params
  kbases = makeSimStruct_glm(0.01);
  warning('NOTICE:speedup','generating kbases was skipped to speed up.')
end

kgraph = conf_graph();
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
