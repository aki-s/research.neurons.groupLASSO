function L = calcLogLikelihood(loglambda,I)
%% 
%% Log likelihood of each neuron.
%% (Poisson distribution)
%% L: (1,1:#neuron) matrix
%L = - sum(sum( (I .* loglambda - exp(loglambda)) ,1));
L = - sum( (I .* loglambda - exp(loglambda)) ,1);


