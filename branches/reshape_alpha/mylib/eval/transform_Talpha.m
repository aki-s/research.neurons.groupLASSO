function transform_Talpha(Talpha)
%% transform response function
%% from 'Talpha' to 'Alpha'
%% 'Talpha' is (cnum*hnum,cnum) 2D matrix
%% 'Alpha' is (cnum,cnum,hnum) 3D matrix
global rootdir_


[SIZE cnum] = size(Talpha);
%%
hwidth = SIZE/cnum;
%%
Alpha = zeros(cnum,cnum,hwidth);
for  i1to =1:cnum
  for i2from =1:cnum
    %length(    Talpha( (1:hwidth)+hwidth*(i2from-1), i1to) )
    Alpha(i1to,i2from,:) = Talpha( (1:hwidth)+hwidth*(i2from-1), i1to);
    %    Alpha(i1to,i2from,1:SIZE) = reshape(Talpha( (1:hwidth)+hwidth*(i2from-1), i1to),[],1);
  end
end

%%
save([rootdir_  '/outdir/check_110814/TrueResponseAlpha.mat'],...
       'Alpha')


