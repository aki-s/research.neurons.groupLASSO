% run on just under directory 'Simulation'
clear all;

method ={'Kim'};
% 9-neuron network
fireIn = { 'data_sim_9neuron.mat' '../../outdir/20-Aug-2011-start-20_19/20-Aug-2011-20_19.mat'};

useFrame = [
    1000 % 1 
    2000 % 2 
    5000 % 3
    10000 % 4
    20000 % 5
    50000 % 6
    90000 % 7
    100000 % 8
           ];


for i3 = 1:length(method)
  for i2 = 1:length(fireIn)
    if i2 == 1
    load(fireIn{i2},'X');
    else
    load(fireIn{i2},'I');
      X = I;
    end
    fire = regexprep(fireIn(i2),'((.*/)|)(.*)(.mat)','$2');
    for i1 = 1: length(useFrame)
      % Dimension of input data (L: length, N: number of neurons)
      if strcmp('test','test')      
        fprintf(1,'\n\n\t%s == Frame using:%7d ==\n\n',cell2mat(fire),useFrame(i1))      
      else
        fprintf(1,'\n\n\t\t\t == Frame using:%7d ==\n\n',useFrame(i1))
      end
      tmpX= X( (end+1-useFrame(i1)):end,:);

      [L,N] = size(tmpX);

      % To fit GLM models with different history orders
      for neuron = 1:N                            % neuron
        for ht = 2:2:10                         % history, when W=2ms
          [bhat{ht,neuron}] = glmwin(tmpX,neuron,ht,200,2);
        end
      end
      disp('GLM done');
      % To select a model order, calculate AIC
      for neuron = 1:N
        for ht = 2:2:10
          LLK(ht,neuron) = log_likelihood_win(bhat{ht,neuron},tmpX,ht,neuron,2); % Log-likelihood
          aic(ht,neuron) = -2*LLK(ht,neuron) + 2*(N*ht/2 + 1);                % AIC
        end
        disp('1 AIC done');
      end

      % To plot AIC 
      %{
      for neuron = 1:N
        figure(neuron);
        plot(aic(2:2:10,neuron));
      end
      %}

      % Save results
      save('result_sim','bhat','aic','LLK');

      % Identify Granger causality
      CausalTest;
      fout = sprintf('%s-%s-%07d.mat',method{i3},cell2mat(fire),useFrame(i1));
      saveName = sprintf('../../outdir/check_110818/%s',fout);
      save(saveName,'Phi')
      fprintf(1,'\n\n\t\t\t == saved ''Phi'' at %s == \n\n',saveName);
    end
  end
end
