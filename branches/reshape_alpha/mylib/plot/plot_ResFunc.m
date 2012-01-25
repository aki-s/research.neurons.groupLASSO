function plot_ResFunc(graph,env,ResFunc,...
                      title,varargin)
%%% It would be better to share code with plot_EResFunc(),plot_ResFunc_subplot()
%%
%% Usage:
%% Example:
% plot_ResFunc(graph,env,ResFunc,title,varargin)
%%
%% == format ==
%% >> ResFunc
%% suppose the num. of neruon is 'N', length of response func is 'L'.
%%
%% -- format 1 --
%% ResFunc is (cnum*hnum,cnum) 2D matrix
%%   Idx\Idx || (to #1)   (to #2)  ...  (to #N-1)  (to #N) |
%% _________ ||_________ _________ ...  _________  ________|
%% |from #1  |||  1:L  | |  1:L  | ...  |  1:L  |  |  1:L  |
%% _________ ||_________ _________ ...  _________  ________|
%%    .      ||    .                                  .    |
%%    .      ||    .                                  .    |
%%    .      ||    .                                  .    |
%% |from #N-1||    .                                  .    |
%% _________ ||_________ _________ ...  _________  ________|
%% |from #N  |||  1:L  | |  1:L  | ...  |  1:L  |  |  1:L  |
%% _________ ||_________ _________ ...  _________  ________|
%%
%% -- format 2 --
%% ResFunc is (cnum,cnum,hnum) 3D matrix
%% recommend? using 'plot_EResFunc.m' or plot_ResFuncALL(varargin)
% e.g.
% s=load('outdir/24-Dec-2011-start-20_9/Aki-0001.0000-Aki-0080000-009.mat');
num_argin = 4;
DEBUG = 0;%DEBUG = status.DEBUG.level;
run set_plot_ResFunc_variables

if nargin >= num_argin + 1
  savedirname = varargin{1};
else
  savedirname= '.';
end
if nargin >= num_argin + 2
  outname = varargin{2};
else
  outname = '';
end

%%% ===== PLOT ResFunc ===== START =====
run set_ResFunc_xticks
run set_graphYrange % newYrange, zeroFlag

%for i0 = FROM:regFacLen


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (cnum > LIM)
  prm = struct('regFacIndex',1,...
               'xtickwidth',dh,...
               'yrange',newYrange,'zeroFlag',zeroFlag);
  prm.xlabel = TIMEL;
  prm.title = title;
  prm.outname = outname;
  prm.savedirname = savedirname;

  fignum = ceil(cnum/LIM);
  shift = 1/fignum;
  %++bug: conf_user_kim.m 
  % 1-1 2-2
  % 2-1 1-2
  %
  for Fdim2 = 1:fignum
    for Fdim1 = 1:fignum
      plot_ResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,ResFunc,prm)
      %% Position fig. at natural location
      set(gcf, 'menubar','none','Color','White','units','normalized',...
               'outerposition',[(Fdim2-1)*shift,(fignum-Fdim1)*shift,shift,shift])
    end
  end
else
  figure;
  %%==< manipulate 2D/3D ResFunc seemlessly >==
  if size(ResFunc,3) > 1 
    ResFuncH = sprintf('%s','shiftdim(ResFunc(i1to,i2from,:),2)');
  else
    ResFuncH = sprintf('%s','ResFunc((1:hnum)+(i2from-1)*hnum,i1to)');
  end
  %%==</manipulate 2D/3D ResFunc seemlessly >==

  pos = [ .5 (cnum) 0 0 ]/(cnum+2);
  for i1to = 1:cnum %++parallel
    for i2from = 1:cnum;
      %% subplot() delete existing Axes property.
      subplot('position',pos + [i2from -i1to 1 1 ]/(cnum+3) );
      %% <  subplot background color >



















      %% </  subplot background color >
      tmp1 = eval(ResFuncH);
      %% <  chage color ploted according to cell type >
      set(gcf,'color','white')
      hold on;
      if tmp1 == 0
        zeroFlag = 1;
      elseif tmp1 >= 0
        plot( 1:hnum, tmp1,'r','LineWidth',3);
      elseif tmp1 <= 0         
        plot( 1:hnum, tmp1,'b','LineWidth',3);
      else
        plot( 1:hnum, tmp1,'k','LineWidth',3);
      end
      %% </ chage color ploted according to cell type >
      if (zeroFlag == 1)
        %  plot(nan);
        %        if (i1to ~= 1) && (i2from ~= 1)  % When in the topmost or leftmost margin.
        %        set(gca,'xticklabel',[]);
        set(gca,'yticklabel',[]);
        %        end
        zeroFlag = 0;
      else
        plot( 1:hnum, 0, 'k','LineWidth',1); % emphasize 0.
        grid on;














        %% </ chage color ploted according to cell type >
        xlim([0,hnum*hwind*XSIZE]);
        set(gca,'XTick' , 1:dh:hnum); %++bug?
        set(gca,'XAxisLocation','top');
        set(gca,'xticklabel',[]);
        Y_LABEL = get(gca,'yTickLabel');

        if strcmp('sameYrange','sameYrange')
          ylim(newYrange);
          if zeroFlag == 1
            set(gca,'yticklabel',Y_LABEL);
          end
        else
          if i1to == i2from
            ylim(diag_Yrange)
          else
            ylim(Yrange);
          end
        end
      end
      if  graph.TIGHT == 1;
        axis tight;
      end
      %% < from-to cell label >
      if (i1to == 1)     % When in the topmost margin.
        xlabel(i2from);
        set(gca,'XTickLabel',TIMEL);
      end
      if (i2from == 1) % When in the leftmost margin.
        ylabel(i1to);



      end
      %% </ from-to cell label >





    end
  end

  %% h: description about outer x-y axis
  h = axes('Position',[0 0 1 1],'Visible','off'); 
  set(gcf,'CurrentAxes',h)
  text(.4,.95,title,'FontSize',12,'LineWidth',4)




  %%% ===== PLOT ResFunc ===== END =====
  if  ( graph.PRINT_T == 1 ) ||  ( matlabpool('size') > 0 )
    print('-dpng', [savedirname '/' outname '.png'])
  end

end
%end
