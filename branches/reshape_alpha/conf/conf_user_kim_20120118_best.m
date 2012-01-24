%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','%s overrides all configuration variables set after this file.',mfilename);

DAL.regFac_UserDef = 1;
if strcmp('test','test')
    DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1 0.5 0.25 0.125];
    env.useFrame = [
        1000
        4000
        10000
        20000
        40000
        75000
                   ];
end
env.inFiringLabel ='X';
env.Hz.video=1000;
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 15;
graph.GRAPHVIZ_OUT_FIG = 1; % default: 0
graph.xrange = 1000;
%% extra
graph.PLOT_T = 1;
graph.prm.Yrange = [-.5 5];
graph.prm.diag_Yrange = [-.5 5];

status.save_vars = 1;
status.parfor_ = 1;
status.crossVal = 4; %% default: 4
status.GEN_TrueValues = 0;
status.READ_FIRING =1; % read kim FIRING.
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1;
if strcmp('simulation','simulation')
  status.realData = 0;
  status.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];
  env.inFiringDirect = 1;
  status.inStructFile = [ rootdir_ '/indir/KimFig1.con'];
else strcmp('real','real')
  status.realData = 1;
  status.inFiring = [ rootdir_ ['/indir/Real_data/' ...
                      'data_real_catM1.mat']];
  env.inFiringDirect = 2;
end

