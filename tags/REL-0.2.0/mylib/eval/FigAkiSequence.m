%% generate figure
%%==< conf >==
cd('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/check_110818')
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
status.inFiring = '/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/20-Aug-2011-start-20_19/20-Aug-2011-20_19.mat';
load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/indir/sim_kim_ans.mat') % M_ans
%%==</ conf >==

uF = length(env.useFrame);
uR = length(DAL.regFac);
for i1 =1:uF
  N000{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  N000L{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
end
for i1 =1:uR
  L000{i1} = num2str(sprintf('%07d',DAL.regFac(i1)));
end

%L0 = repmat(2,[1 uF] );
L0 = repmat(4,[1 uF] );


FNAMEf = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
%%%%%%%%%%%%%%%%%%%%%%%%
AkiAcc = zeros(uF,4);
for N1 = 1:uF
  filename =sprintf('Aki-%s-%s-%s.mat', L000{L0(N1)}, FNAMEf, N000{N1});
  load( filename ); %ResFunc
  Phi = evalResponseFunc( ResFunc );
  [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
  %{
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) );
  %}
  AkiAcc(N1,:) = recr*100;
end

fprintf(1,'\n');

%% ==< test >==
for N1 = 1:uF
  for reg = 1:uR
    filename =sprintf('Aki-%s-%s-%s.mat', L000{reg}, FNAMEf, N000{N1});
    load( filename ); %ResFunc
    Phi = evalResponseFunc( ResFunc );
    [recn, recr, thresh00] = evaluatePhi(Phi, M_ans);
    disp( sprintf( '%20s: %3d, %3d, %3d, %3d,: %5.1f, %5.1f, %5.1f, %5.1f, :%f',...
                   filename, recn, recr*100, thresh00 ) );
    %    AkiAcc(N1,:) = recr*100;
  end
  fprintf(1,'=====================================\n');
end
%% ==</test>==

KimAcc = zeros(uF,4);
for N1 = 1:uF
  filename = sprintf('Kim-%s-%s.mat',FNAMEf, N000{N1});
  load( filename ); % Phi
  [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
                 filename, recn, recr*100 ) )
  KimAcc(N1,:) = recr*100;
end


% recn( t1, : ) = [TP0, TPp, TPn, TPtotal];
% recr( t1, : ) = [TP0/N0, TPp/Np, TPn/Nn, TPtotal/length(Phi)];

A0 = [4,1,2,3];
ylabels ={'Total', 'Specificity', 'Excitatory', 'Inhibitory'};
N=4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
div2 = 2;

NN = N/div2;
div = 0;
for ii = 1:(div2)
  figure
  for i = 1:NN
    subplot(NN,1,i)
    hold on;
    plot(1:uF, AkiAcc(:, A0(i+div) ),'o-',...
         1:uF, KimAcc(:, A0(i+div) ), '^--')
    ylabel( ylabels{i+div})
    xlabel( '# Frames' )
    set(gca, 'XTick', 1:uF, 'XTickLabel', N000L)
    axis([0 uF 0 105])
  end
  set(gcf, 'Color', 'White', 'Position',[200,200,400,800/div2])
  div = div + div2;
end

