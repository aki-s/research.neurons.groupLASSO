#!/bin/sh
## You can use this program if you use bash.
## set PBS_O_WORKDIR, to which files reporting progress is written, at .bash_profile by referring the next line
# export PBS_O_WORKDIR=/home/aki-s/mypbs
# Also, you have to edit '#PBS' directive at ./bin/throwPBS.sh
############################################################################
# This file wouldn't run on computer other than ISHII labo, becase qsh command
# would be ISHII labo specific. Please use qsub_myest.sh instead.
# This script run myest.m via nice command.
############################################################################
_BASED_=`dirname $0`
cd ${_BASED_}
export BASED=`pwd`
qsh ${BASED}/bin/throwPBS.sh 


echo "Throwed ${BASED}/myest.m to PBS..."
