function  [ A Dis latency] = plot_con2Dslice(location,resfunc_mat,peakTHRESH,varargin)
%%
%% A:  connectional matrix obtained by cuting off with 'peakTHRESH'.
%% Dis:Distance between neurons. (cutOff with 'A' is not yet)
%% latency: Time took to get the first maximum/minumum peak. (cutOff with 'A' is not yet)
%%
LINEWID = 3;
argin_num = 3;
if nargin > argin_num 
  disFuncTHRESH = varargin{1};
else
  disFuncTHRESH = 0;
end
if 1
PAPER = 0;
FITTING = 0;
else
PAPER = 1;
FITTING = 1;
end
%%==< plot 2D slice data and neuronal connection>==
[pix1 pix2 dum ] = size(location);

for i1= 1:1

  s = load([ resfunc_mat ]);
  cnum = s.env.cnum(i1);
  try % pre revision@111
    ResFunc = s.Alpha;
  catch err
    ResFunc = s.EResFunc; %[cnum cnum history] mat
  end
  j0=1:cnum(i1);
  [latency peak] = evalResponseFunc_latency(ResFunc);
  RFIntensity = evalResponseFunc( ResFunc );
  conMat = get_conMat(RFIntensity,disFuncTHRESH);
  %% Judge connectional type
  for thresh = peakTHRESH
    A=zeros(cnum(i1));
    A=A+(peak>+thresh).*conMat;
    A=A+(peak<-thresh).*conMat;
    H1 = figure;
    % subplot(1,2,1)
    [mx, my] = plot_ROI( location, j0 );
    draw_connection( A, mx, my );
    plot(180-(1:.1:20),80,'k')
    plot(180- 1,78:.1:82,'k')
    plot(180-20,78:.1:82,'k')
    text(160,75,'20 [\mum]')
    set(gca,'XTick',[],'YTick',[])
    xlabel( 'Distance [\mum]' )
    ylabel( 'Distance [\mum]' )
    if ~PAPER
      title(sprintf('peakThresh:%f, disFuncThresh:%f, #%5.0d',thresh,disFuncTHRESH,cnum(i1)));
    end
  end
  %  daspect([3 4 1]) %++bug: for gaya data
  %  daspect([5 6 1]) %++bug: for gaya data
  %  daspect([1 1 1]) %++bug: for gaya data
  %  set(gca,'xlim',[0 160],'ylim',[0 350]);
  %  axis([0 160 0 360])
  axis image; 
  %%==</plot 2D slice data and neuronal connection>==

  %%==< plot relation between distance and ResFunc peak >==
  inActFrom = sum(sum(abs(A),1)>0);
  inActTo = sum(sum(abs(A),2)>0);
  [Dis] = calcDistance(mx,my,cnum(i1));
  ylimM = max(max(latency));
  xlimM = max(max(Dis));
  if ( ylimM < 40 )
    yrangeM = 40;
  else
    yrangeM = ylimM;
  end
  if ( xlimM < 160 )
    xrangeM = 160;
  else
    xrangeM = sqrt(2)*pix2;
  end
  cutOff = latency.*A; % use connection as A
  cutOffp = nan(cnum(i1));
  cutOffn = nan(cnum(i1));

  %  cutOff(~logical(A)) = nan; % remove arrow representing self-depression
  cutOffp(cutOff>0) = +cutOff(cutOff>0);
  cutOffn(cutOff<0) = -cutOff(cutOff<0);
  cutOffpn = abs(cutOff);
  %% plot (positive/zero/negative) connection in unit of each cell
  if strcmp('checkDetail','checkDetail_')
    for i2 = 1:cnum(i1)
      figure;
      xlim([0 xrangeM])
      ylim([0 yrangeM])
      if ~PAPER
        title(sprintf('#neuron:%5.0d threshold:%5.3f',i2,thresh));
      end
      set(gcf,'menubar','none','Color','White','units','normalized',...
              'outerposition',[0,.6,.4,.4])
      hold on;
      %% only colorized dot is judged  that connection exists.
      for i3 = 1:cnum(i1)
        if (i2 == i3 ) && strcmp('skipDiag','skipDiag_')
        elseif (i2 == i3 )
          %%      elseif LOOK == i2
          plot(Dis(i2,i3),latency(i2,i3),'^','MarkerSize',5,'MarkerFaceColor','b');
          if ~PAPER
            text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d<-%d',i2,i3));
          end
        else 
          plot(Dis(i2,i3),latency(i2,i3),'o','MarkerSize',5);
          if ~PAPER
            text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d<-%d',i2,i3));
          end
          plot(Dis(i2,i3),cutOffn(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','b');
          plot(Dis(i2,i3),cutOffp(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','r');
          if ~PAPER
            text(Dis(i2,i3)+[1],cutOffpn(i2,i3),sprintf('%d<-%d',i2,i3));
          end
        end
      end
    end
  end
  %% plot (positive//negative) connection in unit of total cell in
  %% a figure
  H2 = figure;
  hold on;
  % subplot(1,2,2)
  xrangeMM = max(max(Dis.*A));
  if xrangeMM == 0
    error('It seems peakTHRESH is too large.')
  end
  xlim([0.1 xrangeMM])
  ylim([0.1 yrangeM])
  if ~PAPER
    xlabel( 'Link distance [pixel]' )
    ylabel( 'Latency [frame]' )
    title(sprintf(['#to:%5.0d<-#from:%5.0d out-of#%5.0d disFuncThreshold:%f peakThreshold:' ...
                   '%5.3f'],inActTo,inActFrom,cnum(i1),disFuncTHRESH,thresh));
  else
    xlabel( 'Link distance [\mu]' )
    ylabel( 'Latency [msec]' )
  end
  if strcmp('menuOff','menuOff')
    set(gcf,'Color','White','units','normalized',...
            'outerposition',[.0,.5,.4,.4])
  else
    set(gcf,'menubar','none','Color','White','units','normalized',...
            'outerposition',[.0,.5,.4,.4])
  end

  sizeD = sum(sum( conMat ~= 0 ));
  D = zeros(sizeD,2);
  idx = 0;
  RFIntensity_ = zeros(sizeD,1);
  for i2 = 1:cnum(i1)
    for i3 = 1:cnum(i1)
      if (i2 == i3 ) &&  ~PAPER   % self connection
                                  %        plot(Dis(i2,i3),latency(i2,i3),'^','MarkerSize',5,'MarkerFaceColor','k');
        plot(Dis(i2,i3),latency(i2,i3),'^','MarkerSize',5);
        text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d',i2));
        idx = idx + 1;
        D(idx,:) = [Dis(i2,i3) conMat(i2,i3)*latency(i2,i3) ];
        RFIntensity_(idx) = RFIntensity(i2,i3);
      elseif ( conMat(i2,i3) < 0 ) && ~ (i2 == i3 ) 
        plot(Dis(i2,i3),cutOffn(i2,i3),'s','MarkerSize',5,'MarkerFaceColor','b','markeredgecolor','b');
        if ~PAPER
          text(Dis(i2,i3)+[1],cutOffn(i2,i3),sprintf('%d<-%d',i2,i3));
        end
        idx = idx + 1;
        D(idx,:) = [Dis(i2,i3) conMat(i2,i3)*latency(i2,i3) ];
        RFIntensity_(idx) = RFIntensity(i2,i3);
      elseif ( conMat(i2,i3) > 0 ) && ~ (i2 == i3 ) 
        plot(Dis(i2,i3),cutOffp(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','r','markeredgecolor','r');
        if ~PAPER
          text(Dis(i2,i3)+[1],cutOffp(i2,i3),sprintf('%d<-%d',i2,i3));
        end
        idx = idx + 1;
        D(idx,:) = [Dis(i2,i3) conMat(i2,i3)*latency(i2,i3) ];
        RFIntensity_(idx) = RFIntensity(i2,i3);
      end
    end
  end
end
axis([0 160 0 360]);
axis square;
set(gca, 'XTick', [0.1 10 100]);
%set(gca, 'XTicklabel', [10^0 10^1 10^2]);
set(gca, 'YTick', [0.1 10 100]);
set(gca, 'xscale', 'log', 'yscale', 'log');
%%==</plot relation between distance and ResFunc peak >==


%%==< fitting >==
%% sort D according to x-axis
[val idx] = sort(D(:,1),'ascend');
D = [val D(idx,2)];
idxN = D(:,2) < 0;
idxP = D(:,2) > 0;
D = abs(D);
corrcoef(D)
%%
H3 = figure;
hold on
%plot(D(:,1),D(:,2),'ok')
plot(D(idxN,1),D(idxN,2),'sb')
plot(D(idxP,1),D(idxP,2),'or')

if 0
  for i1 = 1:sizeD
    text(D(i1,1),D(i1,2),sprintf('%f',RFIntensity_(i1)))
  end
  title('legend:intensity')
end
if FITTING
    p1 = polyfit(D(:,1),D(:,2),1);
    p2 = polyfit(D(:,1),D(:,2),2);
  if strcmp('dots','dots_')
    plot(D(:,1),polyval(p1,D(:,1)),'^k','linewidth',LINEWID)
    plot(D(:,1),polyval(p2,D(:,1)),'kx','linewidth',LINEWID)
  else strcmp('line','line')
    plot(D(:,1),polyval(p1,D(:,1)),'-^k','linewidth',LINEWID)
    plot(D(:,1),polyval(p2,D(:,1)),'--kx','linewidth',LINEWID)
  end
end
%set(gca,'xlim',[0 160],'ylim',[0 350]);
axis([0 160 0 360])
%axis image; 
axis square

xlabel( 'Link distance [\mu m] ' )
ylabel( 'Latency [msec]' )

%%==</fitting >==
