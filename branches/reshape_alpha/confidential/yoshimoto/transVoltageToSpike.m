function transVoltageToSpike(prefix,seed)
%TRANSVOLTAGETOSPIKE Summary of this function goes here
%   Detailed explanation goes here

% Set model index
mid=100;

% Load the data file
fname=sprintf('%s_%03d_voltage.dat',prefix,seed);
X=load(fname);

% Get the time bins
tbin=X(X(:,1)==1,2)';
NBins=length(tbin);

% Get the time interval
DELTA=tbin(2)-tbin(1);

% Get the number of neurons
P=size(X,1)/NBins;

V=zeros(P,NBins);
Y=zeros(P,NBins);

for ii=1:P
    V(ii,:)=X(X(:,1)==ii,3)';
    DV=[1,diff(V(ii,:))];
    idx1=V(ii,:)>-40;
    idx2=DV>0;
    Y(ii,idx1&idx2)=1;
    for n=sort(find(Y(ii,:)==1),'descend')
        if(Y(ii,n-1)==1)
           Y(ii,n)=0;
        end
    end
    %figure(1);
    %plot(tbin,V(ii,:));
end
%figure(1)
%plot(tbin,V);
%figure(2);
%drawSpikeTrain(tbin,Y);

fout_name=sprintf('%s_%03d',prefix,seed);
save(fout_name,'mid','tbin','Y','V','DELTA');
