#!/bin/sh
## You can use this program if you use bash.
## set PBS_O_WORKDIR, to which files reporting progress is written, at .bash_profile by referring the next line
# export PBS_O_WORKDIR=/home/aki-s/mypbs
# Also, you have to edit '#PBS' directive at ./bin/throwPBS.sh
############################################################################
PBSLOG=1
# It seems high useability than qsub_myest_nice.sh though this script don't run
# myest.m via nice command.
############################################################################
BASED=`dirname $0`
if [ "${PBSLOG}" = 1 ]; then
    qsub  -o ${PBS_O_WORKDIR} -e ${PBS_O_WORKDIR} ${BASED}/bin/throwPBS.sh 
else
    qsub ${BASED}/throwPBS.sh 
fi
echo "Throwed ${BASED}/myest.m to PBS..."
