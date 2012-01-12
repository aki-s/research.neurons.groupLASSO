%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','conf_user.m overrides all configuration variables set after this file.');
if 1 == 0
  DEBUG_s = 'gen_9_non'
elseif 1 == 0
  DEBUG_s = 'comp_steven_glm'
elseif 1 == 0
  DEBUG_s = 'comp_steven_bar'
elseif 1 == 0
  DEBUG_s = 'my_n9.con'
elseif 1 == 1
  DEBUG_s = 'dev-test'
end
env.SELF_DEPRESS_BASE = 6.5; % good. c.a. generate firing of 30Hz.
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';
env.hwind = 1; % large hwind cause continuous firing of each neuron.
env.hnum = 100;
env.Hz.video = 1000;

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 10; % num of neuron per window for connection matrix
graph.xrange = 1000;

status.realData = 0;
status.READ_NEURO_CONNECTION = 1; % 
status.GEN_TrueValues = 1; % necessary
status.estimateConnection = 1;
status.save_vars = 1;
status.diary = 1;
status.parfor_ = 1;
status.mail = 1;
status.profiler = 0; % run MATLAB profiler


DAL.regFac_UserDef = 1;
switch DEBUG_s
  case 'gen_9_non'    %Aki method Aki firing
    status.crossVal = 8;
    DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1 0.5 0.25 0.125];
    env.genLoop = 210000; % indispensible
    env.useFrame = [10000 20000 40000 80000 160000]; % indispensible
    graph.PLOT_T = 1;
    status.inStructFile = [ rootdir_ '/indir/my_n9_allZeroCon.con'];

  case 'my_n9.con'
    status.crossVal = 8;
    DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1 0.5 0.25 0.125];
    env.genLoop = 210000; % indispensible
    env.useFrame = [10000 20000 40000 80000 160000]; % indispensible
    graph.PLOT_T = 1;
    status.inStructFile = [ rootdir_ '/indir/my_n9.con'];
  case 'dev-test'
    status.crossVal = 4;
    DAL.regFac = [8 2];
    env.genLoop = 40001;
    graph.PLOT_T = 1;
    status.inStructFile = [ rootdir_ '/indir/my_n9.con'];
    %    env.useFrame = [5000 10000 50000 90000];% indispensable
    env.useFrame = [1000 10000];% indispensable
    env.spar.level.from= .5;
    env.spar.level.to =  .4;
    env.cnum = 9;
  case 'comp_steven_glm'
    %    status.crossVal = 8;
    DAL.regFac = [ 16 10 8 4];
    env.genLoop = 110000; % indispensible
    env.useFrame = [10000]; % indispensible
    graph.PLOT_T = 1;
    status.inStructFile = [ rootdir_ '/indir/my_n9.con'];
case 'comp_steven_bar'
  %% you must edit conf_set_BasisStruct_glm.m
  bases.ihbasprs.basisType='bar';
  bases.ihbasprs.nbase=50;
  bases.ihbasprs.numFrame=  bases.ihbasprs.nbase;
  %%%%
status.READ_FIRING =1; % read kim FIRING. ++bug:critical
  status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/30-Nov-2011-start-20_6/30_11_2011__20_6.mat';
env.inFiringLabel ='I';
  env.inFiringDirect = 1;

  %%%%
    DAL.regFac = [ 10];
    env.genLoop = 110000; % indispensible
    env.useFrame = [10000]; % indispensible
    graph.PLOT_T = 1;
    status.inStructFile = [ rootdir_ '/indir/my_n9.con'];
    status.GEN_TrueValues = 0;
  otherwise
    fprintf(1,['not_DEBUG_MODE -- set variables used to estimate ' ...
               'randomly generated network\n']);
end

%% DEBUG
status.clean = 0;
