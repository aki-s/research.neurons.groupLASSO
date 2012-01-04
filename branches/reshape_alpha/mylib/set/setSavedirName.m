function [savedirname] = setSavedirName(rootdir_,status)
tmp0 = status.time.start;
mkdirname = [date,'-start-',num2str(tmp0(4)),'_',num2str(tmp0(5))];
mkdir( [ rootdir_ '/outdir/'],mkdirname)
savedirname =  [ rootdir_ '/outdir/',mkdirname];

