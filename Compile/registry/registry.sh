#!/bin/bash

REPO="github.com/docker/distribution"
TAG="v2.2.1"
PWD=`pwd`
OUT=${PWD}/out
###############################################################
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $PWD
source $GOPATH/src/$RELY/library.sh

SUBDIRS="
	$OUT/registry
	$OUT/registry/bin
"
func_create_dirs $OUT $SUBDIRS

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}/cmd/registry; godep go build;\
	cp -f  registry ${OUT}/registry/bin; \
	cp -rf *.yml ${OUT}/registry; \
	cd $PWD;

config=${OUT}/registry/config
echo "declare -A CONFIGS" >$config
echo "CONFIGS[config]=''"  >>$config

runfile=${OUT}/registry/registry.sh
echo "#!/bin/bash" > $runfile
echo "wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh"  >>$runfile
echo ". ./config"     >>$runfile
echo ". ./library.sh" >>$runfile
echo "if [ ! -d ./log ];then mkdir ./log; fi" >>$runfile
echo "func_service_template_1 ./bin/registry ./log  CONFIGS  \$1" >>$runfile
chmod +x $runfile
