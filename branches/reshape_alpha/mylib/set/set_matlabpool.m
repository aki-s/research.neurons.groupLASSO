function set_matlabpool(parfor_flag,poolSize)
% set_matlabpool(parfor_flag,poolSize)

%% matlabpool close force local
if parfor_flag == 1 && ( matlabpool('size') == 0 )
  %    matlabpool(8);
  if (poolSize > 1 )
    matlabpool(poolSize)
  else
    matlabpool;% automatically use max core
  end
end
