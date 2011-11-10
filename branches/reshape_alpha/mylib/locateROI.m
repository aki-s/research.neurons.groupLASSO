function [my,mx] = locateROI( u, nIdx, Nx, Ny )
% Usage
% [my,mx] = roi_plot( u, nIdx, Nx, Ny )
% or
% [my,mx] = roi_plot( u, nIdx )
%
% Visualizes 2d ROIs of arbitrary forms
%  with output ROI center positions.
% You can specify a set of neuron indices  nIdx,
% for example nIdx = [1,4,5,6,10]

if nargin == 2
  [Nx,Ny,K] = size(u);
  u = reshape(u, Nx*Ny, K );
end
s1=RandStream.create('mrg32k3a');
xidx = repmat( (1:Nx)', 1,Ny );
yidx = repmat( (1:Ny) , Nx, 1 );

%parfor i=1:nnum
for i0 = 1:-0.2:0.1

C = zeros(Nx,Ny,3);
nnum = length(nIdx);
mx= zeros(1,nnum);
vx= zeros(1,nnum);
my= zeros(1,nnum);
vy= zeros(1,nnum);
v = zeros(1,nnum);
l = cell (1,nnum);

  figure;
  hold on;
  title(sprintf('thresh:%4.3f',i0));
  for i=1:nnum
    u0 = reshape( u(:,nIdx(i)), Nx, Ny );
    u0 = 2*u0/max(u0(:)); %++heuristic
    u0(u0>1)=1;
    u0(u0<i0)=0;
    mx(i) = sum( sum( u0.*xidx ) )/sum(u0(:)); % mean x
    vx(i) = sum( sum( u0.*xidx.^2 ) )/sum(u0(:))-mx(i).^2; % variance x
    my(i) = sum( sum( u0.*yidx ) )/sum(u0(:));
    vy(i) = sum( sum( u0.*yidx.^2 ) )/sum(u0(:))-my(i).^2;
    v (i) = vx(i)+vy(i);
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
%{
xlim([0 Nx]);
xlim([0 Ny]);
set(gcf,
%}
%image(1-C)
image(Nx,Ny,1-C)
%{
axis image
set(gcf,'Position', [190,416,1362,526])
%}
end
error
hold on
for i = 1:length( nIdx )
  plot(my(i), mx(i),'*','Color', l{i})
  c = 1-[1,0.8,0.8];
  if v(i)>25
    %    c=1-[1,0,0];
  end
  for j1=[-2:2]
    for j2=[-2:2]
      text( my(i)+j1/5, mx(i)+j2/5, sprintf('Ch%d',nIdx(i) ), 'Color', [1,1,1],...
            'FontSize',13,'FontWeight','bold' )
    end
  end
  text( my(i), mx(i), sprintf('Ch%d',nIdx(i) ), 'Color', c,...
        'FontSize',13,'FontWeight','bold' )
end
