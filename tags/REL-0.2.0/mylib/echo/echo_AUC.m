function [auc recr thresh0 ] = echo_AUC(method,regFac,fFNAME,uFnum,inFiringUSE,F,M_ans,inRoot)

%% ==< calcAUC >==
uR = length(regFac);
auc = zeros(F.to,uR);
recr = zeros(F.to,uR,4);
thresh0 = zeros(F.to,uR);

for j0 = F.from:F.to
  for i0 = 1:length(inFiringUSE)
    for regFacIdx = 1:length(regFac)
      filename =sprintf('%s-%s-%s-%s-%s.mat',method, regFac{regFacIdx}, ...
                        fFNAME, uFnum{j0}, inFiringUSE{i0});
      load( [inRoot '/' filename], 'ResFunc');
      RFIntensity = evalResponseFunc( ResFunc );
      [recn, recr(j0,regFacIdx,1:4), thresh0(j0,regFacIdx) ,auc(j0,regFacIdx)] = evalRFIntensity(RFIntensity, M_ans);
      disp( sprintf( ['%20s:'...
                      ' %3d, %3d, %3d, %6d:'...
                      ' %5.1f, %5.1f, %5.1f, %5.1f:'...
                      ' %4.3f',...
                      ' %5.3f'],...
                     filename,...
                     recn, recr(j0,regFacIdx,1:4)*100,...
                     auc(j0,regFacIdx),...
                     thresh0(j0,regFacIdx)) );
    end
  end
  fprintf(1,'\n');
end
%% ==</calcAUC >==

