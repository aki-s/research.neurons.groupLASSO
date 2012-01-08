function RFIntensity = evalResponseFunc1( A )
%%
%% A: response function, (cnum,cnum,histsize) 3D matrix
%%
%%
[N1, N2, M] = size( A );
RFIntensity = zeros(N1, N2); % RFIntensity: response function intensity

for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    mag = sum(b);
    sig = sign( sum( b(1:20) ) );
    RFIntensity(i,c) = sig *mag;
  end
end
