function echo_initStatus(env,status,envSummary)

fprintf(1,'\t==  env  == \n');
disp(env);
fprintf(1,'\t== status ==\n'); 
disp(status);
%if env.cnum < 15
  fprintf(1,'\t== envSummary ==\n'); 
  disp(envSummary);
  %end



