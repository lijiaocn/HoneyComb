#!/bin/bash

. ./Shell/library.sh

export PATH=$PATH:/usr/local/go/bin/

#1: CodeDir
func_k8s_clean(){
	local curpath=`pwd`
	if [ ! -d $1 ];then
		return 
	fi
	cd $1
		godep_pkg="Godeps/_workspace/pkg"
		if [ -e ${godep_pkg} ];then
			/bin/rm -rf ${godep_pkg}
		fi

		godep_bin="Godeps/_workspace/bin"
		if [ -e ${godep_bin} ];then
			/bin/rm -rf ${godep_bin}
		fi

		kube_output="_output"
		if [ -e ${kube_output} ];then
			/bin/rm -rf ${kube_output}
		fi
	cd $curpath
}

#$1:url
#$2:branch
#$3:tag
#$4:dir
func_k8s_compile(){
	local K8sUrl=$1
	local K8sBranch=$2
	local K8sTag=$3
	local K8sDir=$4

	func_green_str "Start Compile ${K8sDir}: "
	func_green_str "\t${K8sUrl}"
	func_green_str "\t${K8sTag}"
	func_error_cmd func_git_check_tag  $K8sUrl $K8sBranch $K8sTag $K8sDir

	func_k8s_clean ${K8sDir}

	local curpath=`pwd`
	cd $K8sDir
		cd hack; func_error_cmd ./build-go.sh;cd ..
		cd cluster/addons/dns/kube2sky; make kube2sky;cd ../../../../
	cd $curpath
}

##1: CodeDir
##2: DestDir
#func_k8s_export(){
#	local KubernetesDir=$1
#	local DestDir=$2
#
#	local KubeApiserver=$KubernetesDir/_output/local/go/bin/kube-apiserver
#	local KubeManager=$KubernetesDir/_output/local/go/bin/kube-controller-manager
#	local KubeProxy=$KubernetesDir/_output/local/go/bin/kube-proxy
#	local KubeScheduler=$KubernetesDir/_output/local/go/bin/kube-scheduler
#	local Kubectl=$KubernetesDir/_output/local/go/bin/kubectl
#	local Kubelet=$KubernetesDir/_output/local/go/bin/kubelet
#	local Kube2sky=$KubernetesDir/cluster/addons/dns/kube2sky/kube2sky
#	func_force_copy $DestDir $KubeApiserver $KubeManager $KubeProxy $KubeScheduler $Kubectl $Kubelet $Kube2sky
#}


#1: CodeDir
func_flannel_clean(){
	return
}

#$1:url
#$2:branch
#$3:tag
#$4:dir
func_flannel_compile(){

	local FlannelUrl=$1
	local FlannelBranch=$2
	local FlannelTag=$3
	local FlannelDir=$4

	func_green_str "Start Compile ${FlannelDir}: "
	func_green_str "\t${FlannelUrl}"
	func_green_str "\t${FlannelTag}"
	func_error_cmd func_git_check_tag  $FlannelUrl $FlannelBranch $FlannelTag $FlannelDir 

	curpath=`pwd`
	cd $FlannelDir
		func_error_cmd ./build
	cd $curpath

}

#1: CodeDir
#2: DestDir
func_flannel_export(){
	local FlannelDir=$1
	local DestDir=$2

	local Flanneld=$FlannelDir/bin/flanneld
	func_force_copy $DestDir $Flanneld
}

#1: CodeDir
func_etcd_clean(){
	return
}

#$1:url
#$2:branch
#$3:tag
#$4:dir
func_etcd_compile(){

	local EtcdUrl=$1
	local EtcdBranch=$2
	local EtcdTag=$3
	local EtcdDir=$4

	func_green_str "Start Compile ${EtcdDir}: "
	func_green_str "\t${EtcdUrl}"
	func_green_str "\t${EtcdTag}"
	func_error_cmd func_git_check_tag  $EtcdUrl $EtcdBranch $EtcdTag $EtcdDir 

	curpath=`pwd`
	cd $EtcdDir
		func_error_cmd ./build
	cd $curpath
}

#1: CodeDir
#2: DestDir
func_etcd_export(){
	local EtcdDir=$1
	local DestDir=$2

	local Etcd=$EtcdDir/bin/etcd
	local Etcdctl=$EtcdDir/bin/etcdctl
	func_force_copy $DestDir $Etcd $Etcdctl
}

#1: CodeDir
func_registry_clean(){
	return
}

