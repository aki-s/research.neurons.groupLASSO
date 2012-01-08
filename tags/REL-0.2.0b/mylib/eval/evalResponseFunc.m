function RFIntensity = evalResponseFunc( A )
%%
%% A: response function, (cnum,cnum,histsize) 3D matrix
%% RFIntensity: response function intensity. [#neuron,#neuron] == size(RFIntensity)
%% notice: this fucntion is a wrapper of evaluation function.
%%

%%
METHOD = 'sqr';

switch METHOD
  case 'sqr' % best discriminant ability
    RFIntensity = evalResponseFunc0(A);
  case 'avg'
    RFIntensity = evalResponseFunc1(A);
  case 'sqr*avg'
    RFIntensity = evalResponseFunc2(A);
end
