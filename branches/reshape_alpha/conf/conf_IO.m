function [envOut statusOut] = conf_IO(envIn, statusIn)

global rootdir_
statusOut = statusIn;
envOut = envIn;
%%
statusOut.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];

% DAL.Drow
if 1 == 1
  envOut.useFrame = [
      1000 % 1 
      2000 % 2 
      5000 % 3
      10000 % 4
      20000 % 5
      50000 % 6
      90000 % 7
      100000 % 8
                    ];
else
  envOut.useFrame = [
  %      99999
   2000
                 ];
end

statusOut.checkDirname = '/outdir/check_110818';
