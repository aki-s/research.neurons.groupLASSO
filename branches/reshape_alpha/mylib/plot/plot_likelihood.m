function  plot_likelihood(env,status,graph,DAL,CVL,varargin)
%%
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% CVL: (regFac idx, cnum, usedFrame) matrix
cnum = env.cnum;
LABEL = num2cell(DAL.regFac);
regFacLEN = length(DAL.regFac);
useFrameLen = length(env.useFrame);
myColor = graph.prm.myColor;

if strcmp('omitDiag','omitDiag_') %%DEBUG
  zeroIdx = repmat(logical(eye(cnum)),[1 1 useFrameLen]);
  CVL(zeroIdx) = 0;
  CVLt = sum(CVL,2);
else
  CVLt = sum(CVL,2); %CVLt : CVL total
end

prob = exp(-CVLt);

nargin_NUM = 5;
if nargin > nargin_NUM
  ALL = 0;
  FROM = varargin{1};
  fnum = FROM;
else
  ALL = 1;
  FROM = 1;
  fnum = sum( ~isnan(sum(CVLt)) );
end

LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,fnum);

%for id = 1: length(LGD)
for id = FROM : fnum
  %  LGDT = horzcat(LGDT,num2str(LGD{id}));
  LGDT{id} = num2str(LGD{id});
  %LGDT{id} = LGD{id};
end
%%col=hsv(fnum);

%figure
for i2 = FROM:fnum
  hold on;

  %% set index of maxima as 'sameIdx' ++bug
  [maxVal idx] = max(prob);
  maxIdx = find(maxVal(:,:,i2) == prob(1:regFacLEN,:,i2) );
  %% if (maxIdx == 1) marker don't appear. Is this MATLAB bug?
  %% line
  if strcmp('DEBUG','DEBUG')
    fprintf(1,'%02d, useFrame:%10d, myColor:[%f %f %f]\n',...
            i2, env.useFrame(i2), myColor{i2}(1),myColor{i2}(2),myColor{i2}(3));
    plot(1:regFacLEN,prob(1:regFacLEN,1,i2),'color',myColor{i2},'LineWidth',3);
    axis([1 regFacLEN .5 1.05]) % move figures to the left.
  end
  %% diamond
  hLine2 = plot(maxIdx,prob(maxIdx,:,i2),'o-','color',myColor{i2},...
                'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine2,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');

  if ALL == 0
    title(['usedFrame:',...
           sprintf('%d',env.useFrame(i2)),...
           sprintf('\tmaxVal:%f',maxVal(:,:,i2)),...
           sprintf('\tProb.:%f',maxVal(:,:,i2))...
          ])
  else
    title(['- (cross Validation Liklihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:regFacLEN)
  set(gca,'xticklabel',LABEL)
end

%legend(LGDT,'FontSize',14,'LineWidth',3);
legend(LGDT{FROM:fnum},'FontSize',14,'LineWidth',3,'Location','NorthWest');
xlabel( 'regularization factor' )
ylabel( 'prob.' )
ylim([0 1])
if ALL == 1
  inFname= regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
  title2 = sprintf('%s-CVL-%s-%04d',status.method,inFname,cnum );
else
  title2 = sprintf('%s-CVL-used%07-n%04d',status.method,DAL.Drow,cnum );
end
if ( graph.PRINT_T == 1 )
  fprintf(1,'%s', [status.savedirname '/' title2 '.png']);
  print('-dpng', [status.savedirname '/' title2 '.png'])
end
