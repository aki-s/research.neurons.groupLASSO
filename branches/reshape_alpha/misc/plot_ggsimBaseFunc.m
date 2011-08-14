function plot_ggsimBaseFunc(env,bases)
%%
%% Usage)
% plot_ggsimBaseFunc(env,bases)
%%

% $$$ rootdir_ = '/home/aki-s/10/gaya/myown/ml2/my'
% $$$ if ~( exist('rootdir_') && exist('bases') )
% $$$   run([rootdir_ '/myest.m'])
% $$$ end

% === Make Fig: model params =======================
if strcmp('show_basis','show_basis')
  figure;
  grid on;
  %  plot(bases.iht, bases.ih);
  %  plot(bases.iht*env.Hz.video, bases.ih);
  %plot( bases.ih);
  hold on;
  %  plot(bases.iht, bases.ihbasis);
  %  plot(bases.iht*env.Hz.video, bases.ihbasis);
  plot(bases.ihbasis);
  axis tight;
  %xlabel('history index (frames) ');
  xlabel('fOLD ');
  title('cosine basis function');

  figure;
  %  plot(bases.iht*env.Hz.video, bases.ihbas);
  plot(bases.ihbas);
  title('orthogonalized basis');
end
