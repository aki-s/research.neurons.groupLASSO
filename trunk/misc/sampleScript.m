clear;close all;
env=struct('genLoop',30000,'hwind',4,'hnum',50', ...
                           'cnum',6,'spar',[],'Hz',[])
env.Hz.video=100;
env.spar.level=[];
env.spar.level.from=0.5;
env.spar.level.to=0.5;

%%
run('../myest.m')
