%% ( Number of basis vectors for post-spike kernel )
%% <Tweek here>
if strcmp('comp_stevenson','comp_stevenson')
  basisType = 'bar'; % ability of representatation is too much.
  if 1 == 1
    nbase = 50;
  else
    % You'd better compress time series of firing in this case.
    nbase = floor(env.Hz.video/2);
  end
  ihbasprs.nbase = nbase;
elseif strcmp('comp_kim','comp_kim')
  basisType = 'glm';
  ihbasprs.nbase = 6;
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
  ihbasprs.hpeaks = [.2 ihbasprs.nbase+2];
end
ihbasprs.b = .4;  % How nonlinear to make spacings %??
%% <Tweek here/>
