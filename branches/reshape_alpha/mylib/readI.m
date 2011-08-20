function [ Oenv I OTout] = readI(env,status,Tout)

global rootdir_
Oenv = env;
%OTout = Tout;
infile = status.inFiring;

%% ==< conf >==
%%Oenv.Hz = NaN; % if you know, set this.
Oenv.Hz.video = 1000; % Kim
%% ==</conf >==
%%
load(infile); % load time serise of firing 'X'
I = X;
%%

Oenv.spar = NaN;
Oenv.hnum = NaN;
Oenv.hwind = NaN;
Oenv.SELF_DEPRESS_BASE = NaN;

[Oenv.genLoop Oenv.cnum] = size(I);
%{
flag = (Oenv.genLoop > env.useFrame);
Oenv.useFrame = env.useFrame.*flag;
%}

if isfield(Oenv,'Hz') && isfield(Oenv.Hz,'video') 
  OTout.simtime = Oenv.genLoop/Oenv.Hz.video;
  OTout.FiringRate = sum(I,1)/Oenv.Hz.video;
else
  OTout = NaN;
end

% $$$ if Oenv.useFrame < Oenv.genLoop
% $$$   I = I((end+1 - Oenv.useFrame):end,:);
% $$$ end
