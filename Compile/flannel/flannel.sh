#!/bin/bash

REPO="github.com/coreos/flannel"
TAG="v0.5.5"
PWD=`pwd`
OUT=${PWD}/out/
###############################################################
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $PWD
source $GOPATH/src/$RELY/library.sh

SUBDIRS="
	$OUT/flanneld
"
func_create_dirs $OUT $SUBDIRS

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}; ./build;\
	cp -f bin/flanneld ${OUT}/flanneld;\
	cd $PWD;

config=${OUT}/flanneld/config
echo "declare -A CONFIGS" >$config
echo "CONFIGS[etcd-endpoints]='-etcd-endpoints='"  >>$config
echo "CONFIGS[etcd-prefix]='-etcd-prefix='"  >>$config
echo "CONFIGS[iface]='-iface='"  >>$config

runfile=${OUT}/flanneld/flanneld.sh
echo "#!/bin/bash" > $runfile
echo "wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh"  >>$runfile
echo ". ./config"     >>$runfile
echo ". ./library.sh" >>$runfile
echo "if [ ! -d ./log ];then mkdir ./log; fi" >>$runfile
echo "func_service_template_1 ./flanneld ./log  CONFIGS  \$1" >>$runfile
chmod +x $runfile
