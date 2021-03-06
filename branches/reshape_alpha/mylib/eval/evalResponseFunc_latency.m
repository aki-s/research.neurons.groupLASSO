function [ latency peak ] = evalResponseFunc_latency( A )
%% usage)
%load('outdir/23-Oct-2011-start-20_50/Aki-0000008-rec072b-0044976-020.mat');
% [ latency peak ] = evalResponseFunc_latency(ResFunc);

[N1, N2, M] = size( A );

peak = zeros(N1, N2);
l = zeros(1,2);
p = zeros(1,2);
latency =zeros(N1, N2);
for i=1:N1 % to
  for c=1:N2 % from
    b = reshape( A(i,c,:), 1, M );
    %% detect zero connection
    if b == 0
      peak(i,c) = nan;
      latency(i,c) = nan;
else
    %%
    [p(1,2) l(1,2)] = max(b);
    [p(1,1) l(1,1)] = min(b);
    [val which] = sort(abs(p));
    if ( p(1,1) * p(1,2) > 0 ) % same sign
      if sign( p(1,1) ) < 0 
        peak(i,c) = p(1,1);
        latency(i,c) = l(1,1);
      else
        peak(i,c) = p(1,2);
        latency(i,c) = l(1,2);
      end
    else
      %      peak(i,c) = val(2)*sign(p(which(2)));
      peak(i,c) = p(1,which(2));
      latency(i,c) = l(1,which(2));
    end
    end
  end
end

%% example
%{
j0=c( (sum(evalResponseFunc(ResFunc) >0 )) >0);

[a b]=sort(sum(evalResponseFunc(ResFunc)>0),'descend')
%}
%{
cnum=20;
j0=1:cnum;
A = zeros(cnum);
for th = 0.1:0.1:1A=zeros(cnum);
A=A+(evalResponseFunc_peak(ResFunc)>th);
A=A-(evalResponseFunc_peak(ResFunc)<-th);
A(logical(eye(cnum))) = 0;
figure
[mx, my] = plot_ROI( u, j0 ); 
draw_connection( A, mx, my );
title(sprintf('%f',th));
end
%}
