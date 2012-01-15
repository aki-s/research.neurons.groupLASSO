function  plot_CVLwhole(env,status,graph,DAL,CVL,varargin)
%%
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% CVL: (regFac idx, cnum, usedFrame) matrix
%% example)
% plot_CVLwhole(env,status,graph,DAL,CVL{1})
%%
cnum = env.cnum;
LABEL = num2cell(DAL.regFac);
regFacLEN = length(DAL.regFac);
useFrameLen = length(env.useFrame);
myColor = graph.prm.myColor;
%%
DEBUG = 0;
%%
figure;
ylim([1 15])
CVLt = sum(CVL,2); %CVLt : CVL total


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

%% set legend entry
LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,fnum);
for id = FROM : fnum
  LGDT{id} = num2str(LGD{id});
end
%%col=hsv(fnum);


[minVal idx] = min(CVLt);
for i2 = FROM:fnum
  hold on;

  minIdx = find(minVal(:,:,i2) == CVLt(1:regFacLEN,:,i2) );
  %% if (minIdx == 1) marker don't appear. Is this MATLAB bug?
  %% line
  if DEBUG > 0
    fprintf(1,'%02d, useFrame:%10d, myColor:[%f %f %f]\n',...
            i2, env.useFrame(i2), myColor{i2}(1),myColor{i2}(2),myColor{i2}(3));
  end
    plot(1:regFacLEN,CVLt(1:regFacLEN,1,i2),'color',myColor{i2},'LineWidth',3);
    xlim([1 regFacLEN ]) % move figures to the left.
  %% diamond
  hLine2 = plot(minIdx,CVLt(minIdx,:,i2),'o-','color',myColor{i2},...
                'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine2,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');

  if ALL == 0
    title(['usedFrame:',...
           sprintf('%d',env.useFrame(i2)),...
           sprintf('\tminVal:%f',minVal(:,:,i2)),...
           sprintf('\tProb.:%f',exp(-minVal(:,:,i2)))...
          ])
  else
    title(['- (cross Validation Log Likelihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:regFacLEN)
  set(gca,'xticklabel',LABEL)
end

legend(LGDT{FROM:fnum},'FontSize',14,'LineWidth',3,'Location','NorthWest');
xlabel( 'regularization factor' )
ylabel( 'CVL' )
if ALL == 1
  inFname= regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
  title2 = sprintf('%s-CVL-%s-%04d',status.method,inFname,cnum );
else
  title2 = sprintf('%s-CVL-used%07-n%04d',status.method,DAL.Drow,cnum );
end
if ( graph.PRINT_T == 1 )
  fprintf(1,['\nsaving -log(likelihood) as graph for each regFac and ' ...
             'used frame to estimate network.\n%s\n'], [status.savedirname '/' title2 '.png']);
  print('-dpng', [status.savedirname '/' title2 '.png'])
  close;
end
