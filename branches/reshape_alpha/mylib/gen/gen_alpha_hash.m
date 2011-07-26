function [alpha_fig,alpha_hash] = gen_alpha_hash();
%function [alpha_fig,alpha_hash] = gen_alpha_hash(env);


global env
cnum = env.cnum;
spar = env.spar;

%alpha_fig = zeros(cnum,cnum); % malloc
alpha_fig = diag(repmat(-1,[1,cnum])); % malloc
alpha_fig(spar.from, spar.to) = 1; % connection 'true'.
alpha_fig(logical(eye(cnum))) = -1; % diagonal element: connection 'true'.

%alpha_fig(diag(alpha_fig)) = -1;
%diag(alpha_fig) = -1;
alpha_hash = alpha_fig(:);
