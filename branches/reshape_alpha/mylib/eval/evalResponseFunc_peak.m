function [peak ] = evalResponseFunc_peak( A )

[N1, N2, M] = size( A );

peak = zeros(N1, N2);
for i=1:N1
  for c=1:N2
    b = reshape( A(i,c,:), 1, M );
    peak(i,c) = max(abs(b));
    sig = sign( sum( b(1:20) ) );
    peak(i,c) = peak(i,c) * sig;
  end
end

%% example
%{
j0=c( (sum(evalResponseFunc(ResFunc) >0 )) >0);

[a b]=sort(sum(evalResponseFunc(ResFunc)>0),'descend')
%}
%{
load('/home/shige-o/rec072b.mat')
load('outdir/23-Oct-2011-start-20_50/Aki-0000008-rec072b-0044976-020.mat');
cnum=20;
j0=1:cnum;

for th = 0.1:0.1:1
A=zeros(cnum);
A=A+(evalResponseFunc_peak(ResFunc)>th);
A=A-(evalResponseFunc_peak(ResFunc)<-th);
A(logical(eye(cnum))) = 0;
figure
[mx, my] = plot_ROI( u, j0 ); % ( mx(i) , my(i) ) は、i番目ROIの中
                              % 心座標
                              % 図のサイズを再設定
draw_connection( A, mx, my ); % A は接続行列
title(sprintf('%f',th));
end
%}