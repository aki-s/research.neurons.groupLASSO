function plot_Ealpha_parfor(env,graph,status,DAL,bases,EbasisWeight,...
                            titleIn,varargin)
%%
%% USAGE)
%% Example:
% plot_Ealpha(env,graph,DAL,bases,EbasisWeight,'titleAddMemo')
% plot_Ealpha(env,graph,DAL,bases,EbasisWeight,'titleAddMemo',regFacIndexIn)
%%

DEBUG = status.DEBUG.level;
if DEBUG == 1
  title = 'DEBUG:';
end
%myColor = graph.prm.myColor;
%%<copy>
regFacLen = length(DAL.regFac);
regFacIndexIn = (1:regFacLen);

IN = 7;
if nargin >= IN +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);
else
  FROM = 1;
end
%%</copy>

if 1 == 1
  LIM = graph.PLOT_MAX_NUM_OF_NEURO;
else
  LIM = 10;
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

%%% == useful func ==
if (nargin == IN + 1) %++bug %get only Ealpha{regFacIndexIn},
                      %Ealpha{others}=[]
  [Ealpha,graph] = reconstruct_Ealpha(env,graph,DAL,bases,EbasisWeight,regFacIndexIn(regFacLen));
else
[Ealpha,graph] = reconstruct_Ealpha(env,graph,DAL,bases,EbasisWeight);
end
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
  zeroFlag = 0;
else % you'd better collect max and min range of response functions
     % in advance.
  diag_Yrange = graph.prm.diag_Yrange_auto;
  Yrange      = graph.prm.Yrange_auto; 
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
  if newYrange == 0
    newYrange = [-0.1 0.1 ];
    zeroFlag = 1;
  else
    zeroFlag = 0;
  end
end
RFIntensity = nan(cnum,cnum,regFacLen);
for i1 = FROM:regFacLen
  tmp = EalphaCell2Mat(env,Ealpha,regFacIndexIn(regFacLen),i1);
  RFIntensity(:,:,i1) = evalResponseFunc( ResponseFuncMat2DtoMat3D(tmp(:,:,i1)) );
end

for i0 = FROM:regFacLen
  regFacIndex = regFacIndexIn(i0);
if (cnum > LIM )
  warning('DEBUG:notice','too much of neurons to be plotted.');
  %%plot_Ealpha_subplot()
else
  figure;
  i2to = 1; % cell to
  i3from = 1; % cell from
  pos = [ .5 (cnum) 0 0 ]/(cnum+2);
  for i1 = 1:cnum*cnum % subplot select
    if RFIntensity(i2to,i3from,i0) > 0
      if DEBUG == 1
        fprintf(1,'%5.2f: r ,',RFIntensity(i2to,i3from,i0))
      end
      heat = [1 0.5 0.5];
    elseif RFIntensity(i2to,i3from,i0) < 0
      if DEBUG == 1
        fprintf(1,'%5.2f: b ,',RFIntensity(i2to,i3from,i0))
      end
      heat = [0.5 0.5 1];
    else
      if DEBUG == 1
        fprintf(1,'%5.2f: w ,',RFIntensity(i2to,i3from,i0))
      end
      heat = [1 1 1];
    end
    if DEBUG == 1
      fprintf(1,'%2d<-%2d | ',i2to,i3from);
      if i3from == cnum
        fprintf(1,'\n');
      end
    end
    subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3),'Color',heat );
    tmp1 = Ealpha{regFacIndex}{i2to}{i3from};
    %% <  chage color ploted according to cell type >
    hold on;
    if tmp1 == 0
      zeroFlag = 1;
    elseif tmp1 > 0
      plot(tmp1,'r','LineWidth',3);
    elseif tmp1 < 0
      plot(tmp1,'b','LineWidth',3);
    else           
      plot(tmp1,'k','LineWidth',3);
    end

    if (zeroFlag == 1)
      set(gca,'yticklabel',[]);
      zeroFlag = 0;
    else
      plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
      grid on;
      if  graph.prm.showWeightDistribution == 1
        for i2 = 1:cnum
          tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
                                       [bases.ihbasprs.NumFrame 1]);
          for i3 = 1:bases.ihbasprs.nbase
            bar(tmp2(:,i3));
          end
        end
      end
    end
    %% </ chage color ploted according to cell type >
    xlim([0,hnum*hwind*XSIZE]);  
    %{
    newYrange = round([ Yrange(1) diag_Yrange(2) ]*100)/100;
    %}
    ylim(newYrange)

    if  graph.TIGHT == 1;
      axis tight;
    end
    set(gca,'XAxisLocation','top');
    set(gca,'XTick' , 1:dh:hnum*hwind);
    set(gca,'xticklabel',[])
    Y_LABEL = get(gca,'yTickLabel');
    set(gca,'yticklabel',[]);
    %% < from-to cell label >
    if (i2to == 1)     % When in the topmost margin.
      xlabel(i3from);
      set(gca,'XTickLabel',TIMEL);
    end
    if (i3from == 1) % When in the leftmost margin.
      ylabel(i2to);
      if zeroFlag == 0
        set(gca,'yticklabel',Y_LABEL);
      end
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
end
%% h: description about outer x-y axis
title = sprintf('regFac=%4d frame=%6d  #%4d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
%{
if cnum > LIM
  strcat(title,TIMEL);
end
%}
strcat(title,titleIn);
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)
text(.2,.95,title,'FontSize',12)

if 1 == 0
  text(.12,.90,'Triggers')
  text(.08,.85,'Targets')
else
  pos = [ .1 cnum ]/(cnum+2);
  text(pos(1)+.02,pos(2) +.03,'Triggers')
  text(pos(1)+.01,pos(2) -.00,'Targets')
end
%{
xlabel(h,'Trigger')
ylabel(h,'Target')
%}

%%% ===== PLOT alpha ===== END =====
%% write out eps file
if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
  title2 = sprintf('_regFac=%07d_frame=%07d_N=%04d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
  %% fprintf(1,'saved figure: \n')
  fprintf(1,'%s\n', [status.savedirname '/Estimated_alpha' title2 '.png']);
  print('-dpng', [status.savedirname '/Estimated_alpha' title2 '.png'])
end
