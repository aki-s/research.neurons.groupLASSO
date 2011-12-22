function bases = conf_makeSimStruct_glm()
%% ( Number of basis vectors for post-spike kernel )
%% <Tweek here>
%% == length [frame] ==
ihbasprs.numFrame = 700;
%% ==  ==
ihbasprs.xscale = 2; % aim
%% ihbasprs.hpeaks have precedence.
%% ihbasprs.hpeaks: first and last peak location of bases.
%% ==  ==
if strcmp('comp_stevenson','comp_stevenson_')
  ihbasprs.basisType = 'bar'; % ability of representatation is too much.
  if 1 == 1
    %    nbase = ihbasprs.numFrame;
    nbase = 50;
  else
    % You'd better compress time series of firing in this case.
    nbase = floor(env.Hz.video/2);
  end
  ihbasprs.nbase = nbase;
elseif strcmp('comp_kim','comp_kim')
  ihbasprs.basisType = 'glm';
  ihbasprs.nbase = 7;
end
%% ihbasprs.hpeaks: Peak location for first and last vectors.
% To be [ihbasprs.hpeaks(1) > arg(makeSimStruct_glm)] is recommended.
if strcmp('makeAbsRef','makeAbsRef_')
% Must be [ihbasprs.hpeaks(1) == ihbasprs.absref].
  ihbasprs.absref = .2; % absolute refractory period [sec].
  ihbasprs.hpeaks = [ihbasprs.absref 3]; % Unit of this is second.
  if ~mod(ihbasprs.nbase,2)
    warning(['basis don''t sum up to 2. Set ihbasprs.nbase odd ' ...
             'number.']);
  end
else
  ihbasprs.absref = []; % absolute refractory period 
  %%  ihbasprs.hpeaks = [.2 ihbasprs.nbase+2]; % Unit of this is second.
  %  ihbasprs.hpeaks = [0 0.5]/ihbasprs.xscale; % Unit of this is second.
end
%% How nonlinear to make spacings
if strcmp('old','old_')
ihbasprs.hpeaks = [.2 ihbasprs.nbase+2];
ihbasprs.b = .5;
else
ihbasprs.hpeaks = [0 0.3]; % Unit is [sec]
ihbasprs.b = 10; % \in [0,1)
end
%% <Tweek here/>

%% ==< Don't touch the following >== 
bases.ihbasprs = ihbasprs;

%% ==</Don't touch the following >== 
