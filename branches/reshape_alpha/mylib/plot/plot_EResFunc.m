function plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,...
                       titleAddMemo,varargin)
%%% It would be better to share code with plot_ResFunc()
%%
%% USAGE)
%% Example:
% plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,'titleAddMemo')
% plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,'titleAddMemo',regFacIndexIn)
%% regFacIndexIn: e.g. if [1] [1:3] o.k. , if [1 3] error.
%% return connection intensity 'RFIntensity' if ('DEBUG' >1 ).






















DEBUG = status.DEBUG.level;



LIM = graph.PLOT_MAX_NUM_OF_NEURO;
%%
cnum = env.cnum;
if isfield(env,'hnum') && ~isnan(env.hnum)
  hnum = env.hnum;
else
  env.hnum = bases.ihbasprs.numFrame;
  hnum =  bases.ihbasprs.numFrame;
end
if isfield(env,'Hz') && isfield(env.Hz,'video')
  Hz = env.Hz.video;
else
  Hz = 1000;
end
if isfield(env,'hwind') && ~isnan(env.hwind)
  hwind = env.hwind;
else
  %  env.hwind = 1; %++needless?
  hwind = 1;
end

%% select regFac to be used.
regFacLen = DAL.regFacLen;
num_argin = 7;
if nargin >= num_argin +1
  FROM =  varargin{ 1};
  regFacLen  = FROM;
else
  FROM = 1;
  regFacIndexIn = (1:regFacLen);
end
%%% ==









if (nargin == num_argin + 1) 
  %++bug %get only EResFunc{regFacIndexIn}, EResFunc{others}=[]
  [EResFunc,graph] = reconstruct_EResFunc(env,graph,DAL,bases,EbasisWeight,regFacIndexIn(regFacLen));
else
  [EResFunc,graph] = reconstruct_EResFunc(env,graph,DAL,bases,EbasisWeight);
end
%%% ==</reconstruct response func >==
run set_ResFunc_xticks
run set_graphYrange % newYrange, zeroFlag
XSIZE = 1; % obsolete







RFIntensity = nan(cnum,cnum,regFacLen);
for i1 = FROM:regFacLen
  tmp = EResFuncCell2Mat(env,EResFunc,regFacIndexIn(regFacLen),i1);
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
      subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3),'Color',heat );
      %% </ subplot background color >
      tmp1 = EResFunc{regFacIndex}{i2to}{i3from};
      %% <  chage color ploted according to cell type >
      set(gcf,'color','white')
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

      set(gca,'XTick' , 1:dh:hnum*hwind); %++bug?
      set(gca,'XAxisLocation','top');
      set(gca,'xticklabel',[]);
      Y_LABEL = get(gca,'yTickLabel');
      set(gca,'yticklabel',[]);













      if  graph.TIGHT == 1;
        axis tight;
      end
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
  %%% ===== PLOT ResFunc ===== END =====
  if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
    title2 = sprintf('_regFac_%09.4f_frame_%07d_N_%04d',DAL.regFac(i0),DAL.Drow,cnum );
    %% fprintf(1,'saved figure: \n')
    fprintf(1,'%s\n', [status.savedirname '/Estimated_ResponseFunc' title2 '.png']);
    print('-dpng', [status.savedirname '/Estimated_ResponseFunc' title2 '.png'])
  end
end
% $$$ %%% ===== PLOT ResFunc ===== END =====
% $$$ if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
% $$$   title2 = sprintf('_regFac_%09.4f_frame_%07d_N_%04d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
% $$$   %% fprintf(1,'saved figure: \n')
% $$$   fprintf(1,'%s\n', [status.savedirname '/Estimated_ResponseFunc' title2 '.png']);
% $$$   print('-dpng', [status.savedirname '/Estimated_ResponseFunc' title2 '.png'])
% $$$ end
