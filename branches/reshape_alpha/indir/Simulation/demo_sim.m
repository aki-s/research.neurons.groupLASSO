clear all;

tic
use = 2000;
% Load simulated data
load data_sim_9neuron.mat;     % 9-neuron network
%% load data_sim_hidden.mat;      % 5-neuron network with hidden feedback
                               % Dimension of input data (L: length, N: number of neurons)

if strcmp('Firing_of_aki','Firing_of_aki')
  if 1 == 0
    use = 2000;
    load  ../../outdir/14-Aug-2011-start-1329/14-Aug-20111329.mat
    X = I;
  end
  if 1 == 1
    use = 20000;
    load  ../../outdir/14-Aug-2011-start-1329/14-Aug-20111329.mat
    %    load  ../../outdir/14-Aug-2011-start-1336/14-Aug-20111336.mat
    X = I;
  end
  if 1 == 0
    use = 90000;
    load  ../../outdir/14-Aug-2011-start-1329/14-Aug-20111329.mat
    %    load  ../../outdir/14-Aug-2011-start-1343/14-Aug-20111343.mat
    X = I;
  end

end
use
switch use
  case 100000
    X= X( (end+1-use):end,:);
  case 90000
    X= X( (end+1-use):end,:);
  case 20000
    X= X( (end+1-use):end,:);
  case 2000
    X= X( (end+1-use):end,:);
end

[L,N] = size(X);

% To fit GLM models with different history orders
for neuron = 1:N                            % neuron
  for ht = 2:2:10                         % history, when W=2ms
    [bhat{ht,neuron}] = glmwin(X,neuron,ht,200,2);
  end
end
disp('GLM done');
% To select a model order, calculate AIC
for neuron = 1:N
  for ht = 2:2:10
    LLK(ht,neuron) = log_likelihood_win(bhat{ht,neuron},X,ht,neuron,2); % Log-likelihood
    aic(ht,neuron) = -2*LLK(ht,neuron) + 2*(N*ht/2 + 1);                % AIC
  end
  disp('1 AIC done');
end

% To plot AIC 
for neuron = 1:N
  figure(neuron);
  plot(aic(2:2:10,neuron));
end

% Save results
save('result_sim','bhat','aic','LLK');

% Identify Granger causality
CausalTest;
toc