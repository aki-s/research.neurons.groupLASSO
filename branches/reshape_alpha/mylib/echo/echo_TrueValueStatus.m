function echo_TrueValueStatus(env,status,lambda,I)
%function echo_TrueValueStatus(env,status,envSummary)

global envSummary;

hwind   = env.hwind  ;   
genLoop = env.genLoop; 
hnum    = env.hnum   ;    

if isfield(envSummary.ctypesum,'hybrid') && ( envSummary.ctypesum.hybrid > 0 )
  warning('some neuron is hybrid.')
end

intensity = median(min(lambda));
envSummary.hypoFiringRate_min =...
    (1-exp(-intensity/env.Hz.video)) * env.Hz.video; 

intensity = median(max(lambda));
envSummary.hypoFiringRate_max =...
    (1-exp(-intensity/env.Hz.video)) * env.Hz.video; 

envSummary.FiringRate = ...
    envSummary.I/envSummary.simtime;
