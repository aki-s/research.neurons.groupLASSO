%% generate figure

N000 = {'2000', '20000', '90000'}
L000 = {'5', '10', '50', '100','1','1.000000e-01','1.000000e-02'}
L0 = [5,2,2]

load('M_ans.mat') % M_ans
AkiAcc = zeros(3,4);
for N1 = 1:3
  filename =sprintf('Aki_%s_Aki%s.mat', L000{L0(N1)}, N000{N1});
  load( filename ); %Alpha
  Phi = evaluateAlpha( Alpha );
  [recn, recr, thresh0] = evaluatePhi(Phi, M_ans);
  disp( sprintf( '%20s: %3d, %3d, %3d, %3d, %5.1f, %5.1f, %5.1f, %5.1f',...
            filename, recn, recr*100 ) );
  AkiAcc(N1,:) = recr*100;
end

KimAcc = zeros(3,4)
for N1 = 1:3
    filename = sprintf('KimAki%s.mat', N000{N1});
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
N=3;
for i=1:N
    subplot(N,1,i)
    plot(1:3, AkiAcc(:, A0(i) ),'o-',...
        1:3, KimAcc(:, A0(i) ), '^--')
    ylabel( ylabels{i})
    xlabel( '# Frames' )
    xlim([0,3]+0.5)
    ylim([0,105])
    set(gca, 'XTick', 1:3, 'XTickLabel', N000)
end
set(gcf, 'Color', 'White', 'Position',[100,100,400,800])

