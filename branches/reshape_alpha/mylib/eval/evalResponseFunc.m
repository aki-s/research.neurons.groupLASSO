function RFint = evalResponseFunc( A )
%%
%%
%%
%%
[N1, N2, M] = size( A );

RFint = zeros(N1, N2); % RFint: response function intensity

for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    mag = sqrt( sum( b.^2 ) );
    sig = sign( sum( b(1:20) ) );
    RFint(i,c) = mag * sig;
  end
end
