function  [status] = conf_progress()
%% Default configuration.

global status;

status.diary = 1;
status.profiler = 0;
status.parfor_ = 1;

status.realData = 0;
status.READ_NEURO_CONNECTION = 1;
status.READ_FIRING = 0;
status.GEN_Neuron_individuality = 1; %++bug: not yet implemented.
if strcmp('Default','Default')
  status.GEN_TrueValues = 0;
  status.inFiring = '';
  status.method = 'Aki'; % used as a part of output file.
end
status.estimateConnection = 1;
status.save_vars = 1;
status.use.GUI = 0;
status.mail = 0;

status.DEBUG.plot = 0; %++bug: not yet implemented.
status.DEBUG.level = 0; 
status.DEBUG.strict = 0; %++bug: not yet implemented.
status.crossVal = 4;
status.crossVal_rough = 0; % skip re-calculation for speed up.
status.clean = 1;
