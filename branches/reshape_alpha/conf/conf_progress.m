function  [status] = conf_progress()
%% Default configuration.

global status;

status.profiler = 0;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1;

status.realData = 0;
status.READ_NEURO_CONNECTION = 1;
status.READ_FIRING = 0;
status.GEN_Neuron_individuality = 1; %++bug: not yet implemented.
if strcmp('Default','Default')
  status.GEN_TrueValues = 1;
  status.inFiring = 'Aki';
  status.method = 'Aki';
else
  %%  status.method = 'Kim'; % garbage?
end
status.estimateConnection = 1;
status.save_vars = 0;
status.use.GUI = 1;
status.mail = 0;

status.DEBUG.plot = 0; %++bug: not yet implemented.
status.DEBUG.level = 0; %++bug: not yet implemented.
status.DEBUG.strict = 0; %++bug: not yet implemented.
status.crossVal = 4;
status.clean = 1;
