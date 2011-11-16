function plot_CausalMatrix(A,title)
N = size(A,1);
figure
for j1from=1:N
  for i1to=1:N
    switch A(i1to,j1from)
      case 1
        %        plot(i,j,'o','MarkerSize',15,'LineWidth',3)
        plot(j1from,i1to,'o','MarkerSize',15,'LineWidth',3)
        hold on
      case -1
        plot(j1from,i1to,'.','MarkerSize',45)
        hold on
    end
  end
end

axis([0,N,0,N]+0.5)
set(gca, 'YDir', 'reverse')
ylabel('To')
xlabel('From')
grid on

set(gcf, 'Name', title)
