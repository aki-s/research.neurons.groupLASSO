% dalprgl - DAL with poisson loss and grouped L1 regularization
%
% Overview:
%  Solves the optimization problem:
%   [xx, bias] = argmin sum( zz - yy.* log(zz) ) + lambda*||xx||_G1
%      where  zz = A * xx + bias
%      || x ||_G1 = sum( sqrt( xx( Ii ).^2 ) ) )
%      (Ii is the index-set of the i-th group)
%
% Syntax:
%  [xx,bias,status]=dalprgl(xx0, bias0, A, yy, lambda, <opt>)
%
% Inputs:
%  xx0    : initial solution ([nn,1] with opt.blks or [ns nc] with
%           nc*nc=nn for nc groups of size ns)
%  bias0  : initial bias (set [] if bias term is unnecessary)
%  A      : the design matrix A ([mm,nn])
%
%
%
%  yy     : the target label vector ( 0 or +1) ([mm,1])
%  lambda : the regularization constant
%  <opt>  : list of 'fieldname1', value1, 'filedname2', value2, ...
%   blks     : vector that contains the size of the groups. 
%              sum(opt.blks)=nn. If omitted, opt.blks = [ns,..., ns]
%              and length(opt.blks)=nc, where nc is the number of groups.
%   stopcond : stopping condition, which can be
%              'pdg'  : Use relative primal dual gap (default)
%              'fval' : Use the objective function value
%           (see dal.m for other options)
% Outputs:
%  xx     : the final solution ([nn,1])
%  bias   : the final bias term (scalar)
%  status : various status values
%
% Example:
% m = 1024; n = 4096; k = round(0.04*n); A=randn(m,n);
% w0=randsparse(n,k); yy=sign(A*w0+0.01*randn(m,1));
% lambda=0.1*max(abs(A'*yy));
% [ww,bias,stat]=dallrl1(zeros(n,1), 0, A, yy, lambda);
%
% Copyright(c) 2009 Ryota Tomioka
% This software is distributed under the MIT license. See license.txt

function [ww,bias,status]=dalprgl(ww,bias, A, yy, lambda, varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt,'solver','cg',...
                     'stopcond','pdg',...
                     'blks',[]);

if ~isequal(unique(yy), [0;1])
  error('yy must be a column vector of 0''s and 1''s');
end

if isempty(opt.blks)
  opt.blks=size(ww,1)*ones(1,size(ww,2));
  ww = ww(:);
end

prob.floss    = struct('p',@loss_prp,'d',@loss_prd,'args',{{yy}});
prob.fspec    = @(ww)gl_spec(ww,opt.blks);
prob.dnorm    = @(ww)gl_dnorm(ww,opt.blks);
prob.obj      = @objdalgl;
prob.softth   = @gl_softth;
prob.stopcond = opt.stopcond;
if 1 == 0
 prob.ll = yy*0-1e5;
else
  prob.ll = -inf*ones(size(yy));
end
prob.uu = yy; % <-- y_i - alpha_1 > 0
prob.Ac       =[];
prob.bc       =[];
prob.info     = struct( 'blks', opt.blks );

if isequal(opt.solver,'cg')
  prob.hessMult = @hessMultdalgl;
end

if isequal(opt.stopcond,'fval')
  opt.feval = 1;
end

if isnumeric(A)
  A = A(:,:);
  [mm,nn]=size(A);
  At=A';
  fA = struct('times',@(x)A*x,...
              'Ttimes',@(x)At*x,...
              'slice', @(I)A(:,I));
  clear At;
elseif iscell(A)
  mm = A{3};
  nn = A{4};
  fAslice = @(I)fA(sparse(I,1:length(I),ones(length(I),1), nn, length(I)));
  fA = struct('times',A{1},...
              'Ttimes',A{2},...
              'slice',fAslice);
else
  error('A must be either numeric or cell {@(x)A*x, @(y)(A''*y), mm, nn}');
end

prob.mm       = mm;
prob.nn       = nn;

if isempty(bias)
  B = [];
else
  B = ones(mm,1);
end

[ww,bias,status]=dal(prob,ww,bias,fA,B,lambda,opt); % changed for fitting to dal ver1.05

if all(opt.blks==opt.blks(1))
  ns=opt.blks(1);
  nc=length(ww)/ns;
  ww=reshape(ww, [ns,nc]);
end
