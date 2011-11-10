function [myColor] = plot_CVLwhole(env,status,graph,DAL,CVL,varargin)
%%
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% CVL: (regFac idx, cnum, usedFrame) matrix
cnum = env.cnum;
LABEL = num2cell(DAL.regFac);
regFacLEN = length(DAL.regFac);
useFrameLen = length(env.useFrame);

if strcmp('omitDiag','omitDiag_')
  zeroIdx = repmat(logical(eye(cnum)),[1 1 useFrameLen]);
  CVL(zeroIdx) = 0;
  CVLt = sum(CVL,2);
else
  CVLt = sum(CVL,2); %CVLt : CVL total
end

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

LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,fnum);

%for id = 1: length(LGD)
for id = FROM : fnum
  %  LGDT = horzcat(LGDT,num2str(LGD{id}));
  LGDT{id} = num2str(LGD{id});
  %LGDT{id} = LGD{id};
end
%%col=hsv(fnum);
%% colorB={'b','g','r','c','m','b'};
colorB={[0 0 1],[0 1 0],[1 0 0],[0 1 1],[1 0 1],[0 0 0]};
%colorB = [ [0 0 1],[0 1 0],[1 0 0],[0 1 1],[1 0 1],[0 0 0] ];
colorLen = size(colorB,2);
  TERM = ceil(useFrameLen / colorLen);
  myColor= cell(1,colorLen*TERM);
  for j1 = 1:TERM
    for j2 = 1:colorLen
      myColor{(j1-1)*colorLen+j2} = (colorB{j2}*j1 + .2*rand(1,1))/TERM;
    end
  end
  norm = cell2mat(myColor);
  while sum(( norm > 1 ))
    norm( norm >1) =   norm( norm >1) - 1;
  end
  myColor= mat2cell(norm,1,repmat(3,[1 colorLen*TERM]));

figure
for i2 = FROM:fnum
  hold on;

  %% set index of minima as 'sameIdx' ++bug
  [minVal idx] = min(CVLt);
  %{
  sameIdx = zeros(regFacLEN,1);
  sameIdx(2:regFacLEN,1) = ( CVLt(2:regFacLEN,:,i2) == CVLt(1:(regFacLEN-1),:,i2) );
  if sameIdx(idx)
    tmp = find(sameIdx>0);
    sameIdx(tmp(1)-1) = 1;
  else
    sameIdx(idx) = 1;
  end
  minIdx = find(sameIdx>0);
  %}
%  sameIdx = (repmat(minVal == CVLt(1:regFacLEN,1,i2) )
  minIdx = find(minVal(:,:,i2) == CVLt(1:regFacLEN,:,i2) );
  %% if (minIdx == 1) marker don't appear. Is this MATLAB bug?
  %% line
i2
  fprintf(1,'%02d useFrame:%04d myColor%d\n', i2, env.useFrame(i2), myColor{i2});
  plot(1:regFacLEN,CVLt(1:regFacLEN,1,i2),'color',myColor{i2},'LineWidth',3);
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
    title(['- (cross Validation Liklihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:regFacLEN)
  set(gca,'xticklabel',LABEL)
end

%legend(LGDT,'FontSize',14,'LineWidth',3);
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
  fprintf(1,'%s', [status.savedirname '/' title2 '.png']);
  print('-dpng', [status.savedirname '/' title2 '.png'])
end
