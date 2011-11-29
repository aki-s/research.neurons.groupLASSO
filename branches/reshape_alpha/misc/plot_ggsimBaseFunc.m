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
  %  xlabel('m ');
  title('cosine basis function');

end

%{
zeros(,bases.ihbasprs.nbase);
figure
hold on
for i1 = 0.1:0.3:10
for i2 = 0.1:0.3:10
bases.ihbasis.*[
end
end

%}
