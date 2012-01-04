function init_crossVal(infile_root,infile_)
[DAL] = conf_DAL(); % configuration for solver 'DAL'.
DAL = setDALregFac(env,DAL,bases);

% get regFac and number of frmaes used
k = length(infile_);
infile_name = cells(i1,1);
for i1 = 1:k
  infile_name{i1} = regexprep(infle_{i1},'(.*/)(.*$)','$2');
end
[fac] = get_regFac()
[fm ] = get_usedFrame()
[,idx] = sort()

use = ( fac & fm )
crossIdx = infile_{ use }
env.genLoop
