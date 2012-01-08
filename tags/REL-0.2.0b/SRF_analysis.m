function [Peak, Latency, Connectivity] = SRF_analysis( A )
[N, dum, M] = size(A);
thresh = 1e-8;
Peak = zeros( N );
Latency = zeros( N );
Connectivity = zeros( N );

for i=1:N
  for j=1:N
    y = reshape( A(i,j,:), 1, M );
    pp = y; pp( y<0 ) = 0; [mpp, mpi] = max( pp );
    pn = y; pn( y>0 ) = 0; [mpn, mni] = min( pn );
    if mpp > abs( mpn )
      Peak(i,j) = mpp;
      Latency(i,j) = mpi;
    else
      Peak(i,j) = mpn;
      Latency(i,j) = mni;
    end
    %% only return 1/0 %++bug
    %    Connectivity(i,j) = abs( Peak(i,j) > thresh )*sign(Peak(i,j));
    Connectivity(i,j) = (abs( Peak(i,j) ) > thresh )*sign(Peak(i,j));
  end
end
