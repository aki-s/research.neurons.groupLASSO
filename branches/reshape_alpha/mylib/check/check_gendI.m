
%% check whether enough firing is.
tmpPrm = 1000;
tmpNidx = 1:env.cnum;

status.usedNeuronIdx  = tmpNidx.*(sum(Iorg,1) > tmpPrm);
I = Iorg(:,(status.usedNeuronIdx>0));
tmpNewNum = size(I,2);
tmpOrgNum = size(Iorg,2);
if tmpNewNum ~= tmpOrgNum
  env.inFiringUSE = size(I,2);
  fprintf('Not enough firing. #neuron to be used is (%4d<-%4d)\n',env.inFiringUSE,tmpOrgNum)
end
