DAL.regFac = [1000 100 50 10 1];
env.useFrame = [
    1000 % 1 
    2000 % 2 
    5000 % 3
    10000 % 4
    20000 % 5
    50000 % 6
    90000 % 7
    100000 % 8
               ];
status.method = 'Aki';
status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/Simulation/data_sim_9neuron.mat';
load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat') % M_ans, env, status

uF = length(env.useFrame);
for i1 =1:uF
  N000{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
end
for i1 =1:length(DAL.regFac)
  L000{i1} = num2str(sprintf('%07d',DAL.regFac(i1)));
end

if 1 == 0
  for N1 = 1:3
    filename = sprintf('KimKim%s.mat', N000{N1});
    load( filename ); % Phi
    [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
    disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                   filename, recn, recr*100 ) )
  end
end

for N1 = 1:3
    filename = sprintf('KimAki%s.mat', N000{N1});
    load( filename ); % Phi
    [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
    disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
         filename, recn, recr*100 ) )
end