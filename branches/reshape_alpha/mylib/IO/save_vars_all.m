fprintf(1,'Saving variables....\n');
if status.use.GUI == 1
  run my_uisave
else 
  run my_autoSave
end
