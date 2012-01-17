#!/bin/sh
##==< edit for your own.>==
PDFPREFIX=formatted_forHandout
LATEX=latex
DVI=dvipdfm
WHAT=(. mylib tools misc) # relative directory from ${ROOT}
SEPALATOR='$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
ROOT="" ## EDIT THIS LINE TO POINT TO ABSOLUTE PATH IF YOU MOVED THIS FILE TO ELSEWHERE.
CLEAN=1 ## REMOVE outputfile except pdf files.
##==</edit for your own.>==

#######################################################################
_ROOT_=`dirname $0`
#p.160
if [ -z ${ROOT} ]; then
    cd ${_ROOT_}; cd ..; ROOT=`pwd`;
fi
#echo -e "_ROOT_:$_ROOT_\n ROOT :${ROOT}"
TEMPLATE=${ROOT}/mylib/handout_template.tex
#######################################################################
cd ${ROOT}/outdir/mcode
export TEXINPUTS=${TEXINPUTS}:${ROOT}/imports/
for i1 in `echo ${WHAT[*]}`
do
    echo "[[${i1}]]"
    case ${i1} in
	['.'])   IN0=`find ${ROOT}/ -maxdepth 1 -name '*.m' -print|egrep -v \(conf\|confidential\|imports\|indir\|man\|outdir\)`;;
	*)       IN0=`find ${ROOT}/${i1} -name '*.m' -print|egrep -v \(conf\|confidential\|imports\|indir\|man\|obsolete\|outdir\)`;;
    esac
    _TARGET_=${ROOT}/outdir/mcode/${PDFPREFIX}_${i1}
    _TARGET_TXT_=${PDFPREFIX}_${i1}.txt;
    touch  ${_TARGET_TXT_};
    echo   "initialized ${_TARGET_}.txt";
    for i2 in ${IN0}
    do
	echo -e "\n${SEPALATOR}   ${i2}   ${SEPALATOR}\n" >> ${_TARGET_}.txt;
#	echo -e '\n${SEPALATOR}'   '${i2}'   '${SEPALATOR}\n' >> ${_TARGET_}.txt;
	cat -b ${i2} >> ${_TARGET_}.txt;
    done
    sed s/__INSERT__/`echo ${_TARGET_TXT_}`/ < ${TEMPLATE} >${_TARGET_}.tex
    echo "Now converting m-files under directory '${i1}' to latex file"
    ${LATEX} ${_TARGET_}.tex 1>/dev/null
    echo -n "Now converting the latex file to pdf"
    ${DVI} ${_TARGET_}.dvi 1>&2 2>/dev/null 
    echo "${_TARGET_}.pdf was wrote"
    echo -e "\n"
done

if [ "${CLEAN}" = "1" ]; then
    rm *.txt *.tex *.aux *.dvi *.log
fi
