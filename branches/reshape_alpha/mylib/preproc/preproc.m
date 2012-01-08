
status.time.start = fix(clock);
[status.savedirname] = setSavedirName(rootdir_,status);
%% write out MATLAB stdout as log
diary([status.savedirname,'/',sprintf('%d_',status.time.start),'diary.txt'])
