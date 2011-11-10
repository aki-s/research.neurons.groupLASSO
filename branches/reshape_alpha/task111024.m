load('/home/shige-o/rec072b.mat')
[pix1 pix2 dum ] = size(u);
%cnum=[30 60];
%cnum=[30];
cnum=[60];
for i1= 1:length(cnum)
  if cnum(i1) == 30
    load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/24-Oct-2011-start-15_48/Aki-0000016-rec072b-0044976-030.mat')
  elseif cnum(i1) == 60
    load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/24-Oct-2011-start-15_48/Aki-0000016-rec072b-0044976-060.mat')
  end
  j0=1:cnum(i1);
  [peak latency] = evaluateAlpha_latency(Alpha);

  %  for thresh = 0.1:0.1:1
  for thresh = 0.2:0.2
    A=zeros(cnum(i1));
    A=A+(peak>thresh);
    A=A-(peak<-thresh);
    A(logical(eye(cnum(i1)))) = 0; % omit self connection.
    figure
    [mx, my] = plot_ROI( u, j0 ); % ( mx(i) , my(i) ) は、i番目ROIの中
                                  % 心座標
                                  % 図のサイズを再設定
    draw_connection( A, mx, my ); % A は接続行列
    title(sprintf('thresh:%f, #%5.0d',thresh,cnum(i1)));
  end
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
  cutOff = latency.*A;
  cutOffp = nan(cnum(i1));
  cutOffn = nan(cnum(i1));

  cutOff(~logical(A)) = nan;
  cutOffp(cutOff>0) = cutOff(cutOff>0);
  cutOffn(cutOff<0) = -cutOff(cutOff<0);
  cutOffpn = abs(cutOff);
  if strcmp('checkDetail','checkDetail_')
    for i2 = 1:cnum(i1)
      figure;
      xlim([0 xrangeM])
      ylim([0 yrangeM])
      title(sprintf('#neuron:%5.0d threshold:%5.3d',i2,thresh));
      set(gcf,'menubar','none','Color','White','units','normalized',...
              'outerposition',[0,.6,.4,.4])
      hold on;
      %% only colorized dot is judged  that connection exists.
      for i3 = 1:cnum(i1)
        if (i2 == i3 ) && strcmp('skipDiag','skipDiag_')
        elseif (i2 == i3 )
          %%      elseif LOOK == i2
          plot(Dis(i2,i3),latency(i2,i3),'^','MarkerSize',5,'MarkerFaceColor','b');
          text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d<-%d',i2,i3));
        else 
          plot(Dis(i2,i3),latency(i2,i3),'o','MarkerSize',5);
          text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d<-%d',i2,i3));
          plot(Dis(i2,i3),cutOffn(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','b');
          plot(Dis(i2,i3),cutOffp(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','r');
          text(Dis(i2,i3)+[1],cutOffpn(i2,i3),sprintf('%d<-%d',i2,i3));
        end
      end
    end
  end
  figure;
  xlabel( 'Link distance [pixel]' )
  ylabel( 'Latency [frame]' )
  xrangeMM = max(max(Dis.*A));
  xlim([0 xrangeMM])
  ylim([0 yrangeM])
  title(sprintf(['#to:%5.0d<-#from:%5.0d out-of#%5.0d  threshold:' ...
                 '%5.3d'],inActTo,inActFrom,cnum(i1),thresh));
  if strcmp('menuOff','menuOff')
    set(gcf,'Color','White','units','normalized',...
            'outerposition',[.0,.5,.4,.4])
  else
    set(gcf,'menubar','none','Color','White','units','normalized',...
            'outerposition',[.0,.5,.4,.4])
  end
  hold on;
  for i2 = 1:cnum(i1)
    for i3 = 1:cnum(i1)
      if (i2 == i3 )
        plot(Dis(i2,i3),latency(i2,i3),'^','MarkerSize',5,'MarkerFaceColor','b');
        text(Dis(i2,i3)+[1],latency(i2,i3),sprintf('%d',i2));
      else
        plot(Dis(i2,i3),cutOffn(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','b');
        plot(Dis(i2,i3),cutOffp(i2,i3),'o','MarkerSize',5,'MarkerFaceColor','r');
        text(Dis(i2,i3)+[1],cutOffpn(i2,i3),sprintf('%d<-%d',i2,i3));
      end
    end
  end
end
