function plot_EResFunc_parfor(env,graph,status,DAL,bases,EbasisWeight,...
                              titleAddMemo,varargin)
%%
%% USAGE)
%% Example:
% plot_EResFunc(env,graph,DAL,bases,EbasisWeight,'titleAddMemo')
% plot_EResFunc(env,graph,DAL,bases,EbasisWeight,'titleAddMemo',regFacIndexIn)
%%

DEBUG = status.DEBUG.level;
if DEBUG == 1
  title = 'DEBUG:';
end
%%
cnum = env.cnum;
if isfield(env,'hnum') && ~isnan(env.hnum)
  hnum = env.hnum;
else

  hnum = 100;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end
if isfield(env,'hwind') && ~isnan(env.hwind)
  hwind = env.hwind;
else

  hwind = 1;
end
LIM = graph.PLOT_MAX_NUM_OF_NEURO;

%%
regFacLen = DAL.regFacLen;
regFacIndexIn = (1:regFacLen);
num_argin = 7;
if nargin >= num_argin +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);

else
  FROM = 1;

end
%%% == 

if (nargin == num_argin + 1)

  [EResFunc,graph] = reconstruct_EResFunc(env,graph,DAL,bases,EbasisWeight,regFacIndexIn(regFacLen));
else
  [EResFunc,graph] = reconstruct_EResFunc(env,graph,DAL,bases,EbasisWeight);
end
%%% ===== PLOT ResFunc ===== START =====
if strcmp('set_xticks','set_xticks')
  Lnum = 2;
  dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
  ddh = dh/Hz; % convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum);
  for i1 = 1:Lnum+1
    TIMEL{i1} = (i1-1)*ddh;
  end
end

run set_graphYrange % newYrange, zeroFlag

RFIntensity = nan(cnum,cnum,regFacLen);
for i1 = FROM:regFacLen
  tmp = EResFuncCell2Mat(env,EResFunc,regFacIndexIn(regFacLen),i1);
  RFIntensity(:,:,i1) = evalResponseFunc( ResponseFuncMat2DtoMat3D(tmp(:,:,i1)) );
end

for i0 = FROM:regFacLen
  %% ==< set title >==
  regFacIndex = regFacIndexIn(i0);















  %%% ===== PLOT ResFunc ===== START =====
  if (cnum > LIM )
    prm = struct('regFacIndex',regFacIndex,...
                 'xtickwidth',dh,...
                 'yrange',newYrange,'zeroFlag',zeroFlag);
    prm.xlabel = TIMEL;
    prm.title = title;
    prm.savedirname = savedirname;

    fignum = ceil(cnum/LIM);
    shift = 1/fignum;
    for Fdim2 = 1:fignum
      for Fdim1 = 1:fignum
        plot_EResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,EResFunc,prm,...
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
      %% </ subplot background color >
      subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3),'Color',heat );
      tmp1 = EResFunc{regFacIndex}{i2to}{i3from};
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
        plot( 1:hnum, 0, 'k','LineWidth',1); % emphasize 0.
        grid on;
        if  graph.prm.showWeightDistribution == 1
          for i2 = 1:cnum
            tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
                                         [bases.ihbasprs.numFrame 1]);
            for i3 = 1:bases.ihbasprs.nbase
              bar(tmp2(:,i3));
            end
          end
        end
      end
      xlim([0,hnum*hwind*XSIZE]);  
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
title = sprintf('regFac=%09.4f frame=%6d  #%4d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
%{
if cnum > LIM
  strcat(title,TIMEL);
end
%}
strcat(title,titleAddMemo);
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


%%% ===== PLOT ResponseFunc ===== END =====
if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
  title2 = sprintf('_regFac_%09.4f_frame=%07d_N=%04d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
  %% fprintf(1,'saved figure: \n')
  fprintf(1,'%s\n', [status.savedirname '/Estimated_ResponseFunc' title2 '.png']);
  print('-dpng', [status.savedirname '/Estimated_ResponseFunc' title2 '.png'])
end