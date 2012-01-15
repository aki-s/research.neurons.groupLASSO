function plot_EResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,ResFunc,prm,...
                             varargin)
%%% WARNING: DON'T EDIT THIS FILE. THIS FUNC IS obsolete.
if 1 == 1
plot_ResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,ResFunc,prm,...
                              varargin)
else
% $$$ run set_subplot_variables
% $$$ %% 
% $$$   figure;
% $$$   i2to = 1 + (Fdim1-1)*LIM; % cell to
% $$$   i3from = 1 + (Fdim2-1)*LIM; % cell from
% $$$   to = 1;
% $$$   from = 1;
% $$$   pos = [ .5 (LIM) 0 0 ]/(LIM+2);
% $$$   for i1 = 1:LIM*LIM % subplot select
% $$$     subplot('position',pos + [from -to 1 1 ]/(LIM+3) );
% $$$     if (i2to <= cnum) && (i3from <= cnum )
% $$$       tmp1 = eval(ResFuncH);
% $$$     else
% $$$       tmp1 = nan;
% $$$     end
% $$$     %% <  chage color ploted according to cell type >
% $$$     hold on;
% $$$     if tmp1 > 0
% $$$       plot(tmp1,'r','LineWidth',3);
% $$$     elseif tmp1 < 0
% $$$       plot(tmp1,'b','LineWidth',3);
% $$$     else           
% $$$       plot(tmp1,'k','LineWidth',3);
% $$$     end
% $$$     %% 0 is discriminant line, emphasize 0.
% $$$     plot( 1:hnum, 0, 'k','LineWidth',1);
% $$$     grid on;
% $$$     if graph.prm.showWeightDistribution == 1
% $$$       for i2 = 1:cnum
% $$$         tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
% $$$                                      [bases.ihbasprs.numFrame 1]);
% $$$         plot(tmp2)
% $$$       end
% $$$     end
% $$$     %% </ chage color ploted according to cell type >
% $$$     %{
% $$$     if  graph.TIGHT == 1;
% $$$       axis tight;
% $$$     end
% $$$     %}
% $$$     xlim([0,XRANGE]);  
% $$$     set(gca,'XAxisLocation','top');
% $$$     set(gca,'XTick' , 1:dh:XRANGE);
% $$$     set(gca,'xticklabel',[]);
% $$$     ylim(newYrange)
% $$$     Y_LABEL = get(gca,'yTickLabel');
% $$$     set(gca,'yticklabel',[]);
% $$$     %% < from-to cell label >
% $$$     %% When in the topmost margin of a figure.
% $$$     if (i2to == (1 + LIM*(Fdim1-1)))&& (i3from <= cnum)  
% $$$       xlabel(i3from);
% $$$       if strcmp('ifYouLike','ifYouLike_')
% $$$         if 15 >= LIM %++bug?
% $$$           set(gca,'XTickLabel',TIMEL);
% $$$         end
% $$$       else % always show XTickLabel
% $$$         set(gca,'XTickLabel',TIMEL);
% $$$       end
% $$$     end
% $$$     %% When in the leftmost margin of a figure.
% $$$     if (i3from == (1+LIM*(Fdim2-1))) && (i2to <= cnum)
% $$$       ylabel(i2to); 
% $$$       if zeroFlag == 0 && (LIM < 10)
% $$$         set(gca,'yticklabel',Y_LABEL);
% $$$       end
% $$$     end
% $$$     %% </ from-to cell label >
% $$$ 
% $$$     %% < index config >
% $$$     if (i3from == LIM*Fdim2 ) % When in the righmost margin.
% $$$       i2to = i2to + 1; i3from = LIM*(Fdim2-1);
% $$$       to = to + 1; from = 0;
% $$$     end
% $$$     i3from = i3from +1;
% $$$     from = from + 1;
% $$$     %% </ index config >
% $$$   end
% $$$   set(gcf,'color','white')
end

% $$$ h = axes('Position',[0 0 1 1],'Visible','off'); 
% $$$ set(gcf,'CurrentAxes',h)
% $$$ 
% $$$ pos1 = [ .1 cnum ]/(cnum+2);
% $$$ pos2 = pos1;
% $$$ MUL = 1;
% $$$ if LIM < 8
% $$$   pos1 = [ .1 cnum-1 ]/(cnum+2);
% $$$   pos2 = [ .2 cnum-3 ]/(cnum+2);
% $$$   MUL = 2;
% $$$ end
% $$$ text(pos1(1)+.15,pos1(2) +.05,DESCRIPTION,'FontSize',12)
% $$$ text(pos2(1)+.05*MUL,pos2(2) +.02*MUL,'Triggers')
% $$$ text(pos2(1)+.02*MUL,pos2(2) -.01*MUL,'Targets')
% $$$ 
% $$$ if  ( graph.PRINT_T == 1 )
% $$$   print('-dpng', [savedirname,'/Estimated_ResponseFunc',...
% $$$                   sprintf('_%d-%d_%03d',Fdim1,Fdim2,cnum),'.png'])
% $$$ end
