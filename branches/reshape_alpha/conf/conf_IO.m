function [envOut statusOut] = conf_IO(envIn, statusIn)

global rootdir_
statusOut = statusIn;
envOut = envIn;
%%
%statusOut.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];
statusOut.inFiring = [ rootdir_ ['/indir/Real_data/' ...
                    'data_real_catM1.mat']];

% DAL.Drow
if 1 == 0
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
  if 1 == 0
    envOut.useFrame = [
        3000
                      ];
  elseif 1 == 0
    envOut.useFrame = [
        3000
        10000 
        50000 
        100000
        150000
                      ];
  elseif 1 == 1
    envOut.useFrame = [
        100000
                      ];
  end

end

%statusOut.checkDirname = '/outdir/check_110818';
statusOut.checkDirname = '/indir/Real_data/myest_outdir';
