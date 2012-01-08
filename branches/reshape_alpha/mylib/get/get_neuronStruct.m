if (status.realData ~= 1 ) %% simulation on computer.
  if (status.READ_NEURO_CONNECTION == 1) % from I/O % (status.READ_FIRING ~= 1)
    [ResFunc_fig,ResFunc_hash,env,status] = readTrueConnection(env,status);
    Tout = get_neuronType(env,status,ResFunc_fig,Tout);
  elseif (status.GEN_TrueValues == 1)  % generate artifical random network connection
    [ResFunc_fig,ResFunc_hash,status] = gen_ResFunc_hash(env,status);
    Tout = get_neuronType(env,status,ResFunc_fig,Tout);
  end
else  %% inFiring was real Data.
 %% Read Data has nave not true answer
 %% unless electro physically checked on living neurons.
  status.inStructFile = '';
end
