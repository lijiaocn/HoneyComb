#!/bin/bash 

CURPATH=`pwd`
WORKDIR=`basename ${CURPATH}`

if [  ! -e kubeconfig.yml ];then
	sed -e "s/{USER}/${WORKDIR}/" ../config.yml  >./kubeconfig.yml
fi

Execute="/export/App/kubectl -s 127.0.0.1:8080  --kubeconfig=./kubeconfig.yml"
${Execute} $*
