function Phi = evalResponseFunc( A )
%%
%%
%%
%%
[N1, N2, M] = size( A );

Phi = zeros(N1, N2);

for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    mag = sqrt( sum( b.^2 ) );
    sig = sign( sum( b(1:20) ) );
    Phi(i,c) = mag * sig;
  end
end
