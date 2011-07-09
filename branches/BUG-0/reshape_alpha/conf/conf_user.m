%% Set freely your configuration.
warning('conf_user.m overrides all configuration variables set after this file.');

graph.PLOT_T = 1;
graph.GRAPHVIZ_OUT_FIG=1; % default: 0

%%evn.cnum=
%%env.spar.level.from
%%env.spar.level.to  

env.genLoop=20000;
env.hnum=50;
env.hwind=2;
env.Hz.video=100;
%{
env.Hz.neuro=;
env.Hz.fn=;
%}
env.SELF_DEPRESS_BASE=2;
% log(2) == 0.7
status.READ_NEURO_CONNECTION =1;
status.GEN=1;