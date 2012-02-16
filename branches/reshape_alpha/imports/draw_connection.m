function draw_connection( X, mx, my )
[N] = size(X,1);
X(logical(eye(N))) = 0; % omit drawing self connection.
ALPHA_arrow = 1;
EDGE_C = 0.5;
LINEWIDTH = 1;
for i=1:N
  for j=1:N
    switch X(i,j)
     case 1
       %% [from], [to]
      if 1
      h = arrow( [mx(j),my(j)], [mx(i),my(i)] ,'Width',LINEWIDTH);
      c = [1,0,0];
      set(h,'FaceColor',c, 'EdgeColor',c*EDGE_C,...
             'EdgeAlpha', ALPHA_arrow,'FaceAlpha', ALPHA_arrow)
      end
      %% more thick color
      % quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'r', 'LineWidth',LINEWIDTH)
     case -1
      if 1
      h = arrow( [mx(j),my(j)], [mx(i),my(i)] ,'Width',LINEWIDTH);
      c = [0,0,1];
      set(h,'FaceColor',c, 'EdgeColor',c*EDGE_C,...
             'EdgeAlpha', ALPHA_arrow,'FaceAlpha', ALPHA_arrow)
      end
      %% more thick color
      %quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'b', 'LineWidth',LINEWIDTH)
     case 0

% $$$      case 1
% $$$        %% [from], [to]
% $$$       h = arrow( [mx(j),my(j)], [mx(i),my(i)] ,'Width',2);
% $$$       c = [1,0,0];
% $$$       set(h,'FaceColor',c, 'EdgeColor',c*0.3,...
% $$$              'EdgeAlpha', 0.5,'FaceAlpha', 0.5)
% $$$       %% more thick color
% $$$       %      quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'r', 'LineWidth',2)
% $$$      case -1
% $$$       h = arrow( [mx(j),my(j)], [mx(i),my(i)] ,'Width',2);
% $$$       c = [0,0,1];
% $$$       set(h,'FaceColor',c, 'EdgeColor',c*0.3,...
% $$$              'EdgeAlpha', 0.5,'FaceAlpha', 0.5)
% $$$       %% more thick color
% $$$       %      quiver( mx(i), my(i), mx(j)-mx(i), my(j)-my(i),'b', 'LineWidth',2)
% $$$      case 0

    end
  end
end
