%% Set freely your configuration.
warning('conf_user.m overrides all configuration variables set after this file.');

status.READ_NEURO_CONNECTION =1;

graph.TIGHT=1;
graph.PLOT_T = 1;
graph.GRAPHVIZ_OUT_FIG=1; % default: 0

%%evn.cnum=
%%env.spar.level.from
%%env.spar.level.to  

switch 4
case 1
  %kim only
  env.genLoop = 100000;
  status.GEN_TrureValues = 0;
case 2
  env.genLoop = 400000;
  status.GEN_TrureValues = 1;
case 3
  env.genLoop =  20000;
  status.GEN_TrureValues = 0;
case 4
  env.genLoop =  2000;
  status.GEN_TrureValues = 1;
end
env.hnum=50;
env.hwind=2;
env.Hz.video=100;
%{
env.Hz.neuro=;
env.Hz.fn=;
%}
env.SELF_DEPRESS_BASE=2;
% log(2) == 0.7
env.mail.to='aki-s@sys.i.kyoto-u.ac.jp';
env.mail.smtp='hawaii.sys.i.kyoto-u.ac.jp';

status.mail = 1

