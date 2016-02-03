#!/bin/bash

REPO="github.com/kubernetes/kubernetes"
TAG="v1.1.4"
PWD=`pwd`
OUT=$PWD/out/
###############################################################

RELY="github.com/lijiaocn/LinuxShell"
SHELLTAG="master"
go get $RELY 2>/dev/null
cd $GOPATH/src/$RELY; git pull;git checkout $SHELLTAG;cd $PWD
source $GOPATH/src/$RELY/library.sh

SUBDIRS="
	$OUT/kube-apiserver 
	$OUT/kube-controller-manager 
	$OUT/kube-proxy 
	$OUT/kube-scheduler 
	$OUT/kubectl 
	$OUT/kubelet
"
SUBDIRS_BIN="
	$OUT/kube-apiserver/bin
	$OUT/kube-controller-manager/bin
	$OUT/kube-proxy/bin
	$OUT/kube-scheduler/bin
	$OUT/kubectl/bin
	$OUT/kubelet/bin
"

func_create_dirs $OUT $SUBDIRS $SUBDIRS_BIN

go get $REPO 2>/dev/null
cd $GOPATH/src/$REPO; git pull; git checkout  $TAG
cd $GOPATH/src/$REPO/hack; ./build-go.sh; \
	cp -f ../_output/local/go/bin/kube-apiserver           $OUT/kube-apiserver/bin/; \
	cp -f ../_output/local/go/bin/kube-controller-manager  $OUT/kube-controller-manager/bin/;\
	cp -f ../_output/local/go/bin/kube-proxy               $OUT/kube-proxy/bin/; \
	cp -f ../_output/local/go/bin/kube-scheduler           $OUT/kube-scheduler/bin/; \
	cp -f ../_output/local/go/bin/kubectl                  $OUT/kubectl/bin/; \
	cp -f ../_output/local/go/bin/kubelet                  $OUT/kubelet/bin/; \
	cd $PWD;

for i in $SUBDIRS
do
	basename=`basename $i`
	if [[ $basename == "kubectl" ]];then
		continue
	fi
	runfile=$i/${basename}.sh
	config=$i/config
#	func_gen_config_k8s $config $i/$basename -h

	echo "#!/bin/bash" > $runfile
	echo "wget -O library.sh https://raw.githubusercontent.com/lijiaocn/LinuxShell/master/library.sh"  >>$runfile
	echo ". ./config"     >>$runfile
	echo ". ./library.sh" >>$runfile
	echo "if [ ! -d ./log ];then mkdir ./log; fi" >>$runfile
	echo "func_service_template_1 ./bin/$basename ./log  CONFIGS  \$1" >>$runfile
	chmod +x $runfile
done

#cd $GOPATH/src/${REPO}/cluster/addons/dns/kube2sky; make kube2sky;
