function echo_TrueValueStatus(env,status,lambda,I)
%function echo_TrueValueStatus(env,status,Tout)

global Tout;

hwind   = env.hwind  ;   
genLoop = env.genLoop; 
hnum    = env.hnum   ;    

if isfield(Tout.ctypesum,'hybrid') && ( Tout.ctypesum.hybrid > 0 )
  warning('some neuron is hybrid.')
end

intensity = median(min(lambda));
Tout.hypoFiringRate_min =...
    (1-exp(-intensity/env.Hz.video)) * env.Hz.video; 

intensity = median(max(lambda));
Tout.hypoFiringRate_max =...
    (1-exp(-intensity/env.Hz.video)) * env.Hz.video; 

Tout.FiringRate = ...
    Tout.I/Tout.simtime;
