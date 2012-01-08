
%% check whether enough firing is.
tmpPrm = 1000;
tmpNidx = 1:env.cnum;

status.usedNeruronIdx  = tmpNidx.*(sum(Iorg,1) > tmpPrm)
I = Iorg(:,(status.usedNeruronIdx>0));
env.inFiringUSE = size(I,2);
%status.usedNeruronIdx =status.usedNeruronIdx(status.usedNeruronIdx
%> 0);
