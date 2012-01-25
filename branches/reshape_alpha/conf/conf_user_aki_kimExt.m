%% Set freely your configuration.
%% Please overload default configuration explicitly by writing here.
warning('DEBUG:conf','%s overrides all configuration variables set after this file.',mfilename);

DAL.regFac_UserDef = 1;
if 0
DAL.regFac = [ 2.^(17:-1:-3) ];
env.useFrame = 1000*[ 2.^(0:1:8)];
end
DAL.regFac = [ 2.^(17:-1:-3) ];
env.useFrame = [
    75000
               ];
%% [frame] [regFac] [2.^x]
%%
%%    4000        2     1
%%   10000       32     5
%%   20000      128     7
%%   40000      512     9 
%%                        
%env.inFiringLabel ='X';
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
status.GEN_TrueValues = 1;
status.READ_FIRING =0; % generate FIRING.
status.estimateConnection = 1;
status.mail = 1;
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 1;
if strcmp('simulation','simulation')
  env.cnum = 11; % indispensible
  env.genLoop = 300000; % indispensible
  env.hnum = 100; % indispensible
  env.hwind = 1; %  indispensible
  env.Hz.video = 1000; % indispensible
  env.SELF_DEPRESS_BASE = 6.5; % indispensible
  status.realData = 0;
  status.inStructFile = [ rootdir_ '/indir/KimFig1_AkiExt.con'];
end
