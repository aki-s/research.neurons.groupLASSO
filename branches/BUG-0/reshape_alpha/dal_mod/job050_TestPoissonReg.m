DESCRIBE = 1;
N = 20000;
t = 1:N;
mu = [1000, 2500, 5000];
x = [];
for i=1:6
  if i<=3
    x0 = exp( -(t-mu(i)).^2/2/500^2 )/sqrt( 2*pi)/500;
  else
    x0 = rand(1,N)*1;
  end
  x0 = x0 / max(x0);
  x = [x;x0];
end
%% w[6,1]
%{
w = [1,0,0.8,0,0,0]'* (log(3/7)); % log(3/7) ~ -0.8473
                                  %w = w(1:3);x=x(1:3,:);
                                  %w = w(1);x=x(1,:);
%}
bias_org = log(7); % ~ 1.9459
w = zeros(6,1);
%% z_org[1,20000]
z_org =  w' * x + bias_org;
%% lambda[1,2000]
lambda = exp(z_org);
py = exp( -lambda + log(lambda) );
y = ( rand(size(py))-py<0 ); y = sparse(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if DESCRIBE == 1
  figure;
  title('generation of ture values');
  plot(1:N,y,'m',1:N,py,'y',1:N,log(py),'r',1:N,lambda,'b',1:N,z_org, ...
       'g')
  legend('y','py','log(py)','lambda','z\_org');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ww0 = w; bias0 = bias_org;
DALlambda = 10;
switch 'poisson'
  case 'poisson'
    %% x[6,20000], y[1,20000]
    [ww, bias, status] = dalprl1( ww0, bias0, x', y', DALlambda );
    z =  ww' * x + bias;
    lambda_est = exp(z);
    py_est = exp( -lambda_est + log(lambda_est) );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if DESCRIBE == 1
      figure;
      plot(1:N,z_org,'r',1:N,bias_org,'m',1:N,z,'k',1:N,bias,'b');
      hleg1 = legend('z\_org','bias\_org','z','bias');
      % set(hleg1,'Interpreter','none')

      kidhleg1=get(hleg1,'Children');
      htxt=kidhleg1(strcmp(get(kidhleg1,'Type'),'text'));
      set(htxt,{'Color'},{'b';'k';'m';'r'});

      figure;
      plot(1:N,py,'r',1:N,py_est,'b')
      legend('py','py\_est')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'logistic'
    [ww, bias, status] = dallrl1( ww0, bias0, x', y'*2-1, DALlambda );
    z = ww' * x + bias;
    py_est = 1-1./(1+exp(z));
end

if strcmp('on','off')
  figure;
  subplot( 1,2,1)
  plot( py )
  ylabel('P(y)')
  ax = axis;

  subplot( 1,2,2)
  plot( py_est )
  ylabel('Estimated P(y)')
  axis(ax);
end