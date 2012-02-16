function plot_ggsimBaseFunc(env,bases)
%%
%% Usage)
% plot_ggsimBaseFunc(env,bases)
%%
PAPER = 1;
DECOLOR = 0;
LINET = 1;
LWIDTH = 1;
% $$$ rootdir_ = '/home/aki-s/10/gaya/myown/ml2/my'
% $$$ if ~( exist('rootdir_') && exist('bases') )
% $$$   run([rootdir_ '/myest.m'])
% $$$ end

% === Make Fig: model params =======================
if strcmp('show_basis','show_basis')
  %  figure;
  grid on;
  %  plot(bases.ihbasprs.numFrame, bases.ih);
  %  plot(bases.ihbasprs.numFrame*env.Hz.video, bases.ih);
  %plot( bases.ih);
  hold on;
  %  plot(bases.ihbasprs.numFrame, bases.ihbasis);
  %  plot(bases.ihbasprs.numFrame*env.Hz.video, bases.ihbasis);
  if LINET
    plot(bases.ihbasis,'LineWidth',LWIDTH);
    %  set(gca,'linestyle','k-','k--','k:');
    legend('k=1','k=2','k=3','k=4','k=5','k=6','k=7')
  else
    plot(bases.ihbasis,'LineWidth',LWIDTH);
  end
  axis tight;
  %xlabel('history index (frames) ');
  %  xlabel('m ');
end

if PAPER
  grid off
  if DECOLOR
    set(findobj('Type','line'),'Color','k'); %decolor
  end
  set(gca,'ytick',[0 1])
  ylim([0 1.05])
  %
  %  set(gca,'fontsize',12);
  %   set(gca,'fontsize',12,'linewidth',2);
  xlabel('Time [ms]') % default to 'Helvetica 12pt width 0.5'
else
  title('cos^2(log()) basis function');
end
