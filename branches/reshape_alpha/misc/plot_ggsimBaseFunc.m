function plot_ggsimBaseFunc(env,ggsim);
%%
%% Usage)
% plot_ggsimBaseFunc(env,ggsim);
%%

% $$$ rootdir_ = '/home/aki-s/10/gaya/myown/ml2/my'
% $$$ if ~( exist('rootdir_') && exist('ggsim') )
% $$$   run([rootdir_ '/myest.m'])
% $$$ end

% === Make Fig: model params =======================
if strcmp('show_basis','show_basis')
  figure;
  grid on;
  %  plot(ggsim.iht, ggsim.ih);
  %  plot(ggsim.iht*env.Hz.video, ggsim.ih);
  plot( ggsim.ih);
  hold on;
  %  plot(ggsim.iht, ggsim.ihbasis);
  %  plot(ggsim.iht*env.Hz.video, ggsim.ihbasis);
  plot(ggsim.ihbasis);
  axis tight;
  xlabel('history index (frames) ');
  title('basis');

  figure;
  %  plot(ggsim.iht*env.Hz.video, ggsim.ihbas);
  plot(ggsim.ihbas);
  title('orthogonalized basis');
end
