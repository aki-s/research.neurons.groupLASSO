function [alpha] = gen_TrueWeightKernel(env,status,alpha_hash);

%% ==< set local variables >==
hwind   = env.hwind  ;   
genLoop = env.genLoop; 
cnum    = env.cnum   ;    
hnum    = env.hnum   ;    
SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
%% ==</set local variables >==

alpha = zeros(hnum*cnum,cnum);

if ( status.READ_NEURO_CONNECTION == 1 )
  %% ==< generate alpha>==
% $$$   %% --< init >--
% $$$   weight_kernel = zeros(1,hnum);
% $$$   for i1 = 1:hnum
% $$$     %++improve: generate characteristic of neuron.
% $$$     weight_kernel(i1) = cos( (i1/hnum)*(pi/2) )*exp(-(i1-1)/hnum*3);
% $$$   end
% $$$   i3 = 0;
% $$$   %% --</init >--
% $$$   for i1 = 1:cnum %%++parallel
% $$$     for i2 = 1:cnum
% $$$       i3 = i3 + 1;
% $$$       flag = alpha_hash(i3); %flag: +/0/-, exitatory/0/inhibitory
% $$$       ptr = (i2-1)*hnum; %ptr: pointer
% $$$ 
% $$$       if i1 == i2 %++bug: unneeded proc.
% $$$                   %        alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel)
% $$$                   %        -SELF_DEPRESS_BASE;
% $$$         alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
% $$$       else
% $$$         switch ( flag ) 
% $$$           case +1
% $$$             alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
% $$$           case -1                 
% $$$             alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
% $$$           case 0                  
% $$$             alpha(ptr+1:ptr+hnum,i1) = zeros(1,hnum);
% $$$         end
% $$$       end
% $$$     end
% $$$   end
  alpha = kernel00(alpha_hash,env);
  %% ==</ generate alpha>==
end

if ( status.READ_NEURO_CONNECTION ~= 1 )
  %%% ===== prepare True Values ===== START ===== 
  global Tout;
  spar    = env.spar   ;
  ctype = 2*(randn(1,cnum)>0) - 1; 
  ctype_hash = ctype;
  Tout.ctypesum.inhibitory = length(find(ctype == -1)); % number of inhibitory neurons.
  Tout.ctypesum.excitatory = length(find(ctype == +1)); % number of excitatory neurons.

  iniPhase = rand([cnum cnum])/2;
  %% ctype: ctype of neuron. 0 == excitatory, -1 == inhibitory
  ctype = repmat(ctype*(pi/2),cnum,1);
  ctype(logical(eye(cnum))) = -pi;  % All neuron must have self-depression.

% $$$   for i1 = 1:cnum
% $$$     error('temporary this functionality is under development.');
% $$$     %   alpha=;
% $$$   end
  alpha = kernel00(alpha_hash,env);
  nIt = zeros([],cnum,hnum);
  Tout.ctype = sprintf('%8d',ctype_hash);
  clear ctype ctype_hash
end
