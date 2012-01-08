function set_matlabpool(parfor_flag,poolSize)
% set_matlabpool(parfor_flag,poolSize)

if 1 == 0
  %% matlabpool close force local
  if parfor_flag == 1 && ( matlabpool('size') == 0 )
    %    matlabpool(8);
    if (poolSize > 1 )
      try 
        matlabpool(poolSize)
      catch open_fail
        matlabpool;% automatically use max core
      end
    end
  end
  %%
elseif 1 == 0 %++test
  if parfor_flag == 1 && ( matlabpool('size') == 0 )
    matlabpool;% automatically use max core
    if ( matlabpool('size') > poolSize ) % spare computation core
      matlabpool close;
      matlabpool(poolSize)
    end
  end
else
  if parfor_flag == 1 && ( matlabpool('size') == 0 )
    matlabpool;% automatically use max core
  end
end
