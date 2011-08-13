function DALout = setDALregFac(DALin,bases)

nbase = bases.ihbasprs.nbase;

if DALin.regFac_UserDef == 1
  DALin.div = NaN;
  a = DALin.regFac > 0.001;
  b = 1;
  DALin.loop = length(DALin.regFac);
  for i1 = 1:DALin.loop
    b = b*a(i1);
  end
  if  isfield(DALin,'regFac') && b
  else
    error('')
  end
else

  if strcmp('setRegFac_auto','setRegFac_auto')
    if 1==1
      DALin.regFac(1) = sqrt(nbase)*10; % DALin.regFac: group LASSO parameter.
    else
      DALin.regFac(1) = sqrt(nbase); % DALin.regFac:
    end
    %  DALin.regFac(1) = uint32(sqrt(DALin.Drow)); % DALin.regFac:
    %  DALin.regFac(1) = uint32(sqrt(DALin.Drow)*nbase); % DALin.regFac:
  else
    DALin.regFac(1) = 1; % DALin.regFac: group LASSO parameter.
  end

end

DALout = DALin;
