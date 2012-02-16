function [my,mx] = plot_ROI( u, j0, Nx, Ny )
% Usage
% [my,mx] = roi_plot( u, j0, Nx, Ny )
% or
% [my,mx] = roi_plot( u, j0 )
%
% Visualizes 2d ROIs of arbitrary forms
%  with output ROI center positions.
% You can specify a set of neuron indices  j0,
% for example j0 = [1,4,5,6,10]

PAPER =1;
if nargin == 2
  [Nx,Ny,K] = size(u);
  u = reshape(u, Nx*Ny, K );
end

C = zeros(Nx,Ny,3);
xidx = repmat( (1:Nx)', 1,Ny );
yidx = repmat( (1:Ny) , Nx, 1 );


s1=RandStream.create('mrg32k3a');

for i=1:length(j0)
  u0 = reshape( u(:,j0(i)), Nx, Ny );
  u0 = 2*u0/max(max(u0(:)),1);
  u0(u0>1)=1;
  u0(u0<0.4)=0;
  mx(i) = sum( sum( u0.*xidx ) )/sum(u0(:));
  vx(i) = sum( sum( u0.*xidx.^2 ) )/sum(u0(:))-mx(i).^2;
  my(i) = sum( sum( u0.*yidx ) )/sum(u0(:));
  vy(i) = sum( sum( u0.*yidx.^2 ) )/sum(u0(:))-my(i).^2;
  v(i) = vx(i)+vy(i);
  while 1
    l{i} = rand(s1,1,3);
    if max(l{i})>0.7
      break
    end
  end
  for col = 1:3  
    C(:,:,col) = C(:,:,col) + u0*l{i}(col);
  end
end
C( C>1 )=1;
C( C<0 )=0;
image(1-C)
alpha(0.5);
hold on
for i = 1:length( j0 )
if ~PAPER
  plot(my(i), mx(i),'*','Color', l{i})
end
  c = 1-[1,0.8,0.8];
  if v(i)>25
    %    c=1-[1,0,0];
  end
  for j1=[-2:2]
    for j2=[-2:2]
      if ~PAPER
        text( my(i)+j1/5, mx(i)+j2/5, sprintf('Ch%d',j0(i) ), 'Color', [1,1,1],...
              'FontSize',13,'FontWeight','bold' )
      end
    end
  end
  if ~PAPER
    text( my(i), mx(i), sprintf('Ch%d',j0(i) ), 'Color', c,...
          'FontSize',13,'FontWeight','bold' )
  end
end
