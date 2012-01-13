#!/bin/sh
## http://www.vub.ac.be/BFUCC/misc/NQS/examples.html#matlab
#PBS -m abe
#PBS -l nodes=1:ppn=4
####################################################################################
## set such as 'ROOT = `dirname myest.m`'
ROOT='/home/aki-s/svn.d/art_repo2/branches/reshape_alpha'
####################################################################################
BAR='===================================================================='
LOG=${PBS_O_WORKDIR}/`date +"%y%m%d_%H%M%S"`.log;
echo "${BAR}\n"
echo "correspond with ${LOG}."
echo "${BAR}\n"
cd $PBS_O_WORKDIR
# 1. Don't give '-nojvm' option becase matlabpool require it.
# 2. I recommend using option '-logfile' becase diary() is meaningless if there was a runtime error.
/usr/local/bin/matlab  -logfile ${LOG} -nodisplay -nosplash  <<EOF
fprintf('present working directory:%s\n',pwd())

cd ${ROOT}
run ./myest.m

quit()
EOF
#echo 'finished'
