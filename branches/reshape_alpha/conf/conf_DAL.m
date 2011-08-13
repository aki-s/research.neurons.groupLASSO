function [DAL] = conf_DAL
choice = 1;

  switch choice
    case 0
      %      if ~isfield(opt,'display')
        opt.display = 0; %0: suppress stdout
                         %      end
    case 1
      %      if ~isfield(opt,'display')
        opt.display = 1;
        %      end
    case 2
      opt = struct();
    case 3
      %% Read dal.m for more details about parameters.
      % Don' work well.
      opt = struct( ...
          'aa',[],...
          'blks',[],...
          'tol',[],...
          'maxiter',[],...
          'eta',[],...
          'eps',[],...
          'eta_multp',[],...
          'eps_multp',[],...
          'solver',[],...
          'display',2,...
          'iter',20); % for dalprgl.m
  end

DAL.opt = opt;
DAL.div = 2; % devide regularization factor with this in loop.
DAL.speedup =0;
DAL.loop = 3;
DAL.regFac = zeros(1,DAL.loop); % DAL.regFac: regularization factor.
DAL.regFac_UserDef = 0;

if 1 == 1
  DAL.method = 'prgl'; %prgl: poisson  regression group lasso
else
  DAL.method = 'lrgl'; %lrgl: logistic regression group lasso
end
