function [ResFunc_fig,ResFunc_hash,statusOut] = gen_ResFunc_hash(env,status)

cnum = env.cnum;
spar = env.spar;
%%
ResFunc_fig = diag(repmat(-1,[1,cnum])); % malloc
if ~isstruct(spar)
  % isnan(spar)
else
  ResFunc_fig(spar.from, spar.to) = 1; % connection 'true'.
  ResFunc_fig(logical(eye(cnum))) = -1; % diagonal element: connection 'true'.
end
ResFunc_hash = ResFunc_fig(:);


statusOut = status;
%statusOut.inStructFile = NaN;
statusOut.inStructFile = '';

