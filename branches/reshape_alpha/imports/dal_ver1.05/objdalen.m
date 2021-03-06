% objdalen - objective function of DAL with the Elastic-net regularization
%
% Copyright(c) 2009 Ryota Tomioka
% This software is distributed under the MIT license. See license.txt

function varargout=objdalen(aa, info, prob, ww, uu, A, B, lambda, eta)

theta=info.theta;

m = length(aa);
n = length(ww);

if isempty(info.ATaa)
  info.ATaa=A.Ttimes(aa);
end

vv = ww+eta(1)*info.ATaa;


if nargout<=3
  [floss, gloss, hmin]=prob.floss.d(aa, prob.floss.args{:});
else
  [floss, gloss, hloss, hmin]=prob.floss.d(aa, prob.floss.args{:});
end


[vsth,ss] = en_softth(vv,eta(1)*lambda,info);
info.wnew = vsth;
info.spec = ss;

fval = floss+0.5*(1+eta*lambda*(1-theta))*sum(vsth.^2)/eta(1);
if ~isempty(uu)
  u1   = uu+eta(2)*(B'*aa);
  fval = fval + 0.5*sum(u1.^2)/eta(2);
end

varargout{1}=fval;


if nargout<=2
  varargout{2} = info;
else
  gg  = gloss+A.times(vsth);
  soc = sum(((vsth-ww)/eta(1)).^2);
  if ~isempty(uu)
    gg  = gg+B*u1;
    soc = soc+sum((B'*aa).^2);
  end

  if soc>0
    info.ginfo = norm(gg)/(sqrt(min(eta)*hmin*soc));
  else
    info.ginfo = inf;
  end
  varargout{2} = gg;

  if nargout==3
    varargout{3} = info;
  else
    I = find(ss>0);
    len = length(I);
    AF = A.slice(I);
    eta_en = eta(1)/(1+eta*lambda*(1-theta));
    switch(info.solver)
     case 'cg'
      prec=hloss+spdiag(eta_en*sum(AF.^2,2));
      if ~isempty(uu)
        prec =prec+spdiag(eta(2)*sum(B.^2,2));
      end
      varargout{3} = struct('hloss',hloss,'AF',AF,'I',I,'n',n,'prec',prec,'B',B);
     otherwise
      if length(I)>0
        varargout{3} = hloss+eta_en*AF*AF';
      else
        varargout{3} = hloss;
      end
      if ~isempty(uu)
        varargout{3} = varargout{3}+eta(2)*B*B';
      end
    end
    varargout{4} = info;
  end
end

