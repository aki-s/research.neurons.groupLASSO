function L = calcLikelihood(loglambda,I)
%% 
%% likelihood of each neuron.
%% L: (1,1:#neuron) matrix
%L = - sum(sum( (I .* loglambda - exp(loglambda)) ,1));
L = - sum( (I .* loglambda - exp(loglambda)) ,1);


