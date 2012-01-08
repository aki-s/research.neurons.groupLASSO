status.time.end = fix(clock);

if 1 == 1
  if  ( matlabpool('size') > 0 ) % && <no thred running>
    matlabpool close
  end
end
