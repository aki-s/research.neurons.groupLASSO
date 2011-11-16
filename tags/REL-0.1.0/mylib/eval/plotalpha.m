function plotalpha( a )

[N1, N2, M] = size( a );
for i=1:N1
    for j=1:N2
        subplot(N1, N2, (i-1)*N2+j )
        b = reshape( a(i,j,:), 1, M );
        plot( [0,M], [0,0], 'k--');
        hold on
        if abs( sum(b) ) < 0.1
            stl = 'k-';
        else if sum(b) > 0
                stl = 'r-';
            else
                stl = 'b-';
            end
        end
        plot( b, stl ,'LineWidth', 2 )
        xlim( [0,M] )
        ylim( [-1,1]*1.5 )
        if i==N1
        else
            set(gca,'XTick',[])
        end
        if i==1
            title( sprintf('%d', j ) )
        end
        if j==1
            ylabel( sprintf('%d', i ) )
        end
    end
end
set( gcf, 'Color', 'White' )


