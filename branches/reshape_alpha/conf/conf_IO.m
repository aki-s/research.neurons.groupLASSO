function [envOut statusOut] = conf_IO(envIn, statusIn)

global rootdir_
statusOut = statusIn;
envOut = envIn;
%%
statusOut.inFiring = [ rootdir_ '/indir/Simulation/data_sim_9neuron.mat'];

envOut.useFrame = [
 1000 % 1 
 2000 % 2 
 5000 % 3
10000 % 4
20000 % 5
50000 % 6
90000 % 7
];

k = 1;
envOut.useFrame = envOut.useFrame(k);
