% usage:
% cd 'rootdir_'; rootdir_=pwd; run conf/setpaths.m

%KF,AM:= kim's firing, aki's method
%KF,KM:= kim's firing, kim's method

XLABEL = [0 2000 20000 90000];

% +/0/-: Strict Correct rate.
sKFAM = [0 0.728395  0.765432  0.802469 ];
sKFKM = [0 0.347  0.3827  0.3827 ];

%% 'Total accuracy'
figure
hold on;
% $$$ for i1 = 1:length(XLABEL)
% $$$   plot(XLABEL(i1),RATE(i1))
% $$$ end

plot(XLABEL,sKFKM,'--bs', 'MarkerEdgeColor','b', 'MarkerSize',10)
plot(XLABEL,sKFAM,'--rs', 'MarkerEdgeColor','k', 'MarkerSize',10)

set(gca,'XTick',XLABEL)
set(gca,'XTickLabel',XLABEL);
ylabel('Total accuracy')

legend('kim','aki')

%% 'Accuracy for +-'

figure
hold on
t=readTrueConnection('KimFig1.con')
lKFAM = [0 ];
lKFKM = [0 1 1 1];

% (+/-)/0: Lax Correct rate. for(+/-)
plot(XLABEL,lKFKM,'--bs', 'MarkerEdgeColor','b', 'MarkerSize',10)
plot(XLABEL,lKFAM,'--rs', 'MarkerEdgeColor','k', 'MarkerSize',10)
set(gca,'XTick',XLABEL)
set(gca,'XTickLabel',XLABEL);
ylabel('Accuracy for +-')

legend('kim','aki')

%% ' Accuracy for 0 '

figure
hold on
lKFAM = [0 ];
lKFKM = [0 0 0 0];

% (+/-)/0: Lax Correct rate. for 0
plot(XLABEL,1- lKFKM,'--bs', 'MarkerEdgeColor','b', 'MarkerSize',10)
plot(XLABEL,1- lKFAM,'--rs', 'MarkerEdgeColor','k', 'MarkerSize',10)
set(gca,'XTick',XLABEL)
set(gca,'XTickLabel',XLABEL);
ylabel(' Accuracy for 0 ')
legend('kim','aki')

%{
TrueCon = readTrueConnection('indir/KimFig1.con');
fig2000 = readTrueConnection('outdir/Kim/sim/2000frame.con');
%}

