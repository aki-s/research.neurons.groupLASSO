#!/bin/sh
## You can use this program if you use bash.
## set PBS_O_WORKDIR, to which files reporting progress is written, at .bash_profile by referring the next line
# export PBS_O_WORKDIR=/home/aki-s/mypbs

############################################################################
PBSLOG=1
############################################################################

#export BASED=`dirname $0` # I couldn't export, why?
BASED=`dirname $0`
if [ "${PBSLOG}" = 1 ]; then
    qsub  -o ${PBS_O_WORKDIR} -e ${PBS_O_WORKDIR} ${BASED}/throwPBS.sh 
else
    qsub ${BASED}/throwPBS.sh 
fi
echo "Throwed ${BASED}/myest.m to PBS..."
