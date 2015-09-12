#!/bin/bash
. ./base.sh

source ./config

#TODO there need more operations before stop service.


if [ "$RUNDIR" != "" ];then
	for i in `ls ${RUNDIR}`
	do
		/bin/bash ./$i stop
		rm  -rf ${RUNDIR}/$i
	done
fi
