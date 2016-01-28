#!/bin/bash

REPO="github.com/skynetservices/skydns"
TAG="2.5.2d"
RUNPATH=`pwd`
OUT=${RUNPATH}/out/
###############################################################
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $RUNPATH
source $GOPATH/src/$RELY/library.sh

if [ ! -d ${OUT} ];then
	mkdir -p ${OUT}
fi

SUBDIRS="
	$OUT/skydns
"
func_create_dirs $OUT $SUBDIRS

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}; go build; mv skydns ${OUT}/skydns/
