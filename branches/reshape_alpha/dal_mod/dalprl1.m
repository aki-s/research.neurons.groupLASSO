% dalprl1 - DAL with poisson loss and the L1 regularization
%
% Overview:
%  Solves the optimization problem:
%   [xx, bias] = argmin sum( zz - yy.* log(zz) ) + lambda*||xx||_1
%      where  zz = A * xx + bias
% Syntax:
%  [xx,bias,status]=dalprl1(xx0, bias0, A, yy, lambda, <opt>)
%
% Inputs:
%  xx0    : initial solution ([nn,1])
%  bias0  : initial bias (set [] if bias term is unnecessary)
%  A      : the design matrix A ([mm,nn])
%  yy     : the target label vector ( 0 or +1) ([mm,1])
%  lambda : the regularization constant
%  <opt>  : list of 'fieldname1', value1, 'filedname2', value2, ...
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

function [ww,bias,status]=dalprl1(ww,bias, A, yy, lambda, varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt,'solver','cg',...
                     'stopcond','pdg');
%--
%opt=set_defaults(opt,'solver','cg',...
%                     'stopcond','fval');

%--


prob.floss    = struct('p',@loss_prp,'d',@loss_prd,'args',{{yy}});
prob.fspec    = @(xx)abs(xx);
prob.dnorm    = @(vv)max(abs(vv));
prob.obj      = @objdall1;
prob.softth   = @l1_softth;
prob.stopcond = opt.stopcond;
prob.ll = -inf*ones(size(yy)); %prob.ll = yy*0-1e5;
prob.uu = yy; % <-- y_i - alpha_1 > 0
prob.Ac       =[];
prob.bc       =[];
prob.info     =[];

if isequal(opt.solver,'cg')
  prob.hessMult = @hessMultdall1;
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

