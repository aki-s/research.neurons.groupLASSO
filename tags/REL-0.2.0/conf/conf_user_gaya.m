warning('DEBUG:conf','conf_user_gaya.m.');

DAL.regFac_UserDef = 1;

graph.TIGHT = 0;
graph.PLOT_MAX_NUM_OF_NEURO = 10;% #neuron to be plotted on a figure.
graph.xrange = 1000;
graph.PLOT_T = 1; % plot all results as graphs
graph.PRINT_T = 1; % write out plotted figure each time.
graph.prm.Yrange = [-.5 5];
graph.prm.diag_Yrange = [-.5 5];

env.inFiringLabel = 's';
env.inFiringDirect = 2; % time series direction
if strcmp('take_time','take_time')
  env.inFiringUSE = [60]; % the number of firing used out of 'env.inFiringLabel'.
                          % ( DAL.regFac < 1) is too high calculation cost
                          %++improve: implement abort() if it take too much of time.
                          % When env.inFiringUSE=60, DAL.regFac larger than 8 takes too much
                          % of time.
  DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8];
else
  env.inFiringUSE = [10 30]; % the number of firing used out of 'env.inFiringLabel'.
  DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1];
end
env.Hz.video=1000; %++bug: lookes like to be set 'nan'
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

status.save_vars = 1;
status.GEN_TrueValues = 0; % generate artificial spike train
status.profiler = 0;% run MATLAB-profiler
status.diary = 1; % save stdout
status.parfor_ = 1; % parallel calculation
status.mail = 1; % mail you at finish.(setting env.mail is indispensible.)
status.DEBUG.plot = 1; %++bug: not yet implemented.
status.DEBUG.level = 0; % stdout verbosely
status.use.GUI = 0;
status.realData = 1; %
status.READ_FIRING =1; % read gaya FIRING.
                       %status.inFiring =
                       %['/home/shige-o/rec072b.mat'];% spike train
                       %is saved.
status.inFiring = ['./indir/gaya/rec072b.mat'];% spike train is saved.
status.crossVal = 4; % do 'status.crossVal'-fold cross validation.
status.crossVal_rough = 1; % skip calculation for speed up.

%% DEBUG: the following is a test
% $$$ DAL.regFac = [ 64 32];
% $$$ env.inFiringUSE = [10 12];
DAL.regFac = [ 2048 1024 512 256 128 64 32 16 8 4 2 1];
