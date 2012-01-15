function [status] = check_gendConfState(status)
if exist('status') && isfield(status,'GEN_TrueValues')
  if ( 0 == getfield(status,'GEN_TrueValues') )
    warning('WarnTests:convertTest', ...
            ['LEVEL:#1: Generating [ FiringIntensity ''lambda'', Firing ''I'' ' ...
             '] was skipped.']);
  end
end
