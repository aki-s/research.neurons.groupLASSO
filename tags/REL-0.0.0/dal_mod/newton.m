% newton - a simple implementation of the Newton method
%
% Syntax:
%  [xx,fval,gg,status]=newton(fun, xx, ll, uu, Ac, bc, tol, finddir, info, verbose, varargin);
%
% Copyright(c) 2009 Ryota Tomioka
% This software is distributed under the MIT license. See license.txt
%
function [xx,fval,gg,status]=newton(fun, xx, ll, uu, Ac, bc, tol, ...
                                    finddir, info, verbose, varargin)

if isempty(verbose)
  verbose=0;
end

if iscell(fun)
  fcnHessMult = fun{2};
  fun = fun{1};
else
  fcnHessMult = [];
end

if isempty(finddir)
  if isempty(fcnHessMult)
    finddir = @dir_chol;
  else
    finddir = @dir_pcg;
  end
end


n = size(xx,1);
if verbose
  fprintf('n=%d tol=%g\n', n, tol);
end


cc = 0;
step = nan;
while 1
  [fval,gg,H,info]=fun(xx, info);
  
  if verbose
    fprintf('[%d] fval=%g norm(gg)=%g step=%g\n',cc, fval, norm(gg),step);
  end

  if info.ginfo<tol % || norm(gg)<1e-3
    if verbose
      fprintf('Optimization success! ginfo=%g\n',info.ginfo);
    end
    ret = 0;
    status=archive('ret','cc','info');
    break;
  end

  if isstruct(H)
    H.fcnHessMult=fcnHessMult;
  end
  
  dd = finddir(gg, H);

  [step,fval, info]=linesearch(fun, fval, xx, ll, uu, Ac, bc, dd, info, varargin{:});

  if step==0
    ret = -2;
    fprintf('[newton] max linesearch reached. ginfo=%g\n',info.ginfo);
    status=archive('ret','cc','info');
    break;
  end

  xx = xx + step*dd;
  
  cc = cc+1;
  if cc>1000
    ret = -1;
    fprintf('[newton] #iterations>1000.\n');
    status=archive('ret','cc','info');
    break;
  end
end


function dd = dir_chol(gg, H)
R = chol(H);
dd = -R\(R'\gg);

%dd = pcg(H, -gg, max(1e-6,tol*0.01));

function dd = dir_pcg(gg, Hinfo)
S=warning('off','all');
[dd,dum1,dum2]=pcg(Hinfo.fcnHessMult, -gg, 1e-2,...
                   length(gg),Hinfo.prec,[],[],Hinfo);
warning(S);
% [dd,dum1,dum2] = pcg(@(xx)fcnHessMult(xx,Hinfo), -gg, max(1e-6,tol*0.01), length(xx),Hinfo.prec);

function [step,fval, info] = linesearch(fun, fval0, xx, ll, uu, Ac, bc, dd, info, varargin)

Ip=find(dd>0);
In=find(dd<0);
step=min([1.0, 0.999*min((xx(In)-ll(In))./(-dd(In))), 0.999*min((uu(Ip)-xx(Ip))./dd(Ip))]);

xx0    = xx;

cc = 1;
while 1
  xx = xx0 + step*dd;
  
  if ~isempty(Ac)
    bineq = all(Ac*xx<=bc);
  else
    bineq = true;
  end
  
  if bineq && all(ll<=xx) && all(xx<=uu)
    [fval,info] = fun(xx, info);

    if fval<fval0
      break;
    end
  else
    % keyboard;
  end
  
  %fprintf('step=%g fval=%g (fval0=%g)\n',step, fval, fval0);
  
  step = step/2;
  cc = cc+1;
  if cc>30
    fval=fval0;
    step = 0;
    break;
  end
end
