function RFIntensity = evalResponseFunc( A )
%%
%% A: response function, (cnum,cnum,histsize) 3D matrix
%%
%% notice: this fucntion is a wrapper of evaluation function.
%%

%%
METHOD = '1';

switch METHOD
  case '0'
    RFIntensity = evalResponseFunc0(A);
  case '1'
    RFIntensity = evalResponseFunc1(A);
end
