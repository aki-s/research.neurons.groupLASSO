function [status] = check_genState(status);
if exist('status') && isfield(status,'GEN_TrureValues')
  if ( 0 == getfield(status,'GEN_TrureValues') )
    warning('WarnTests:convertTest', ...
            ['LEVEL:#1: Generating [ FiringIntensity ''lambda'', Firing ''I'' ' ...
             '] was skipped.']);
  end
end
