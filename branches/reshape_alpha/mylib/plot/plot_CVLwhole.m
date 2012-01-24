function  plot_CVLwhole(env,status,graph,DAL,CVL,varargin)
%%
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.
%% CVL: (regFac idx, cnum, usedFrame) matrix
%% example)
% plot_CVLwhole(env,status,graph,DAL,CVL{1})
%%
nargin_NUM = 5;

cnum = env.cnum;
LABEL = num2cell(DAL.regFac);
%regFacLen = length(DAL.regFac);
regFacLen = DAL.regFacLen;%++bug
%useFrameLen = length(env.useFrame);
%%
DEBUG = 0;
%%
%figure;
ylim([1 2])
CVLt = sum(CVL,2); %CVLt : CVL total

if 1
  if nargin >= nargin_NUM +1
    FROM = varargin{1};
  else
    FROM =1;
  end
  F = set_frameRange(nargin,nargin_NUM,FROM,status.validUseFrameIdx);
else
  if nargin > nargin_NUM
    ALL = 0;
    F.from = varargin{1};
    F.to = F.from;
  else
    ALL = 1;
    F.from = 1;
    F.to = sum( ~isnan(sum(CVLt)) );
  end
end
myColor = graph.prm.myColor;

if strcmp('plot_monochrome','plot_monochrome')
  myColor = cell(1,regFacLen);
  for i1 = 1:regFacLen
    myColor{i1} = [0 0 0];
  end
end
%% set legend entry
LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,F.to);
for id = F.from : F.to
  LGDT{id} = num2str(LGD{id});
end
%%col=hsv(F.to);


[minVal idx] = min(CVLt);
for i2 = F.from:F.to
  hold on;

  minIdx = find(minVal(:,:,i2) == CVLt(1:regFacLen,:,i2) );
  %% if (minIdx == 1) marker don't appear. Is this MATLAB bug?
  %% line
  if DEBUG > 0
    fprintf(1,'%02d, useFrame:%10d, myColor:[%f %f %f]\n',...
            i2, env.useFrame(i2), myColor{i2}(1),myColor{i2}(2),myColor{i2}(3));
  end
  plot(1:regFacLen,CVLt(1:regFacLen,1,i2),'color',myColor{i2},'LineWidth',3);
  xlim([1 regFacLen ]) % move figures to the left.
  %% diamond
  hLine2 = plot(minIdx,CVLt(minIdx,:,i2),'o-','color',myColor{i2},...
                'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine2,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');

  %  if ALL == 0
  if F.from == F.to
    title(['usedFrame:',...
           sprintf('%d',env.useFrame(i2)),...
           sprintf('\tminVal:%f',minVal(:,:,i2)),...
           sprintf('\tProb.:%f',exp(-minVal(:,:,i2)))...
          ])
  else
    title(['- (cross Validation Log Likelihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:regFacLen)
  set(gca,'xticklabel',LABEL)
end

%legend(LGDT{F.from:F.to},'FontSize',14,'LineWidth',3,'Location','NorthWest');
xlabel( 'regularization factor' )
ylabel( 'CVL' )
%if ALL == 1
if F.from ~= F.to
  inFname= regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
  title2 = sprintf('%s-CVL-%s-%04d',status.method,inFname,cnum );
else
  title2 = sprintf('%s-CVL-used%07d-n%04d',status.method,DAL.Drow(F.from),cnum );
end
if ( graph.PRINT_T == 1 )
  fprintf(1,['\nsaving -log(likelihood) as graph for each regFac and ' ...
             'used frame to estimate network.\n%s\n'], [status.savedirname '/' title2 '.png']);
  print('-dpng', [status.savedirname '/' title2 '.png'])
end
