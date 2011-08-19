function  [status] = conf_progress()
%function  conf_progress(status)
%% Default configuration.

global status;

status.profiler = 0;
status.save_warning = 1; %++bug: not yet implemented.
status.parfor_ = 1; %++bug: not yet implemented.

status.READ_NEURO_CONNECTION = 1;
status.READ_FIRING = 0;
status.GEN_TrueValues = 1;
status.GEN_Neuron_individuality = 1; %++bug: not yet implemented.
status.estimateConnection = 1;
status.use.GUI = 1;
status.mail = 0;

status.DEBUG.plot = 0;
status.DEBUG.level = 0;
status.DEBUG.strict = 0; %++bug: not yet implemented.
