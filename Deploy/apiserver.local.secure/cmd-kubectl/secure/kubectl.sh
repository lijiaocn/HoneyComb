#!/bin/bash 

CURPATH=`pwd`
WORKDIR=`basename ${CURPATH}`

if [  ! -e kubeconfig.yml ];then
	sed -e "s/{USER}/${WORKDIR}/" ../config.yml  >./kubeconfig.yml
fi

Execute="../../bin/kubectl --kubeconfig=./kubeconfig.yml"
${Execute} $*
