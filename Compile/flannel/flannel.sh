#!/bin/bash

REPO="github.com/coreos/flannel"
TAG="v0.5.5"
RUNPATH=`pwd`
OUT=${RUNPATH}/out/
###############################################################
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $RUNPATH
source $GOPATH/src/$RELY/library.sh

SUBDIRS="
	$OUT/flanneld
	$OUT/flanneld/bin
"
func_create_dirs $OUT $SUBDIRS

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}; ./build;\
	cp -f bin/flanneld ${OUT}/flanneld/bin/;\
	cd $RUNPATH;

#config=${OUT}/flanneld/config
#echo "declare -A CONFIGS" >$config
#echo "CONFIGS[etcd-endpoints]='-etcd-endpoints=http://localhost:2379'"  >>$config
#echo "CONFIGS[etcd-prefix]='-etcd-prefix=kubernetes/network/flannel'"  >>$config
#echo "CONFIGS[iface]='-iface=eth1'"  >>$config

runfile=${OUT}/flanneld/flanneld.sh
echo "#!/bin/bash" > $runfile
echo "wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh"  >>$runfile
echo ". ./config"     >>$runfile
echo ". ./library.sh" >>$runfile
echo "if [ ! -d ./log ];then mkdir ./log; fi" >>$runfile
echo "func_service_template_1 ./bin/flanneld ./log  CONFIGS  \$1" >>$runfile
chmod +x $runfile
