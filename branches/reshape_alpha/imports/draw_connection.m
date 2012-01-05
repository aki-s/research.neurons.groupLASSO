function draw_connection( X, mx, my )
[N,dum] = size(X);
for i=1:N
  for j=1:N
    switch X(i,j)
     case 1
      h = arrow( [mx(i),my(i)], [mx(j),my(j)],'Width',2);
      c = [1,0,0];
      set(h,'FaceColor',c, 'EdgeColor',c*0.3,...
             'EdgeAlpha', 0.5,'FaceAlpha', 0.5)
%      quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'r', 'LineWidth',2)
     case -1
      h = arrow( [mx(i),my(i)], [mx(j),my(j)],'Width',2);
      c = [0,0,1];
      set(h,'FaceColor',c, 'EdgeColor',c*0.3,...
             'EdgeAlpha', 0.5,'FaceAlpha', 0.5)
%      quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'b', 'LineWidth',2)
     case 0
    end
  end
end
