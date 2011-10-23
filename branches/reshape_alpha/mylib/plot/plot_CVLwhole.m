function plot_CVLwhole(env,status,graph,DAL,CVL,RfWholeIdx,varargin)

a = sum(CVL,2);
cnum = env.cnum;

nargin_NUM = 6;
if nargin > nargin_NUM
  ALL = 0;
  FROM = varargin{1};
  fnum = FROM;
else
  ALL = 1;
  FROM = 1;
  %  [dum1 dum2 fnum] = size(CVL);
  fnum = sum( ~isnan(sum(a)) );
end

LABEL = num2cell(DAL.regFac);
LEN = length(DAL.regFac);
LGD = num2cell(reshape(env.useFrame,1,[]));
LGDT = cell(1,fnum);
%for id = 1: length(LGD)
for id = 1: fnum
  %  LGDT = horzcat(LGDT,num2str(LGD{id}));
  LGDT{id} = num2str(LGD{id});
end


%%col=hsv(fnum);
color={'b','g','r','c','m','b'};
figure
for i2 = FROM:fnum
  hold on;
  %  plot(a(:,:,i2),'o-','color',col(i2,:));
  %{
  plot(a(:,:,i2),'o-','color',color{i2},'LineWidth',3,'MarkerSize',1);
  text(RfWholeIdx(i2),a(RfWholeIdx(i2),:,i2),'\Downarrow min','LineWidth',5,'color',color{i2})
  %}

  plot(1:LEN,a(:,:,i2),'color',color{i2},'LineWidth',3);
  hLine = plot(RfWholeIdx(i2),a(RfWholeIdx(i2),:,i2),'o-','color',color{i2},...
               'Marker','d','MarkerFaceColor','auto','MarkerSize',10,'LineWidth',3);
  set(get(get(hLine,'Annotation'),'LegendInformation'),...
      'IconDisplayStyle','off');

  if ALL == 0
    title(['usedFrame:',sprintf('%d',env.useFrame(i2))])
  else
    title(['- (cross Validation Liklihood)',sprintf('#%4d',cnum)])
  end
  set(gcf,'color','white')
  set(gca,'xtick',1:LEN)
  set(gca,'xticklabel',LABEL)
end

legend(LGDT,'FontSize',14,'LineWidth',3);
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
