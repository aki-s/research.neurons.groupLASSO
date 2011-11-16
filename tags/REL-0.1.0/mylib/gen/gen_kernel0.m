function  [kernel] = gen_kernel0(bases,W);

global status
if status.DEBUG.plot == 1
  plot((bases.ihbasis)*W')
end
kernel = (bases.ihbasis)*W';
