%% < default values >
%% this file may should be renamed as conf_minimalSettings.

cnum = 6;% cnum: number of cell (neuron)

%% SET NEURONAL CONNECTION SPARSITY LEVEL ( 0 < sparse.level < 1 )
spar = struct('from',[],'to',[],'level',[]);
spar.level.from = .5;
spar.level.to = .5;
spar.self = 1; % 1:self-connect all neuron.

%% genLoop: the number of frames of 'lambda'(neuronal firing rate per flame) to be generated. [frame]
genLoop = 150000;

%< hnum = HistSec * Hz.v / hwind
hnum = 100; % hnum: the number of history window [frame]
%% large hwind cause continuous firing of each neuron.
hwind = 1; % hwind: the number of frames in a history window

Hz = struct('video',100, ... % video Hz: [frame/sec]
            'neuro',30, ...  % Hz of neuronal firing: [rate/sec] %++bug: impossible to set.
            'fn',[]);    % Hz of firing per frame: [rate/frame]

SELF_DEPRESS_BASE = 6.5; %exp(SELF_DEPRESS_BASE): auto-firing
                       %intensity of a neuron.

