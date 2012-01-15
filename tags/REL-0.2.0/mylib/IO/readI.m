function [ Oenv I OenvSummary] = readI(env,status,envSummary,varargin)
%% option)
%% X = varargin{1}: name of spike train to be loaded.
%% direction = varargin{2};: direction of sequence of X
argin_NUM = 3;
if nargin >= (argin_NUM + 1)
  X = varargin{1};
elseif isfield(env,'inFiringLabel')
  X = env.inFiringLabel;
else 
  error('set label of firing');
end
if nargin >= (argin_NUM + 2)
  direction = varargin{2};
elseif isfield(env,'inFiringDirect')
  direction = env.inFiringDirect;
else
  error('set direction of firing time serise.')
end

Oenv = env;
OenvSummary = envSummary; %?
infile = status.inFiring;

%% ==< conf >==
Ostatus.GEN_Neuron_individuality = NaN;
Ostatus.GEN_TrueValues = NaN;
Oenv.spar.from = NaN;
Oenv.spar.to = NaN;
Oenv.hnum = NaN;
Oenv.hwind = NaN;
Oenv.SELF_DEPRESS_BASE = NaN;

%% ==</conf >==
%%
if strcmp('debug','debug')
LD = load(infile,num2str(X));
X = eval(strcat('LD.',sprintf('%s',X))); % o gaya, x KIM
else
load(infile,num2str(X));
X = eval(num2str(X)); % o gaya, x KIM
%X = eval(X); % o gaya
%X = eval('X'); % x gaya, o kim
end
%% load time serise of firing 'X'
%% from Kim's data
%CHN:channel, SMP:number of flame, TRL:number of trial
[CHN SMP TRL] = size(X);

if (direction == 2) % concatenate all firing data
  I = zeros(CHN,SMP*TRL);
  for i1 = 1: TRL
    I(1:CHN,(1:SMP) + (i1-1) * SMP) = X(1:CHN,1:SMP,i1);
  end
  I = transpose(I); % set I's sequence (direction == 1 ).
elseif (direction == 1)
  tmp = CHN;
  CHN = SMP;
  SMP = tmp;
  I = zeros(SMP*TRL,CHN);
  for i1 = 1: TRL
    I((1:SMP) + (i1-1) * SMP,1:CHN) = X(1:SMP,1:CHN,i1);
  end
end
%% basic direction of time serise is 1 throuhout this software.

[Oenv.genLoop Oenv.cnum] = size(I);
%{
direction = (Oenv.genLoop > env.useFrame);
Oenv.useFrame = env.useFrame.*direction;
%}

if isfield(Oenv,'Hz') && isfield(Oenv.Hz,'video') 
  OenvSummary.simtime = Oenv.genLoop/Oenv.Hz.video;
  OenvSummary.FiringRate = sum(I,1)/Oenv.Hz.video;
else
  OenvSummary = NaN;
end

if isfield(env,'inFiringUSE')
else
Oenv.inFiringUSE = CHN;
end

