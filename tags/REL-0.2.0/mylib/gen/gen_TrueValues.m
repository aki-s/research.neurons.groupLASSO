tic;
[ResFunc ] = gen_TrueResFunc(env,status,ResFunc_hash);
[ResFunc0] = gen_TrueWeightSelf(env,status);
[Iorg,lambda,loglambda] = gen_TrueI(env,ResFunc0,ResFunc);
run check_gendI
echo_TrueValueStatus(env,status,lambda,I);
status.time.gen_TrueValue = toc;
run([rootdir_ '/mylib/plot/plot_TrueValues']);
