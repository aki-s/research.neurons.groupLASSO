function echo_initStatus(env,status,Tout)

fprintf(1,'\t==  env  == \n');
disp(env);
fprintf(1,'\t== status ==\n'); 
disp(status);
% $$$ if status.READ_FIRING == 0
  fprintf(1,'\t== Tout ==\n'); 
  disp(Tout);
% $$$ end

%fprintf(1,'Total history width %f[sec]\n',hnum*hwind/Hz.video);
%fprintf(1,'Time of simulation %f[sec]\n',Tout.simtime);
