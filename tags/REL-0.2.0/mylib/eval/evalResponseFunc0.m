function RFIntensity = evalResponseFunc0( A )
%%
%% A: response function, (cnum,cnum,histsize) 3D matrix
%%
%% notice: this fucntion is wrapper of evaluation function.
[N1, N2, M] = size( A );
RFIntensity = zeros(N1, N2); % RFIntensity: response function intensity

for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    mag = sqrt( sum( b.^2 ) );
    sig = sign( sum( b(1:20) ) );
    RFIntensity(i,c) = mag * sig;
  end
end
