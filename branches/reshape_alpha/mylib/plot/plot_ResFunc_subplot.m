function plot_ResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,ResFunc,prm,...
                              varargin)
%% this is main ResFunc_subplot file.
PAPER = 1;
if 1 == 0



else
  run set_subplot_variables
  %% 
  H1 = figure;
  i2to = 1 + (Fdim1-1)*LIM; % cell to
  i3from = 1 + (Fdim2-1)*LIM; % cell from
  to = 1;
  from = 1;
  pos = [ .5 (LIM) 0 0 ]/(LIM+2);
  for i1 = 1:LIM*LIM % subplot select
    subplot('position',pos + [from -to 1 1 ]/(LIM+3) );
    if (i2to <= cnum) && (i3from <= cnum )
      tmp1 = eval(ResFuncH);
    else
      tmp1 = nan;
    end
    %% <  chage color ploted according to cell type >
    hold on;
    if tmp1 == 0
      %      zeroFlag =1;
    elseif tmp1 >= 0
      plot(tmp1,'r','LineWidth',3);
    elseif tmp1 <= 0
      plot(tmp1,'b','LineWidth',3);
    else           
      plot(tmp1,'k','LineWidth',3);
    end
    %% 0 is discriminant line, emphasize 0.
    plot( 1:hnum, 0, '-k','LineWidth',1);
    %%    grid on;
    if graph.prm.showWeightDistribution == 1 % nargin == 9
      for i2 = 1:cnum
        tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
                                     [bases.ihbasprs.numFrame 1]);
        plot(tmp2)
      end
    end
    %% </ chage color ploted according to cell type >
    set(gca,'XAxisLocation','top');
    if exist('newXrange')
      xlim(newXrange);
      set(gca,'XTick' , 1:dh:ceil(newXrange(2)));
      else
      xlim([0,XRANGE]);  
      set(gca,'XTick' , 1:dh:XRANGE);
    end
    set(gca,'xticklabel',[]);
newYrange
    ylim(newYrange)
    Y_LABEL = get(gca,'yTickLabel');
    set(gca,'yticklabel',[]);
    %% < from-to cell label >
    %% When in the topmost margin of a figure.
    if (i2to == (1 + LIM*(Fdim1-1)))&& (i3from <= cnum)  
      xlabel(i3from);
      if strcmp('ifYouLike','ifYouLike_')
        if 15 >= LIM %++bug?
          set(gca,'XTickLabel',TIMEL);
        end
      else % always show XTickLabel
        set(gca,'XTickLabel',TIMEL);
      end
    end
    %% When in the leftmost margin of a figure.
    if (i3from == (1+LIM*(Fdim2-1))) && (i2to <= cnum)
      ylabel(i2to); 
      if zeroFlag == 0 && (LIM < 10) %++bug?
        set(gca,'yticklabel',Y_LABEL);
      end
    end
    %% </ from-to cell label >

    %% < index config >
    if (i3from == LIM*Fdim2 ) % When in the righmost margin.
      i2to = i2to + 1; i3from = LIM*(Fdim2-1);
      to = to + 1; from = 0;
    end
    i3from = i3from +1;
    from = from + 1;
    %% </ index config >
  end
  set(H1,'color','white')
end

h = axes('Position',[0 0 1 1],'Visible','off'); 
set(H1,'CurrentAxes',h)

pos1 = [ .1 cnum ]/(cnum+2);
pos2 = pos1;
MUL = 1;
if LIM < 8
  pos1 = [ .1 cnum-1 ]/(cnum+2);
  pos2 = [ .2 cnum-3 ]/(cnum+2);
  MUL = 2;
end
if ~PAPER
  text(pos1(1)+.15,pos1(2) +.05,DESCRIPTION,'FontSize',12)
  text(pos2(1)+.05*MUL,pos2(2) +.02*MUL,'Triggers')
  text(pos2(1)+.02*MUL,pos2(2) -.01*MUL,'Targets')
end
if  ( graph.PRINT_T == 1 )
  print('-dpng', [savedirname,'/Estimated_ResponseFunc',...
                  prm.outname,...
                  sprintf('_%d-%d_%03d',Fdim1,Fdim2,cnum),'.png'])
  %% save as eps
  saveas(H1,sprintf('%s',[savedirname,'/Estimated_ResponseFunc',...
             prm.outname,...
             sprintf('_%d-%d_%03d.eps',Fdim1,Fdim2,cnum)]),'epsc2')
end

