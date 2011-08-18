function [] = debug_formEAlpha(Ealpha,DAL,method,fire)
%
%  debug_formEAlpha(Ealpha,DAL,'method_name','fire_by')
global rootdir_
global env

%%
cnum = env.cnum;
frame = DAL.Drow;
% $$$ if 1 == 0
% $$$   regFac = [ 100, 50,10,5 ];
% $$$ elseif 1 == 0
% $$$   regFac = [3000 1000 300];
% $$$ elseif 1== 0
% $$$   regFac = [10 1 0.1 0.01];
% $$$ end
regFac = DAL.regFac
%%
SIZE = 500; % SIZE > bases.ihbas.iht
Alpha = zeros(cnum,cnum,SIZE);
for i1 = 1:length(regFac)
  for i1to =1:cnum
    for i2from =1:cnum
      Alpha(i1to,i2from,:) = Ealpha{i1}{i1to}{i2from}(1:SIZE);
    end
  end
end
%%
for i1 = 1:length(regFac)
  save([rootdir_  '/outdir/check_110814/',method,'_', ...
        sprintf('%d',regFac(i1)),'_',fire, ...
        sprintf('%d',frame),'.mat' ],'Alpha' );
% $$$         sprintf('%06d',regFac(i1)),'_',fire, ...
% $$$         sprintf('%06d',frame),'.mat' ],'Alpha' );
end

