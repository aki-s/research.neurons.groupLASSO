load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/23-Oct-2011-start-20_50/Aki-0000016-rec072b-0044976-020.mat')

[Pk, Lt, Cn] = SRF_analysis( Alpha );
thresh = 0.1;
N = 20;

%only return 1/0/-1
Cn = ( abs(Pk)>thresh ) .* sign(Pk);
%% omit orthogonal entry
Cn( eye(N)==1 ) = 0;
Pk( eye(N)==1 ) = 0;
Lt( eye(N)==1 ) = 0;

load('/home/shige-o/rec072b.mat')
%% load "s"
nspikes = sum( s' );
[dum, nidx] = sort( -nspikes );
%% select only N neurons.
nidx2 = nidx( 1:N );


figure
%[mx, my] = roi_plot( u(:,:,nidx2), 1:20 );
[mx, my] = plot_ROI( u(:,:,nidx2), 1:N );
set(gcf,'Position', [190,416,1362,526])
draw_connection( Cn, mx, my )

Dist = zeros(N);
for i=1:N
  for j=1:N
    Dist(i,j) = sqrt( (mx(i)-mx(j))^2+ (my(i)-my(j))^2);
  end
end
figure
subplot(1,2,1)
idx = find( abs(Cn)==1 );
plot( Dist(idx), Lt(idx), 'o' )
xlabel( 'Link distance [pixel]' )
ylabel( 'Latency [frame]' )
subplot(1,2,2)

plot( Dist(idx), Pk(idx), 'o' )
xlabel( 'Link distance [pixel]' )
ylabel( 'Link strength' )
