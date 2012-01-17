function RFIntensity = evalResponseFunc3( A )
%%
%% A: response function, (cnum,cnum,histsize) 3D matrix
%%
%% notice: this fucntion is wrapper of evaluation function.
[N1, N2, M] = size( A );
RFIntensity = zeros(N1, N2); % RFIntensity: response function intensity

for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    mag = sum( b.^2 );
    j = get_idx(b,M);
    sig = sign( sum( b(1:j) ) );
    RFIntensity(i,c) = mag * sig;
  end
end

function [j] = get_idx(b,M)
sig_ = b(1);
sig_a = sign(b);
j = 1;
while ( sig_ == sig_a(j) )
  j = j +1;
  if j == M 
    break
  end
end
