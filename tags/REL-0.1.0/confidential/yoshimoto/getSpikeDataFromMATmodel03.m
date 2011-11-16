function [tbin,DELTA,Y,R,W,TAU]=getSpikeDataFromMATmodel03()
%FUNCTION: [tbin,Y,R,W,TAU]=getSpikeDataFromMATmodel03()
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

MaxT=30000;         % Recording duration (Unit: [ms])
DELTA=0.1;          % Time interval of bins (Unit: [ms])
tbin=0:DELTA:MaxT;  % Time bins (Unit: [ms])

%%
%
% Model parameters
%

P=6;
TAU=[2,5,10,20];      % Time constants of exponential kernels
M=length(TAU);        % Number of exponential kernels
W=zeros(P,1+P*M);

% For self-regulation 1
ii=1;
jj=1;
weight=0*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/100),weight];

% For self-regulation 2
ii=2;
jj=2;
weight=-50*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/100),weight];


% For self-regulation 3
ii=3;
jj=3;
weight=-50*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/100),weight];

% For self-regulation 4
ii=4;
jj=4;
weight=-50*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/200),weight];

% For self-regulation 5
ii=5;
jj=5;
weight=-50*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/50),weight];

% For self-regulation 6
ii=6;
jj=6;
weight=-50*[1,0,0,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,[1,index1:index2])=[log(1/50),weight];


% For 1->2 connection
ii=2;
jj=1;
weight=3*[0,-1,0,+1];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 1->3 connection
ii=3;
jj=1;
weight=3*[0,0,-1,+1];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 2->4 connection
ii=4;
jj=2;
weight=3*[0,-1,0,+1];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 3->4 connection
ii=4;
jj=3;
weight=5*[0,0,-1,+1];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 4->5 connection
ii=5;
jj=4;
weight=-10*[0,-1,+1,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 4->6 connection
ii=6;
jj=4;
weight=-10*[0,-1,+1,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

% For 5->2 connection
ii=2;
jj=5;
weight=-10*[0,-1,+1,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;


% % For 5->4 connection
% ii=4;
% jj=5;
% weight=-20*[-1,+1,0]/[TAU(2)-TAU(1)];
% index1=1+(jj-1)*M+1;
% index2=1+jj*M;
% W(ii,index1:index2)=weight;


% For 6->4 connection
ii=4;
jj=6;
weight=-20*[0,-1,+1,0];
index1=1+(jj-1)*M+1;
index2=1+jj*M;
W(ii,index1:index2)=weight;

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
