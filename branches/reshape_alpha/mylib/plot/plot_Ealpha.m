function plot_Ealpha(env,graph,status,DAL,bases,EbasisWeight,...
                     titleAddMemo,varargin)
%%
%% USAGE)
%% Example:
% plot_Ealpha(env,graph,status,DAL,bases,EbasisWeight,'titleAddMemo')
% plot_Ealpha(env,graph,status,DAL,bases,EbasisWeight,'titleAddMemo',regFacIndexIn)
%%
%% regFacIndexIn: e.g. o [1] [1:3] , x [1 3] ++bug
global rootdir_

%% return connection intensity 'RFIntensity' if ('DEBUG' >1 ).
DEBUG = status.DEBUG.level;
%%
regFacLen = length(DAL.regFac);
regFacIndexIn = (1:regFacLen);

IN = 7;
if nargin >= IN +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);
  %  regFacIndexIn(regFacLen) =  varargin{ 1};
else
  FROM = 1;
end

if 1 == 1
  LIM = graph.PLOT_MAX_NUM_OF_NEURO;
else
  LIM = 10;
end
cnum = env.cnum;
if isfield(env,'hnum') && ~isnan(env.hnum)
  hnum = env.hnum;
else
  env.hnum = 100;
  hnum = 100;
end
if isfield(env,'hwind') && ~isnan(env.hwind)
  hwind = env.hwind;
else
  env.hwind = 1;
  hwind = 1;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end
%%% ==< reconstruct response func >==

if (nargin == IN + 1) %++bug %get only Ealpha{regFacIndexIn}, Ealpha{others}=[]
  [Ealpha,graph] = reconstruct_Ealpha(env,graph,DAL,bases,EbasisWeight,regFacIndexIn(regFacLen));
else
  [Ealpha,graph] = reconstruct_Ealpha(env,graph,DAL,bases,EbasisWeight);
end
%%% ==</reconstruct response func >==

if strcmp('set_xticks','set_xticks')
  Lnum = 2; % Lnum: the number of x label
  dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
  ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum+1);
  for i1 = 1:(Lnum+1)
    TIMEL{i1} = (i1-1)*ddh;
  end
end

%  XSIZE = 2;
XSIZE = 1; % stretch 'xlim' by XSIZE times.
if strcmp('set_range','set_range') && (graph.prm.auto ~= 1)
  diag_Yrange = graph.prm.diag_Yrange;
  Yrange      = graph.prm.Yrange;
  zeroFlag = 0;
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
else % you'd better collect max and min range of response functions
     % in advance.
  diag_Yrange = graph.prm.diag_Yrange_auto;
  Yrange      = graph.prm.Yrange_auto;     
  newYrange = [ min(Yrange(1),diag_Yrange(1)) max(Yrange(2),diag_Yrange(2)) ];
  %    newYrange = round([ Yrange(1) diag_Yrange(2) ]*100)/100;
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
  %% ==< set title >==
  regFacIndex = regFacIndexIn(i0);
  title = sprintf('regFac=%9.4f frame=%6d',DAL.regFac(regFacIndex),DAL.Drow );
  title = strcat(title,[', xrange:',sprintf('[%2.1d,%4.3f](sec)',TIMEL{1},TIMEL{Lnum+1})]);
  titleYrange = '';
  if  LIM >= 10
    titleYrange = sprintf(', yrange:[%0.2f,%0.2f]',newYrange(1),newYrange(2));
  end
  if LIM <=5
    titleYrange = sprintf('\nyrange:[%0.2f,%0.2f]',newYrange(1),newYrange(2));  
  end
  title = strcat(title,titleYrange);
  title = strcat(title,'  ');
  title = strcat(title,titleAddMemo);
  %% ==</set title >==

  %%% ===== PLOT alpha ===== START =====
  if (cnum > LIM )
    prm = struct('regFacIndex',regFacIndex,...
                 'xtickwidth',dh,...
                 'yrange',newYrange,'zeroFlag',zeroFlag);
    prm.xlabel = TIMEL;
    prm.title = title;
    fignum = ceil(cnum/LIM);
    shift = 1/fignum;
    for Fdim1 = 1:fignum
      for Fdim2 = 1:fignum
        plot_Ealpha_subplot(env,graph,Fdim1,Fdim2,LIM,Ealpha,prm,...
                            EbasisWeight,bases);
        set(gcf, 'menubar','none','Color','White','units','normalized',...
                 'outerposition',[(Fdim2-1)*shift,(fignum-Fdim1)*shift,shift,shift])
      end
    end
  else
    figure;
    i2to = 1; % cell to
    i3from = 1; % cell from
    pos = [ .5 (cnum) 0 0 ]/(cnum+2);
    for i1 = 1:cnum*cnum % subplot select
      %% <  subplot background color >
      if RFIntensity(i2to,i3from,i0) > 0
        if DEBUG == 1
          fprintf(1,'+%5.2f: r ,',RFIntensity(i2to,i3from,i0))
        end
        heat = [1 0.5 0.5];
      elseif RFIntensity(i2to,i3from,i0) < 0
        if DEBUG == 1
          fprintf(1,'+%5.2f: b ,',RFIntensity(i2to,i3from,i0))
        end
        heat = [0.5 0.5 1];
      else
        if DEBUG == 1
          fprintf(1,'+%5.2f: w ,',RFIntensity(i2to,i3from,i0))
        end
        heat = [1 1 1];
      end
      if DEBUG == 1
        fprintf(1,'%2d<-%2d | ',i2to,i3from);
        if i3from == cnum
          fprintf(1,'\n');
        end
      end
      %% </ subplot background color >
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
      %% </ chage color ploted according to cell type >
      if (zeroFlag == 1)
        %% plot nothing
        set(gca,'yticklabel',[]);
        zeroFlag = 0;
      else
        plot( 1:hnum, 0, 'b','LineWidth',4); % emphasize 0.
        grid on;
        if graph.prm.showWeightDistribution == 1
          for i2 = 1:cnum
            tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
                                         [bases.ihbasprs.numFrame 1]);
            plot(tmp2,'--')
          end
        end
        xlim([0,hnum*hwind*XSIZE]);  
        ylim(newYrange)
      end
      if  graph.TIGHT == 1;
        axis tight;
      end
      set(gca,'XAxisLocation','top');
      set(gca,'XTick' , 1:dh:hnum*hwind);
      set(gca,'xticklabel',[]);
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


    h = axes('Position',[0 0 1 1],'Visible','off'); 
    set(gcf,'CurrentAxes',h)
    text(.18,.95,title,'FontSize',12)
    if 1 == 0
      text(.12,.90,'Triggers')
      text(.08,.85,'Targets')
    else
      pos = [ .1 cnum ]/(cnum+2);
      text(pos(1)+.1,pos(2) +.03,'Triggers')
      text(pos(1)+.02,pos(2) -.01,'Targets')
    end

  end
end
%%% ===== PLOT alpha ===== END =====
%% write out eps file
%{
if graph.PRINT_T == 1
  print('-depsc','-tiff', [rootdir_ '/outdir/Estimated_alpha.eps'])
end
%}
