

N000 = {'1000', '2000', '5000','10000','20000','50000','90000'}
L000 = {'5', '10', '50', '100','1','1.000000e-01','1.000000e-02'}
load('M_ans.mat') % M_ans

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