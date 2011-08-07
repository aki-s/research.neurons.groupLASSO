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
