function setpaths(rootdir_);
if exist('rootdir_')
  rundir = rootdir_;
else
  rundir = pwd;
  rundir = regexprep(rundir,'(.*/)(.*$)','$1');
end

addpath([rundir '/conf/']);
addpath([rundir '/dal_mod/']);
addpath([rundir '/dal_ver1.05/']);
addpath([rundir '/mylib/']);
addpath([rundir '/mylib/check']);
addpath([rundir '/mylib/conv']);
addpath([rundir '/mylib/eval']);
addpath([rundir '/mylib/gen']);
addpath([rundir '/mylib/get']);
addpath([rundir '/mylib/IO']);
addpath([rundir '/mylib/init']);
addpath([rundir '/mylib/plot']);
addpath([rundir '/mylib/postproc']);
addpath([rundir '/mylib/preproc']);
addpath([rundir '/mylib/print']);
addpath([rundir '/mylib/set']);

%% no need to set to run myest.m
addpath([rundir '/misc']);
addpath([rundir '/tools']);

%% under developement
%addpath([rundir '/mylib/eval']);
%% obsolete files are stored as backup
addpath([rundir '/mylib/obsolete']);
