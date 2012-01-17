if strcmp('configure', 'configure')
  conf_progress();
  [DAL] = conf_DAL(); % configuration for solver 'DAL'.
  [env status ] = conf_IO(env,status);
  graph = conf_graph();
  run([rootdir_ '/conf/conf_rand.m']);%++notyet
  bases = conf_BasisStruct_glm(); % load parameters.
  run([rootdir_ '/conf/conf_mail.m']);% notify the end of program via mail.
end

%% Reading user custom configuration file
%%  overrides all configurations previously set.
switch 'kim'
  case 'demo'
    status.userDef = [rootdir_ '/conf/conf_user.m'];
  case 'aki'
    status.userDef = [rootdir_ '/conf/conf_user_aki.m'];
  case 'gaya'
    status.userDef = [rootdir_ '/conf/conf_user_gaya.m'];
  case 'kim'
    %  status.userDef = [rootdir_ '/conf/conf_user_kim.m'];
    %    status.userDef = [rootdir_ '/conf/conf_user_kim_20111110_185429.m']; %
    status.userDef = [rootdir_ '/conf/conf_user_kim_20120118.m'];
end

run(status.userDef);
