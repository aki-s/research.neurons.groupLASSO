function transform_Ealpha(Ealpha,DAL,status,fire)
%
% transform_Ealpha(Ealpha,DAL,status,'fire_by')
global rootdir_
global env

%%
cnum = env.cnum;
frame = DAL.Drow;
regFac = DAL.regFac;
N = length(regFac);
method = status.method;
checkDirname = status.checkDirname;
%%
SIZE = 500; % SIZE > bases.ihbas.iht
Alpha_ = cell(1,N);
len = length(Ealpha{1}{1}{1}(:));
for i1 = 1:length(regFac)
  Alpha_{i1} = zeros(cnum,cnum,SIZE);
  for i1to =1:cnum
    for i2from =1:cnum
      Alpha_{i1}(i1to,i2from,1:len) = Ealpha{i1}{i1to}{i2from}(:);
      %      Alpha(i1to,i2from,:) = Ealpha{i1}{i1to}{i2from}(1:SIZE)
    end
  end
  %plotalpha(Alpha_{i1})
end
%%
for i1 = 1:N
  Alpha = Alpha_{i1};
  save([rootdir_  checkDirname,'/',method,'-', ...
        sprintf('%07d',regFac(i1)),'-',fire, ...
        sprintf('-%07d',frame),'.mat' ],'Alpha' );
end

