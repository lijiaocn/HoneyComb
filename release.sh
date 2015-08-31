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
	cd $curpath
}

#1: CodeDir
#2: DestDir
func_k8s_export(){
	local KubernetesDir=$1
	local DestDir=$2

	local KubeApiserver=$KubernetesDir/_output/local/go/bin/kube-apiserver
	local KubeManager=$KubernetesDir/_output/local/go/bin/kube-controller-manager
	local KubeProxy=$KubernetesDir/_output/local/go/bin/kube-proxy
	local KubeScheduler=$KubernetesDir/_output/local/go/bin/kube-scheduler
	local Kubectl=$KubernetesDir/_output/local/go/bin/kubectl
	local Kubelet=$KubernetesDir/_output/local/go/bin/kubelet
	func_force_copy $DestDir $KubeApiserver $KubeManager $KubeProxy $KubeScheduler $Kubectl $Kubelet
}


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
#2: DestDir
func_Shell_export(){
	local ShellDir=$1
	local DestDir=$2
	func_force_copy $DestDir $ShellDir/*
}

#1: CodeDir
#2: DestDir
func_Config_export(){
	local ConfigDir=$1
	local DestDir=$2
	func_force_copy $DestDir $ConfigDir/*
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

func_prepare_release $ReleasePath

K8sDir=./ThirdParty/Kubernetes
func_k8s_clean      ${K8sDir}
func_k8s_compile    $K8sUrl $K8sBranch $K8sTag $K8sDir
func_k8s_export     ${K8sDir} $ReleasePath/export/App

FlannelDir=./ThirdParty/Flannel
func_flannel_clean    ${FlannelDir}
func_flannel_compile  $FlannelUrl $FlannelBranch $FlannelTag ${FlannelDir}
func_flannel_export   ${FlannelDir} ${ReleasePath}/export/App

EtcdDir=./ThirdParty/Etcd
func_etcd_clean      ${EtcdDir}
func_etcd_compile    $EtcdUrl $EtcdBranch $EtcdTag $EtcdDir 
func_etcd_export     ${EtcdDir}  ${ReleasePath}/export/App

RegistryDir=./ThirdParty/Registry
func_registry_clean      ${RegistryDir}
func_registry_compile    $RegistryUrl $RegistryBranch $RegistryTag $RegistryDir 
func_registry_export     ${RegistryDir}  ${ReleasePath}/export/App

func_Shell_export   ./Shell   ${ReleasePath}/export/Shell

#func_Config_export must be the last
func_Config_export  ${ClusterPath} ${ReleasePath}/export/Shell

cd ./Release
	tar -czvf $ReleaseName.tar.gz  $ReleaseName
	/bin/rm -rf $ReleaseName
	sha1sum  $ReleaseName.tar.gz  >$ReleaseName.sha1sum
cd $CurPath
