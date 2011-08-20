function plot_Ealpha_forPaper2(Ealpha_s,alpha,varargin)
%Usage)
%  plot_Ealpha_forPaper2(bar.Ealpha,alpha,glm.Ealpha)
% 
% 
% bases is bar
% bar=load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/15-Aug-2011-start-13_39/15-Aug-201113_39.mat')
%
% alpha is 'ture' connection response function generated from  input file: 'indir/my_n4.con'
% bases is cosine-like
% glm=load('/home/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/15-Aug-2011-start-13_45/15-Aug-201113_45.mat')
% 
% 
% 

if length(varargin) > 0
  Ealpha_a = varargin{1};
end
%Ealpha_s = Ealpha{1};
to__Choice = [ 1 2 3];
fromChoice = [ 1 2 3];

numto = length(to__Choice);
numfrom = length(fromChoice);
[ R C ] = size(alpha);
hnum = floor(R/C);

if numto ~= numfrom
  error('length error')
end

figure;
for i1to = 1:numto
  for i2from = 1:numfrom
    subplot(numto,numfrom, i2from + (i1to-1)*numfrom)
    hold on;
    grid on;
    %    axis tight;
    set(gcf,'color','white')
    set(gca,'Xlim',[0,50]);
    set(gca,'XAxisLocation','top');
    set(gca,'Ylim',[-1,1]*1.2);

    if strcmp('new','new_')
      plot(Ealpha_s{to__Choice(i1to)}{fromChoice(i2from)},'--k','LineWidth',1)
      plot(alpha((1:hnum) +(fromChoice(i2from)-1)*hnum,to__Choice(i1to)),'b','LineWidth',3)
      if exist('Ealpha_a')
        plot(Ealpha_a{to__Choice(i1to)}{fromChoice(i2from)},'r', ...
             'LineWidth',1)
      end
    else
      plot(Ealpha_s{to__Choice(i1to)}{fromChoice(i2from)},'k','LineWidth',1)
      if exist('Ealpha_a')
        plot(Ealpha_a{to__Choice(i1to)}{fromChoice(i2from)},'r', ...
             'LineWidth',3)
      end
      plot(alpha((1:hnum) +(fromChoice(i2from)-1)*hnum,to__Choice(i1to)),'--b','LineWidth',2)
    end

    if i1to == i2from
      set(gca,'Ylim',[-1,1]*20);
    end
    if to__Choice(i1to) == to__Choice(1)
      xlabel(fromChoice(i2from));
    end
    if fromChoice(i2from) == fromChoice(1)
      ylabel(to__Choice(i1to));
    end
  end
end