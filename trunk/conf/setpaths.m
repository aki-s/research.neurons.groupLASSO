function setpaths(rootdir_);
if exist('rootdir_')
rundir = rootdir_;
else
rundir = pwd;
rundir = regexprep(rundir,'(.*/)(.*$)','$1');
end

addpath([rundir '/conf/']);
addpath([rundir '/dal_mod/']);
addpath([rundir '/mylib/']);
addpath([rundir '/mylib/gen']);
addpath([rundir '/mylib/plot']);

%% no need to set to run myest.m
addpath([rundir '/misc']);
addpath([rundir '/tools']);