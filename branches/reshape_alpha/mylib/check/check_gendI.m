
%% check whether enough firing is.
tmpPrm = 1000;
tmpNidx = 1:env.cnum;

status.usedNeuronIdx  = tmpNidx.*(sum(Iorg,1) > tmpPrm);
I = Iorg(:,(status.usedNeuronIdx>0));
tmpNewNum = size(I,2);
tmpOrgNum = size(Iorg,2);
if tmpNewNum ~= tmpOrgNum
  if (env.inFiringUSE > tmpNewNum)
    warning('DEBUG:notice','not enough firing neuron');
    env.inFiringUSE = tmpNewNum;
    env.useNeuroLen = 1;
  else % avoid override
% $$$   tmpNuse = [ env.inFiringUSE tmpNewNum];
% $$$   env.inFiringUSE = unique(sort(tmpNuse(tmpNuse<=tmpNewNum),'descend'));
    env.inFiringUSE = unique(sort(env.inFiringUSE(env.inFiringUSE<=tmpNewNum),'descend'));
    if env.useNeuroLen ~= length(env.inFiringUSE)
      env.useNeuroLen = length(env.inFiringUSE);
    else
      env.inFiringUSE = env.inFiringUSE(1:env.useNeuroLen);
    end
  end
  %  for i1 = 1:length(env.inFiringUSE)
  for i1 = 1:env.useNeuroLen
    warning('DEBUG:info','Not enough firing. #neuron to be used is (%4d<-%4d)\n', ...
            env.inFiringUSE(i1),tmpOrgNum)
  end
end
