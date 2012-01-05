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
w = [1,0,0.8,0,0,0]'* (log(3/7));
%w = w(1:3);x=x(1:3,:);
%w = w(1);x=x(1,:);
bias_org = log(7);
z_org =  w' * x + bias_org;
lambda = exp(z_org);
py = exp( -lambda + log(lambda) );
y = ( rand(size(py))-py<0 ); y = sparse(y);
figure 
subplot( 1,2,1)
plot( py )
ylabel('P(y)')
ax = axis;

ww0 = w; bias0 = bias_org;
lambda = 10;
switch 'poissonGL'
 case 'poisson'
   [ww, bias, status] = dalprl1( ww0, bias0, x', y', lambda );
   z =  ww' * x + bias;
   lambda_est = exp(z);
   py_est = exp( -lambda_est + log(lambda_est) );
 case 'logistic'
  [ww, bias, status] = dallrl1( ww0, bias0, x', y'*2-1, lambda );
   z = ww' * x + bias;
   py_est = 1-1./(1+exp(z));
 case 'poissonGL'
   [ww, bias, status] = dalprgl( ww0, bias0, x', y', lambda,...
       'blks',[3,3]);
   ww = ww(:);
   z =  ww' * x + bias;
   lambda_est = exp(z);
   py_est = exp( -lambda_est + log(lambda_est) );
 case 'logisticGL'
  [ww, bias, status] = dallrgl( ww0, bias0, x', y'*2-1, lambda,...
      'blks',[3,3]);
   ww = ww(:);
   z = ww' * x + bias;
   py_est = 1-1./(1+exp(z));
end
subplot( 1,2,2)
plot( py_est )
ylabel('Estimated P(y)')
axis(ax);
