function [ResFunc] = gen_TrueResFunc(env,status,ResFunc_hash)
%%
%% Usage:)
%% [ResFunc] = gen_TrueResFunc(env,status,ResFunc_hash);
global envSummary;

%% ==< set local variables >==
cnum    = env.cnum   ;    
hnum    = env.hnum   ;    
%% ==</set local variables >==

ResFunc = zeros(hnum*cnum,cnum);

if ( status.READ_NEURO_CONNECTION == 1 )
  ResFunc = kernel00(ResFunc_hash,env);
end

if ( status.READ_NEURO_CONNECTION ~= 1 )
  %%% ===== prepare True Values ===== START ===== 
  ResFunc = kernel00(ResFunc_hash,env);
end
