function [tbin,DELTA,Y,R,W,TAU]=getSpikeDataFromMATmodel01()
%FUNCTION: [tbin,Y,R,W,TAU]=getSpikeDataFromMATmodel01()
%   generates spike train data based on stochastic multi-timescale adaptive
%   threshold (MAT) model.
%
% [Notation]
%   P: Number of neurons in the network.
%   NBins: Number of time bins of the data set.
%   M: Number of exponential kernels.
%
% [Outputs]
%   tbin: NBins-dim row vector that represents a set of time bins.
%
%   DELTA: interval of time bins.
%
%   Y: P-by-NBins matrix that represents spike train data, where Y(i,n)
%   denotes the indicator whether the i-th neuron generates a spike a at
%   the n-th time bin (Y(i,n)=1) or not (Y(i,n)=0).
%
%   R: P-by-N matrix that represents time-variant mean firing rates, where
%   R(i,n) denotes the i-th neuron's firing rate at the n-th time bin.
%
%   W: P-by-(1+P*M) matrix that represents a set of model parameters, where
%   W(i,1) denotes the logarithm of autonomous file rate of the i-th neuron
%   and W(i,1+(j-1)*M+m) denotes the contribution of the m-th kernel of the
%   j-th neuron's spike to the i-th neuron's firing rate.
%
%   TAU: M-dim row vector that represents a set of time constants of
%   exponential kernels.

%%
%
% Time setting
%

MaxT=10000;         % Recording duration (Unit: [ms])
DELTA=0.1;          % Time interval of bins (Unit: [ms])
tbin=0:DELTA:MaxT;  % Time bins (Unit: [ms])

%%
%
% Model parameters
%

TAU=[2,5,20];         % Time constants of exponential kernels
weight1=40*[0,-1,1]/TAU(3);
weight2=150*[0,0,-1]/TAU(3);
W=[log(1/50), 0, 0, 0, 0, 0, 0; ...
    log(1/500), weight1, weight2];

%%
%
% Get constants
%

P=size(W,1);        % Number of neurons
M=length(TAU);      % Number of exponential kernels
NBins=length(tbin); % Number of time bins

%%
%
% Generate the data
%

Y=zeros(P,NBins);
R=zeros(P,NBins);
X=zeros(M*P,1);
Xcef=repmat(exp(-DELTA./TAU),[P,1])';
for n=1:NBins,
    Z=[1;X];
    R(:,n)=exp(W*Z);
    idx=rand(P,1)<(R(:,n)*DELTA);
    Y(idx,n)=1;
    X=X.*Xcef(:);
    Xinc=repmat(Y(:,n)',[M,1]);
    X=X+Xinc(:);
end
