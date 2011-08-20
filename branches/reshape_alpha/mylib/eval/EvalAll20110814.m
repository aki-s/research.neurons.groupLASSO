

N000 = {'1000', '2000', '5000','10000','20000','50000','90000'}
L000 = {'5', '10', '50', '100','1','1.000000e-01','1.000000e-02'}
load('M_ans.mat') % M_ans
for N1 = 1:3
    for L1 = 1:4
        if N1 == 1
            L11 = L1 + 3;
        else
            L11 = L1;
        end
        filename =sprintf('Aki_%s_Aki%s.mat', L000{L11}, N000{N1});
        load( filename ); %Alpha
        Phi = evaluateAlpha( Alpha );
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