function plot_Ealpha_parfor(env,graph,status,DAL,bases,EKerWeight,regFacIndex,titleIn)
%function plot_Ealpha(env,graph,Ealpha,DAL,regFacIndex,titleIn)
%%
%% USAGE)
%% Example:
% plot_Ealpha(env,graph,Ealpha,DAL,regFacIndex,'title')
%%

DEBUG = 0;
LIM = 10;

if DEBUG == 1
  title = 'DEBUG:';
end

cnum = env.cnum;
if isfield(env,'hnum') && ~isnan(env.hnum)
  hnum = env.hnum;
else
  hnum = 100;
end
if isfield(env,'hwind') && ~isnan(env.hwind)
  hwind = env.hwind;
else
  hwind = 1;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end

MAX = graph.PLOT_MAX_NUM_OF_NEURO;
%{
if MAX > LIM
  warning(['It take too much time.Not giving cell array to plot() may ' ...
           'speed up this function'])
  %plot by thining out may best answer to this problem.
end
%}
%%% == useful func ==
%kdelta = inline('n == 0'); % kronecker's delta

[Ealpha,graph] = reconstruct_Ealpha(env,graph,DAL,bases,EKerWeight);
%%% ===== PLOT alpha ===== START =====
if strcmp('set_xticks','set_xticks')
  Lnum = 2;
  dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
  ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum);
  for i1 = 1:Lnum+1
    TIMEL{i1} = (i1-1)*ddh;
  end
end

  %  XSIZE = 2;
  XSIZE = 1;
if strcmp('set_range','set_range_')
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange      = graph.prm.Yrange;
else % you'd better collect max and min range of response functions
     % in advance.
  diag_Yrange = graph.prm.diag_Yrange_auto;
  Yrange      = graph.prm.Yrange_auto;     
end
if cnum <= MAX
  figure;
  i2to = 1; % cell to
  i3from = 1; % cell from
  pos = [ .5 (cnum) 0 0 ]/(cnum+2);
  for i1 = 1:cnum*cnum % subplot select
    subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3) );
    tmp1 = Ealpha{regFacIndex}{i2to}{i3from};
    %% <  chage color ploted according to cell type >
    hold on;

    if tmp1 > 0
      plot(tmp1,'r','LineWidth',3);
    elseif tmp1 < 0
      plot(tmp1,'b','LineWidth',3);
    else           
      plot(tmp1,'k','LineWidth',3);
    end

    plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
    grid on;
    %% </ chage color ploted according to cell type >
    xlim([0,hnum*hwind*XSIZE]);  
    newYrange = round([ Yrange(1) diag_Yrange(2) ]*100)/100;
    ylim(newYrange)

    if  graph.TIGHT == 1;
      axis tight;
    end
    set(gca,'XAxisLocation','top');
    set(gca,'XTick' , 1:dh:hnum*hwind);
    if cnum > LIM
      set(gca,'xticklabel',[])
    else
      set(gca,'XTickLabel',TIMEL);
    end
    Y_LABEL = get(gca,'yTickLabel');
    set(gca,'yticklabel',[]);
    %% < from-to cell label >
    if (i2to == 1)     % When in the topmost margin.
      xlabel(i3from);
      set(gca,'XTickLabel',TIMEL);
    end
    if (i3from == 1) % When in the leftmost margin.
      ylabel(i2to); 
    set(gca,'yticklabel',Y_LABEL);
    end
    %% </ from-to cell label >

    %% < index config >
    if (i3from == cnum ) % When in the righmost margin.
      i2to = i2to +1; i3from = 0;
    end
    i3from = i3from +1;
    %% </ index config >
  end
  set(gcf,'color','white')
end

%% h: description about outer x-y axis
title = sprintf('dal%s:DAL regFac=%4d frame=%6d  ',DAL.method,DAL.regFac(regFacIndex),DAL.Drow );
if cnum > LIM
  strcat(title,TIMEL);
end
strcat(title,titleIn);
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)

if 1 == 0
  text(.12,.90,'Triggers')
  text(.08,.85,'Targets')
else
  pos = [ .1 cnum ]/(cnum+2);
  text(pos(1)+.1,pos(2) +.03,'Triggers')
  text(pos(1)+.02,pos(2) -.01,'Targets')
end
%{
xlabel(h,'Trigger')
ylabel(h,'Target')
%}

%%% ===== PLOT alpha ===== END =====
%% write out eps file
title2 = sprintf('_regFac=%04d_frame=%06d  ',DAL.regFac(regFacIndex),DAL.Drow );
if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
  fprintf(1,'%s', [status.savedirname '/Estimated_alpha' title2 '.png']);
  print('-dpng', [status.savedirname '/Estimated_alpha' title2 '.png'])
end