#$1:url
#$2:branch
#$3:tag
#$4:dir
func_registry_compile(){

	local RegistryUrl=$1
	local RegistryBranch=$2
	local RegistryTag=$3
	local RegistryDir=$4

	func_green_str "Start Compile ${RegistryDir}: "
	func_green_str "\t${RegistryUrl}"
	func_green_str "\t${RegistryTag}"
	func_error_cmd func_git_check_tag  $RegistryUrl $RegistryBranch $RegistryTag $RegistryDir 

	curpath=`pwd`
	cd $RegistryDir
		func_error_cmd  cd cmd/registry && godep build 
	cd $curpath
}

#1: CodeDir
#2: DestDir
func_registry_export(){
	local RegistryDir=$1
	local DestDir=$2

	local Registry=$RegistryDir/cmd/registry/registry
	func_force_copy $DestDir $Registry 
}

#1: CodeDir
func_skydns_clean(){
	return
}

#$1:url
#$2:branch
#$3:tag
#$4:dir
func_skydns_compile(){

	local SkyDnsUrl=$1
	local SkyDnsBranch=$2
	local SkyDnsTag=$3
	local SkyDnsDir=$4

	func_green_str "Start Compile ${SkyDnsDir}: "
	func_green_str "\t${SkyDnsUrl}"
	func_green_str "\t${SkyDnsTag}"
	func_error_cmd func_git_check_tag  $SkyDnsUrl $SkyDnsBranch $SkyDnsTag $SkyDnsDir 

	curpath=`pwd`
	cd $SkyDnsDir
		func_error_cmd  go build
	cd $curpath
}

#1: CodeDir
#2: DestDir
func_skydns_export(){
	local SkyDnsDir=$1
	local DestDir=$2

	local SkyDns=$SkyDnsDir/skydns
	func_force_copy $DestDir $SkyDns 
}

#$1: ReleaseName
#$2: ReleaseDir
func_prepare_release(){
	local ReleasePath=$1
	local Export=${ReleasePath}/export
	local App=${Export}/App/
	local Logs=${Export}/Logs/
	local Data=${Export}/Data/
	local Shell=${Export}/Shell

	func_create_dirs ${Export} $App $Logs $Data $Shell  $Data/registry

}


CurPath=`pwd`
func_yellow_str "`ls ${CurPath}/Config`"
echo -n "Choose the Cluster:"
read Cluster

echo  "Have you finished these config ?"
func_red_str  "\t./${Cluster}/config"
func_red_str  "\t./${Cluster}/Shell/config-global/base.sh"
func_red_str  "\t./AuthnAuthz/${Cluster}/setup.sh"
echo  -n "[Y|N]: "
read  XXXX

if [[ ${XXXX} != "Y" ]];then
	echo "exit"
	exit
fi

ClusterPath=${CurPath}/Config/${Cluster}
if [ ! -d $ClusterPath ];then
	func_red_str "Not Find: $ClusterPath"
	exit 1
fi

ClusterConfig=$ClusterPath/config 
if [ ! -e $ClusterConfig ];then
	func_red_str "Not Find: $ClusterConfig"
	exit 1
fi

source ${ClusterConfig}
source ./version
ReleaseName="${Cluster}-${SelfVersion}--${HostSystem}--HoneyComb-${HoneyCombVersion}"
ReleasePath="./Release/$ReleaseName"

K8sDir=./ThirdParty/Kubernetes
func_k8s_clean      ${K8sDir}
func_k8s_compile    $K8sUrl $K8sBranch $K8sTag $K8sDir

FlannelDir=./ThirdParty/Flannel
func_flannel_clean    ${FlannelDir}
func_flannel_compile  $FlannelUrl $FlannelBranch $FlannelTag ${FlannelDir}

EtcdDir=./ThirdParty/Etcd
func_etcd_clean      ${EtcdDir}
func_etcd_compile    $EtcdUrl $EtcdBranch $EtcdTag $EtcdDir 

RegistryDir=./ThirdParty/Registry
func_registry_clean      ${RegistryDir}
func_registry_compile    $RegistryUrl $RegistryBranch $RegistryTag $RegistryDir 

SkyDnsDir=./ThirdParty/skydns
func_skydns_clean      ${SkyDnsDir}
func_skydns_compile    $SkyDnsUrl $SkyDnsBranch $SkyDnsTag $SkyDnsDir 

