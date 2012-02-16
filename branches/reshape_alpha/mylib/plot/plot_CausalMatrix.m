function plot_CausalMatrix(A,title_,varargin)
N = size(A,1);
% $$$ if 0
% $$$   if N >18
% $$$     ResFuncHp = sprintf('%s'',''plot(j1from,i1to,''o'',''MarkerSize'',6,''LineWidth'',1)');
% $$$     ResFuncHn = sprintf('%s'',''plot(j1from,i1to,''.'',''MarkerSize'',15)');
% $$$   else
% $$$     ResFuncHp = sprintf('%s'',''plot(j1from,i1to,''o'',''MarkerSize'',6,''LineWidth'',1)');
% $$$     ResFuncHn = sprintf('%s'',''plot(j1from,i1to,''.'',''MarkerSize'',15)');
% $$$   end
% $$$ end
%%
PAPER = 1;
%%
if nargin > 2
  N1 = varargin{1};
else
  N1 = N;
end
SCALELINE=60/N1;
hold on
for j1from=1:N
  for i1to=1:N
    %    switch sign(A(i1to,j1from))
    switch A(i1to,j1from)
      case 1  % inhibitory
              %        plot(j1from,i1to,'o','MarkerSize',6,'LineWidth',1)
              %eval(ResFuncHp);
        plot(j1from,i1to,'ro','MarkerSize',4.5*SCALELINE,'LineWidth',1*SCALELINE)
      case -1 % excitatory
              %        plot(j1from,i1to,'.','MarkerSize',15)
              %        eval(ResFuncHn);
        plot(j1from,i1to,'b.','MarkerSize',15*SCALELINE)
    end
  end
end

set(gca,'YDir', 'reverse')
axis([0,N,0,N]+0.5)
if PAPER
  set(gca,'ytick',[],'xtick',[])
  set(findobj('Type','line'),'Color','k'); %decolor
  if 1 % grid on
    set(gca,'ytick',[0:N+.5],'xtick',[0:N], ...
            'yticklabel',[],'xticklabel',[], ...
            'GridLineStyle','-')
    grid on
  end
  box on
else
  set(gca,'ytick',[0:N+.5],'xtick',[0:N], ...
          'GridLineStyle','-')
  grid on
  %grid(gca,'minor')
  ylabel('To')
  xlabel('From')
  set(gcf, 'Name', title_)
end
