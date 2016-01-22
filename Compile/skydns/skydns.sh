#!/bin/bash

REPO="github.com/skynetservices/skydns"
TAG="2.5.2d"
PWD=`pwd`
OUT=${PWD}/out/
###############################################################

if [ ! -d ${OUT} ];then
	mkdir -p ${OUT}
fi

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}; go build; mv skydns ${OUT}
