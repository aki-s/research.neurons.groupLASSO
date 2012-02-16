#!/bin/sh
## ref.
## http://www.vub.ac.be/BFUCC/misc/NQS/examples.html#matlab
## http://www.clusterresources.com/torquedocs/2.1jobsubmission.shtml
#PBS -m abe
#PBS -l nodes=1:ppn=4
#PBS -M aki-s@sys.i.kyoto-u.ac.jp
####################################################################################
## set such as 'ROOT = `dirname myest.m`'
if [ 1 = 1 ];then
ROOT='/home/aki-s/svn.d/art_repo2/branches/reshape_alpha'
else
_ROOT_=`dirname $0`
cd ${_ROOT_}
export ROOT=`pwd`
echo ${ROOT}:debug
fi
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
