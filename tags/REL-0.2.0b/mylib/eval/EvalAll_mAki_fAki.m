DAL.regFac = [1000 100 50 10 1];
env.useFrame = [
    1000 % 1 
    2000 % 2 
    5000 % 3
    10000 % 4
    20000 % 5
    50000 % 6
    90000 % 7
    %      100000 % 8
               ];
status.method = 'Aki';
status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/Simulation/data_sim_9neuron.mat';
load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat') % M_ans

for i1 =1:length(env.useFrame)
  N000{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
end
for i1 =1:length(DAL.regFac)
  L000{i1} = num2str(sprintf('%07d',DAL.regFac(i1)));
end

FNAMEm = strcat(status.method,'-');
FNAMEf = strcat('-',regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2'));
FNAMEf = strcat(FNAMEf,'-');

N000
L000

for N1 = 1:length(N000)
  for L1 = 1:length(L000)
    filename =sprintf('%s%s%s%s.mat',FNAMEm, L000{L1}, FNAMEf, N000{N1});
    load( filename ); %ResFunc
    Phi = evalResponseFunc( ResFunc );
    [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
    disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                   filename, recn, recr*100 ) )
  end
end

%% used firing.
% /home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/20-Aug-2011-start-20_44/20-Aug-2011-20_44.mat
for N1 = 1:length(N000)
    for L1 = 1:length(L000)
        filename =sprintf('Aki-%s-Aki-%s.mat', L000{L1}, N000{N1});
        load( filename ); %ResFunc
        Phi = evalResponseFunc( ResFunc );
        [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
        disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
            filename, recn, recr*100 ) )
    end
end

