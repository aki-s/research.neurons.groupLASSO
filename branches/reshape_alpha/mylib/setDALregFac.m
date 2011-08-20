function DALout = setDALregFac(env,DALin,bases)

nbase = bases.ihbasprs.nbase;

if DALin.regFac_UserDef == 1
  DALin.div = NaN;
  Dlim = 0.01;
  a = DALin.regFac > Dlim;
  b = 1;
  loop = length(DALin.regFac);
  for i1 = 1:loop
    b = b*a(i1);
  end
  if  isfield(DALin,'regFac') && b
  elseif (b == 0)
    error('DAL.regFac is too small');
  end
else

  if strcmp('setRegFac_auto','setRegFac_auto')
    DALin.regFac(1) = sqrt(nbase)*10; % DALin.regFac: group LASSO parameter.
  else
    DALin.regFac(1) = sqrt(nbase); % DALin.regFac:
  end
  
end

DALout = DALin;
% $$$ if isfield(DAL,'Drow')
% $$$ else
% $$$   DAL.Drow = env.useFrame;
% $$$ end