#1: Release Dir
#2: Cluster Dir
#3: Prefix
#4: App
make_package(){
	local ReleaseDir=$1
	local ClusterDir=$2
	local Prefix=$3
	local App=$4
	local PackageName=$Prefix-$App
	local PackagePath=${ReleaseDir}/${PackageName}

	if [ ! -d $PackagePath ];then
		mkdir -p $PackagePath
	else
		rm -rf $PackagePath
	fi

	local KubeApiserver=$K8sDir/_output/local/go/bin/kube-apiserver
	local KubeControlerManager=$K8sDir/_output/local/go/bin/kube-controller-manager
	local KubeProxy=$K8sDir/_output/local/go/bin/kube-proxy
	local KubeScheduler=$K8sDir/_output/local/go/bin/kube-scheduler
	local Kubectl=$K8sDir/_output/local/go/bin/kubectl
	local Kubelet=$K8sDir/_output/local/go/bin/kubelet
	local Kube2sky=$K8sDir/cluster/addons/dns/kube2sky/kube2sky

	func_prepare_release $PackagePath
	case "${App}" in
		(kube2sky)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube2sky;
			func_force_copy ${PackagePath}/export/App/  $Kube2sky;;
		(skydns)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/skydns;
			func_skydns_export          ${SkyDnsDir}  ${PackagePath}/export/App;;
		(Addons)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/Addons;;
		(config-global)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/config-global;;
		(docker)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/docker;;
		(etcd)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/etcd;
			func_etcd_export          ${EtcdDir}  ${PackagePath}/export/App;;
		(flannel)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/flannel;
			func_flannel_export      ${FlannelDir}  ${PackagePath}/export/App;;
		(registry)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/registry;
			func_registry_export     ${RegistryDir}  ${PackagePath}/export/App;;
		(kube-apiserver)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-apiserver;
			func_force_copy ${PackagePath}/export/App/  $KubeApiserver;;
		(kube-cli)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-cli;
			func_force_copy ${PackagePath}/export/App/  $Kubectl;;
		(kube-controller-manager)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-controller-manager;
			func_force_copy ${PackagePath}/export/App/  $KubeControlerManager;;
		(kube-kubelet)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-kubelet;
			func_force_copy ${PackagePath}/export/App/  $Kubelet;;
		(kube-proxy)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-proxy;
			func_force_copy ${PackagePath}/export/App/  $KubeProxy;;
		(kube-scheduler)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-scheduler;
			func_force_copy ${PackagePath}/export/App/  $KubeScheduler;;
		(allinone)
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube2sky;
			func_force_copy ${PackagePath}/export/App/  $Kube2sky;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/skydns;
			func_skydns_export          ${SkyDnsDir}  ${PackagePath}/export/App;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/Addons;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/*.sh;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/config-global;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/docker;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/etcd;
			func_etcd_export          ${EtcdDir}  ${PackagePath}/export/App;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/flannel;
			func_flannel_export      ${FlannelDir}  ${PackagePath}/export/App;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/registry;
			func_registry_export     ${RegistryDir}  ${PackagePath}/export/App;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-apiserver;
			func_force_copy ${PackagePath}/export/App/  $KubeApiserver;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-cli;
			func_force_copy ${PackagePath}/export/App/  $Kubectl;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-controller-manager;
			func_force_copy ${PackagePath}/export/App/  $KubeControlerManager;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-kubelet;
			func_force_copy ${PackagePath}/export/App/  $Kubelet;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-proxy;
			func_force_copy ${PackagePath}/export/App/  $KubeProxy;
			func_force_copy ${PackagePath}/export/Shell/  $ClusterDir/Shell/kube-scheduler;
			func_force_copy ${PackagePath}/export/App/  $KubeScheduler;;
		(*)
			func_red_str "Unkown compotent: $APP";;
	esac

	local curpath=`pwd`
	cd ${ReleaseDir}
		tar -czvf ${PackageName}.tar.gz  $PackageName
		/bin/rm -rf $PackageName
		sha1sum  ${PackageName}.tar.gz  >${PackageName}.sha1sum
	cd $curpath
}

make_packages(){
	for compotent in $*
	do
		make_package  ${ReleasePath} ${ClusterPath} ${Cluster}-${SelfVersion}--${HostSystem} "${compotent}"
	done
}

make_packages kube2sky skydns Addons config-global docker etcd flannel registry kube-apiserver kube-cli kube-controller-manager kube-kubelet kube-proxy kube-scheduler  allinone
