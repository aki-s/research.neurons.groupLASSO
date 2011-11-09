function plot_CVLwhole(env,status,graph,DAL,CVL,varargin)
%%
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% CVL: (regFac idx, cnum, usedFrame) matrix
CVLt = sum(CVL,2); %CVLt : CVL total
cnum = env.cnum;

nargin_NUM = 5;
if nargin > nargin_NUM
  ALL = 0;
  FROM = varargin{1};
  fnum = FROM;
else
  ALL = 1;
  FROM = 1;
  %  [dum1 dum2 fnum] = size(CVL);
  fnum = sum( ~isnan(sum(CVLt)) );
end

LABEL = num2cell(DAL.regFac);
regFacLEN = length(DAL.regFac);
LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,fnum);
%for id = 1: length(LGD)
for id = FROM: fnum
  %  LGDT = horzcat(LGDT,num2str(LGD{id}));
  LGDT{id} = num2str(LGD{id});
end

%%col=hsv(fnum);
color={'b','g','r','c','m','b'};
figure
for i2 = FROM:fnum
  hold on;

  %% find minimum
  [minVal idx] = min(CVLt);
  sameIdx = zeros(regFacLEN,1);
  sameIdx(2:regFacLEN,1) = ( CVLt(2:regFacLEN,:,i2) == CVLt(1:(regFacLEN-1),:,i2) );
  if sameIdx(idx)
    tmp = find(sameIdx>0);
    sameIdx(tmp(1)-1) = 1;
  else
    sameIdx(idx) = 1;
  end
  minIdx = find(sameIdx>0);
  %% if (minIdx == 1) marker don't appear. Is this MATLAB bug?
  %% line
  plot(1:regFacLEN,CVLt(:,:,i2),'color',color{i2},'LineWidth',3);
  %% diamond
  hLine2 = plot(minIdx,CVLt(minIdx,:,i2),'o-','color',color{i2},...
                'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine2,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');

  if ALL == 0
    title(['usedFrame:',sprintf('%d',env.useFrame(i2))])
  else
    title(['- (cross Validation Liklihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:regFacLEN)
  set(gca,'xticklabel',LABEL)
end

%legend(LGDT,'FontSize',14,'LineWidth',3);
legend(LGDT{fnum},'FontSize',14,'LineWidth',3,'Location','NorthWest');
xlabel( 'regularization factor' )
ylabel( 'CVL' )
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
