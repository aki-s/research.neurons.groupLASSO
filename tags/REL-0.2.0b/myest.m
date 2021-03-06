%% Main program.
%% HowTo)
%% close all; clear all; myest
global env;
global status;
global Tout;
global graph;
global rootdir_;   rootdir_ = pwd;

run([rootdir_ '/conf/setpaths.m']);
run preproc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ==< configure >==
run set_myestConf
%% ==</ configure >==

if  (status.READ_FIRING == 1)
  [env I Tout] = readI(env,status,Tout);
end

%% set default params (compliment missing configure params)
gen_defaultEnv_ask(); 
run get_neuronStruct;
run set_bases;

[env status Tout graph DAL] = check_conf(env,status,Tout,graph,bases,DAL);
[status ] = check_gendConfState(status);
echo_initStatus(env,status,Tout)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( status.GEN_TrueValues == 1 ) 
  run gen_TrueValues
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if status.estimateConnection == 1
  run estimateNetworkStruct
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run postproc1

%% ==< bulk save all plotted graph  >==
if (graph.SAVE_ALL == 1)
    save_windows_all(status.savedirname)
end 

%% ==< clean >==
%% clean variables before save
if status.clean == 1
  run  clean
end

%% ==< save >==
if status.save_vars == 1
  run save_vars_all
end

%if status.estimateConnection == 1
if status.mail == 1
  mailMe(env,status,DAL,bases,'Finished myest.m')
end

run terminate
