%% generate figure
%==< conf >==
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
status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/Simulation/data_sim_9neuron.mat';
load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat') % M_ans

%==</ conf >==

uF = length(env.useFrame);
for i1 =1:uF
  N000{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
end
for i1 =1:length(DAL.regFac)
  L000{i1} = num2str(sprintf('%07d',DAL.regFac(i1)));
end

L0 = repmat(2,[1 uF] );

FNAMEf = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
%%%%%%%%%%%%%%%%%%%%%%%%
AkiAcc = zeros(3,4);
for N1 = 1:uF
  %Aki method Aki firing
  filename =sprintf('Aki-%s-%s-%s.mat', L000{L0(N1)}, FNAMEf, N000{N1});
  load( filename ); %Alpha
  Phi = evaluateAlpha( Alpha );
  [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) );
  AkiAcc(N1,:) = recr*100;
end


KimAcc = zeros(3,4)
for N1 = 1:uF
  filename = sprintf('Kim-%s-%s.mat', FNAMEf, N000{N1});
  load( filename ); % Phi
  [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) )
  KimAcc(N1,:) = recr*100;
end


% recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
% recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(Phi)];

figure
A0 = [4,1,2,3]
ylabels ={'Total', 'Specificity', 'Excitatory', 'Inhibitory'};
%for i=1:4
N = 4;
for i=1:N
  subplot(N,1,i)
 plot(1:uF, AkiAcc(:, A0(i) ),'o-',...
     1:uF, KimAcc(:, A0(i) ), '^--')
  ylabel( ylabels{i}) %
  xlabel( '# Frames' )
  set(gca, 'XTick', 1:uF, 'XTickLabel', N000)
  axis([0 uF 0 105])
end
set(gcf, 'Color', 'White', 'Position',[100,100,400,800])

