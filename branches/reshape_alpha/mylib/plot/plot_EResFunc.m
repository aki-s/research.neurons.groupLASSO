function plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,...
                       fig_memoIn,varargin)
%%
%% USAGE)
%% Example:
% plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,'fig_memoIn')
% plot_EResFunc(env,graph,status,DAL,bases,EbasisWeight,'fig_memoIn',regFacIndexIn)
%%
num_argin = 7;
PAPER = 1;
if 1
RFthresh = 1.4; %++bug:tmp
else
RFthresh = 0;
end
%%
try
  regFacLen = DAL.regFacLen;
catch err %@revision110
  regFacLen = length(DAL.regFac);
end
regFacIndexIn = (1:regFacLen);
if nargin >= num_argin +1
  FROM =  varargin{ 1};
  regFacLen  = FROM;

else
  FROM = 1;

end
if nargin >= num_argin + 2
  outname = varargin{2};
else
  outname = '';
end
if nargin >= num_argin + 3
  COLOR = varargin{3};
else
  COLOR = '';
end
%COLOR ='head_map-off'

%%% == 
if (nargin == num_argin + 1)
  [ResFunc,graph] = reconstruct_EResFunc(env.cnum,graph,DAL,bases,EbasisWeight,regFacIndexIn(regFacLen));
else
  [ResFunc,graph] = reconstruct_EResFunc(env.cnum,graph,DAL,bases,EbasisWeight);
end

DEBUG = status.DEBUG.level;
run set_plot_ResFunc_variables









%%% ===== PLOT ResFunc ===== START =====
run set_ResFunc_xticks
run set_graphXrange % newXrange
run set_graphYrange % newYrange, zeroFlag

%%==< prepare for neuron type (color) >==
RFIntensity = nan(cnum,cnum,regFacLen);
for i1 = FROM:regFacLen
  tmp = EResFuncCell2Mat(env.cnum,ResFunc,regFacIndexIn(regFacLen),i1);
  RFIntensity(:,:,i1) = evalResponseFunc( ResponseFuncMat2DtoMat3D(tmp(:,:,i1)) );
end
%%==</prepare for neuron type (color) >==

for i0 = FROM:regFacLen
  regFacIndex = regFacIndexIn(i0);
  %%% ===== PLOT ResFunc ===== START =====
  if (cnum > LIM )
    prm = struct('regFacIndex',regFacIndex,...
                 'xtickwidth',dh,...
                 'yrange',newYrange,'zeroFlag',zeroFlag);
    prm.xlabel = TIMEL;
    prm.title = fig_memoIn;
    prm.outname = outname;
    prm.savedirname = status.savedirname;

    fignum = ceil(cnum/LIM);
    shift = 1/fignum;
    %++bug: conf_user_kim.m 
    % 1-1 1-2
    % 2-1 2-2(title)
    %
    %++bug: xtick label TIMEL is not plotted
    for Fdim2 = 1:fignum
      for Fdim1 = 1:fignum
        plot_EResFunc_subplot(env,graph,Fdim1,Fdim2,LIM,ResFunc,prm,...
                              EbasisWeight,bases);
        %% Position fig. at natural location
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
      fprintf('%02d|',i1)%++bug:show progress
      %% <  subplot background color >
      if RFIntensity(i2to,i3from,i0) > RFthresh
        if DEBUG == 1
          fprintf(1,'%5.2f: r ,',RFIntensity(i2to,i3from,i0))
        end
        heat = [1 0.5 0.5]; %Excitatory
      elseif RFIntensity(i2to,i3from,i0) < - RFthresh
        if DEBUG == 1
          fprintf(1,'%5.2f: b ,',RFIntensity(i2to,i3from,i0))
        end
        heat = [0.5 0.5 1];
      else%if abs(RFIntensity(i2to,i3from,i0)) < RFthresh
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
      if isempty(COLOR)%++heat map is not saved with print(), why?
        subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3),'Color',heat );
      else
        subplot('position',pos + [i3from -i2to 1 1 ]/(cnum+3));
      end
      tmp1 = ResFunc{regFacIndex}{i2to}{i3from};
      %% <  chage line color according to cell type >
      set(gcf,'color','white')
      hold on;
      if tmp1 == 0
        zeroFlag = 1;
      elseif tmp1 >= 0
        plot(tmp1,'r','LineWidth',3);
      elseif tmp1 <= 0
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
        plot( 1:hnum*hwind, 0, '-k','LineWidth',1); % emphasize 0.
        %%        grid on;
        if  (graph.prm.showWeightDistribution == 1 ) %++slow,obsolete?
          for i2 = 1:cnum
            tmp2 = bases.ihbasis.*repmat(transpose(EbasisWeight{regFacIndex}{i2to}(:,i2)), ...
                                         [bases.ihbasprs.numFrame 1]);
            for i3 = 1:bases.ihbasprs.nbase
              bar(tmp2(:,i3));
            end
          end
        end
      end
      if exist('newXrange')
        xlim(newXrange);
        set(gca,'XTick' , 1:dh:ceil(newXrange(2)));
      else
        xlim([0,500]);  
        set(gca,'XTick' , 1:dh:hnum*hwind);
      end
      set(gca,'xticklabel',[])
      set(gca,'XAxisLocation','top');
      ylim(newYrange)
      Y_LABEL = get(gca,'yTickLabel');
      set(gca,'yticklabel',[]);
      if  graph.TIGHT == 1;
        axis tight;
      end
      %% < from-to cell label >
      if (i2to == 1) && (LIM<=30)    % When in the topmost margin.
                                     %++bug: xtick label TIMEL is not plotted
        xlabel(i3from);
        if exist('newXrange')
          set(gca,'XTickLabel',sprintf('%d',1:dh:newXrange(2)));
        else 
          set(gca,'XTickLabel',TIMEL);
        end
      end
      if (i3from == 1) && (LIM<=30) % When in the leftmost margin.
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
  end
end
%% h: description about outer x-y axis
fig_memo = sprintf('regFac=%09.4f frame=%6d  #%4d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
strcat(fig_memo,fig_memoIn);
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)

if LIM <=30
  text(.2,.95,fig_memo,'FontSize',12)
  if 1 == 0
    text(.12,.90,'Triggers')
    text(.08,.85,'Targets')
  elseif ~PAPER
    pos = [ .1 cnum ]/(cnum+2);
    text(pos(1)+.02,pos(2) +.03,'Triggers')
    text(pos(1)+.01,pos(2) -.00,'Targets')
  end
end

%%% ===== PLOT ResponseFunc ===== END =====
if ( graph.PRINT_T == 1 ) || ( status.parfor_ == 1 )
  f_memo = sprintf('_regFac_%09.4f_frame=%07d_N=%04d',DAL.regFac(regFacIndex),DAL.Drow,cnum );
  %% fprintf(1,'saved figure: \n')
  fprintf(1,'\n%s\n', [status.savedirname '/Estimated_ResponseFunc' f_memo '.png']);
  print('-dpng', [status.savedirname '/Estimated_ResponseFunc' f_memo '.png'])
  %% save as eps
  saveas(gcf,sprintf('%s',[status.savedirname '/Estimated_ResponseFunc' f_memo ...
                      '.eps' ]),'epsc2')
end
