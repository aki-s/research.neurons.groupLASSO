status.outputfilename = setSavedDataName(status.savedirname,status.time);
save(status.outputfilename);
fprintf(1,'outputfilename:\n %s\n',status.outputfilename)
