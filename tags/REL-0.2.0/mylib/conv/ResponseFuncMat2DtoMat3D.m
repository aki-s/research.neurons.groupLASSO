function [ResFunc] =  ResponseFuncMat2DtoMat3D(TResFunc)
%% transform response function
%% from 'TResFunc' to 'ResFunc'
%% 'TResFunc' is (cnum*hnum,cnum) 2D matrix
%% 'ResFunc' is (cnum,cnum,hnum) 3D matrix

[SIZE cnum] = size(TResFunc);
%%
hwidth = SIZE/cnum;
%%
ResFunc = zeros(cnum,cnum,hwidth);
for  i1to =1:cnum
  for i2from =1:cnum
    ResFunc(i1to,i2from,:) = TResFunc( (1:hwidth)+hwidth*(i2from-1), i1to);
  end
end

%{
global rootdir_
save([rootdir_  '/outdir/check_110814/TrueResponseResFunc.mat'],'ResFunc')
%}
