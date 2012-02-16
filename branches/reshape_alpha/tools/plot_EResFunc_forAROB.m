function plot_EResFunc_forAROB(ResFunc,varargin)
%%Usage)
%  plot_EResFunc_forPaper2(ResFunc,glm.EResFunc{1},bar.EResFunc{2})
% 
% 
%% ResFunc is 'ture' connection response function generated from  input file: 'indir/my_n4.con'
%% bases is cosine-like
% glm = load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/30-Nov-2011-start-20_6/Aki-0010.0000-Aki-0010000-009.mat')
% 
% 
%% bases is bar
% bar=load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/30-Nov-2011-start-21_50/30_11_2011__21_50.mat')
%

PAPER = 1;
if nargin > 1
  EResFunc_a = varargin{1};
end
if nargin > 2
  EResFunc_s = varargin{2};
end
%EResFunc_s = EResFunc{1};
to__Choice = [ 1 2 3];
fromChoice = [ 1 2 3];

numto = length(to__Choice);
numfrom = length(fromChoice);
[ R C ] = size(ResFunc);
hnum = floor(R/C);

if numto ~= numfrom
  error('length error')
end
kuniku = 0;

for i1to = 1:numto
  for i2from = 1:numfrom
    subplot(numto,numfrom, i2from + (i1to-1)*numfrom)
    hold on;
    if ~PAPER
      grid on;
    end
    box on;
    %    axis tight;
    set(gcf,'color','white')
    set(gca,'Xlim',[0,50]);
    %    set(gca,'Xlim',[0,200]);
    %    set(gca,'XAxisLocation','top');
    %    set(gca,'XAxisLocation','bottom');
    set(gca,'Ylim',[-1,1]*1.2);

    plot(1:.1:50,0,'-k')
    if exist('EResFunc_a')
      if iscell('EResFunc_a')
        plot(EResFunc_a{to__Choice(i1to)}{fromChoice(i2from)},'r', ...
             'LineWidth',3)
      else
        plot(reshape(EResFunc_a(to__Choice(i1to),fromChoice(i2from),:),[],1),'r', ...
             'LineWidth',3)
      end
    end
    if exist('EResFunc_s')
      plot(EResFunc_s{to__Choice(i1to)}{fromChoice(i2from)},'k', ...
           'LineWidth',1)
    end
    plot(ResFunc((1:hnum) +(fromChoice(i2from)-1)*hnum,to__Choice(i1to)),'--b','LineWidth',2)
    if ~PAPER
      if i1to == i2from % diag
        set(gca,'Ylim',[-1,1]*20);
      end
    end
    if to__Choice(i1to) == to__Choice(1)
      xlabel(sprintf('Neuron%2d',fromChoice(i2from)));
      xlabh = get(gca,'XLabel') ;
      if kuniku ~= 0 %++bug: some unit is causing problem
        set(xlabh,'Position',get(xlabh,'Position') + [0 3.9 0]) 
      else
        set(xlabh,'Position',get(xlabh,'Position') + [0 3.9 0]) 
        kuniku = kuniku + 1;
      end
    end
    if fromChoice(i2from) == fromChoice(1)
      ylabel(sprintf('Neuron%2d',to__Choice(i1to)));
      set(gca,'yticklabel',[-1 0 +1])
    else
      set(gca,'yticklabel',[])
    end
    if to__Choice(i1to) == to__Choice(3)
      %      set(gca,'xtick',[ 0:25:75 ],'xticklabel',{0,25,'[ms]'})
      set(gca,'xtick',[ 0:25:50 ])
      xlabel('[ms]')
    else
      set(gca,'xtick',[])
    end
% $$$   if i1to == 1
% $$$   else
% $$$     set(gca,'xticklabel','')
% $$$   end
  end
end
