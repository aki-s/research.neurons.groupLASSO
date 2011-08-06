function [alpha] = gen_TrueWeightKernel(env,status,alpha_hash)
%%
%% Usage:)
%% [alpha] = gen_TrueWeightKernel(env,status,alpha_hash);
global Tout;

%% ==< set local variables >==
cnum    = env.cnum   ;    
hnum    = env.hnum   ;    
%% ==</set local variables >==

alpha = zeros(hnum*cnum,cnum);

if ( status.READ_NEURO_CONNECTION == 1 )
  alpha = kernel00(alpha_hash,env);
end

if ( status.READ_NEURO_CONNECTION ~= 1 )
  %%% ===== prepare True Values ===== START ===== 
% $$$   ctype = 2*(randn(1,cnum)>0) - 1; 
% $$$   ctype_hash = ctype;
% $$$   Tout.ctypesum.inhibitory = length(find(ctype == -1)); % number of inhibitory neurons.
% $$$   Tout.ctypesum.excitatory = length(find(ctype == +1)); % number of excitatory neurons.

  %% ctype: ctype of neuron. 0 == excitatory, -1 == inhibitory
% $$$   ctype = repmat(ctype*(pi/2),cnum,1);
% $$$   ctype(logical(eye(cnum))) = -pi;  % All neuron must have self-depression.

% $$$   for i1 = 1:cnum
% $$$     error('temporary this functionality is under development.');
% $$$     %   alpha=;
% $$$   end
  alpha = kernel00(alpha_hash,env);
end
