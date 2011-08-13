function plotCausalMatrix(A)
N = size(A,1);
figure
for i=1:N
for j=1:N
switch A(i,j)
case 1
plot(i,j,'o','MarkerSize',15,'LineWidth',3)
hold on
case -1
plot(i,j,'.','MarkerSize',45)
hold on
end
end
end

axis([0,N,0,N]+0.5)
set(gca, 'YDir', 'reverse')
ylabel('To')
xlabel('From')
grid on
