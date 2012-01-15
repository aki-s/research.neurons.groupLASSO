status.time.end = fix(clock);

if 1 == 0  %% When you use PBS closing matlabpool cause error.
  if  ( matlabpool('size') > 0 ) % && <no thred running>
    matlabpool close
  end
fprintf('debug: postproc\n')
end
