#!/bin/bash

REPO="github.com/coreos/etcd"
TAG="v2.2.4"
PWD=`pwd`
OUT=${PWD}/out/
###############################################################
RELY="github.com/lijiaocn/LinuxShell"
TAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $TAG;cd $PWD
source $GOPATH/src/$RELY/library.sh

SUBDIRS="
	$OUT/etcd
	$OUT/etcdctl
"
func_create_dirs $OUT $SUBDIRS

go get $REPO
cd $GOPATH/src/${REPO}; git pull; git checkout  $TAG
cd $GOPATH/src/${REPO}; ./build; \
	cp -f bin/etcd    ${OUT}/etcd; \
	cp -f bin/etcdctl ${OUT}/etcdctl; \
	cd $PWD;

config=${OUT}/etcd/config
echo "declare -A CONFIGS" >$config
echo "CONFIGS[name]='--name='"  >>$config
echo "CONFIGS[data-dir]='--data-dir='"  >>$config
echo "CONFIGS[wal-dir]='--wal-dir='"  >>$config
echo "CONFIGS[snapshot-count]='--snapshot-count='"  >>$config
echo "CONFIGS[heartbeat-interval]='--heartbeat-interval='"  >>$config
echo "CONFIGS[election-timeout]='--election-timeout='"  >>$config
echo "CONFIGS[listen-peer-urls]='--listen-peer-urls='"  >>$config
echo "CONFIGS[listen-client-urls]='--listen-client-urls='"  >>$config
echo "CONFIGS[cors]='-cors='"  >>$config
echo "CONFIGS[initial-advertise-peer-urls]='--initial-advertise-peer-urls='"  >>$config
echo "CONFIGS[initial-cluster]='--initial-cluster='"  >>$config
echo "CONFIGS[initial-cluster-state]='--initial-cluster-state='"  >>$config
echo "CONFIGS[initial-cluster-token]='--initial-cluster-token='"  >>$config
echo "CONFIGS[advertise-client-urls]='--advertise-client-urls='"  >>$config

runfile=${OUT}/etcd/etcd.sh
echo "#!/bin/bash" > $runfile
echo "wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh"  >>$runfile
echo ". ./config"     >>$runfile
echo ". ./library.sh" >>$runfile
echo "if [ ! -d ./log ];then mkdir ./log; fi" >>$runfile
echo "func_service_template_1 ./etcd ./log  CONFIGS  \$1" >>$runfile
chmod +x $runfile
