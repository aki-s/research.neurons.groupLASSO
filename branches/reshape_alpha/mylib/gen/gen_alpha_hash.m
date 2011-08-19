function [alpha_fig,alpha_hash,statusOut] = gen_alpha_hash(env,status)

cnum = env.cnum;
spar = env.spar;
%%
alpha_fig = diag(repmat(-1,[1,cnum])); % malloc
if isnan(spar)

else
  alpha_fig(spar.from, spar.to) = 1; % connection 'true'.
  alpha_fig(logical(eye(cnum))) = -1; % diagonal element: connection 'true'.
end
alpha_hash = alpha_fig(:);


statusOut = status;
%statusOut.inStructFile = NaN;
statusOut.inStructFile = '';

