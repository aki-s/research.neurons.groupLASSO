function [ResFunc_fig,ResFunc_hash,statusOut] = gen_ResFunc_hash(env,status)
%%  [ResFunc_fig,ResFunc_hash,statusOut] =
%%  gen_ResFunc_hash(env,status)

cnum = env.cnum;
spar = env.spar;
%% properly calculate env.spar %++todo ++bug
%%
%% malloc and make diagonal elements inhibitory.
% $$$  ResFunc_fig = diag(repmat(-1,[1,cnum]));
ResFunc_fig = zeros(cnum);
if isstruct(spar)
  ResFunc_fig(spar.from, spar.to) = 1; % exist connection
  ResFunc_fig = ResFunc_fig.*sign(randn(cnum));% excitatory/inhibitory connection.
  if strcmp('diag_is_inhibitory','diag_is_inhibitory')
    ResFunc_fig(logical(eye(cnum))) = -1; % diagonal element must be inhibitory connection?
  end
end
ResFunc_hash = ResFunc_fig(:);


statusOut = status;
%statusOut.inStructFile = NaN;
statusOut.inStructFile = '';

