#!/bin/bash

. ./Shell/library.sh

Flag_Compile="true"

if [ "$1" == "pkg" ];then
	Flag_Compile="false"
fi

export PATH=$PATH:/usr/local/go/bin/

ThirdParty=ThirdParty
OutPut=OutPut
FinalPackage=${OutPut}/FinalPackage
Lastest=${FinalPackage}/lastest
Version=${FinalPackage}/`cat ./version`
Export=${OutPut}/export/
App=${Export}/App/
Logs=${Export}/Logs/
Data=${Export}/Data/
Shell=${Export}/Shell
func_create_dirs  ${ThirdParty} ${OutPut} ${FinalPackage} ${Lastest} ${Version} ${Export} $App $Logs $Data $Shell

#关联项目 Kubernetes
Kubernetes_Url="https://github.com/GoogleCloudPlatform/kubernetes.git"
Kubernetes_Dir="${ThirdParty}/Kubernetes"
Kubernetes_Tag="v0.18.2"
if [ "$Flag_Compile" == "true" ];then
	func_red_str "Start Compile ${Kubernetes_Dir}: "
	func_green_str "\t${Kubernetes_Url}"
	func_green_str "\t${Kubernetes_Tag}"
	func_error_cmd func_git_check_tag  $Kubernetes_Tag $Kubernetes_Dir $Kubernetes_Url
fi

func_kube_clean(){
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
}

if [ "$Flag_Compile" == "true" ];then
	curpath=`pwd`
	cd $Kubernetes_Dir
		func_kube_clean
		cd hack; func_error_cmd ./build-go.sh;cd ..
	cd $curpath
fi

KubeApiserver=$Kubernetes_Dir/_output/local/go/bin/kube-apiserver
KubeManager=$Kubernetes_Dir/_output/local/go/bin/kube-controller-manager
KubeProxy=$Kubernetes_Dir/_output/local/go/bin/kube-proxy
KubeScheduler=$Kubernetes_Dir/_output/local/go/bin/kube-scheduler
Kubectl=$Kubernetes_Dir/_output/local/go/bin/kubectl
Kubelet=$Kubernetes_Dir/_output/local/go/bin/kubelet
func_force_copy $App $KubeApiserver $KubeManager $KubeProxy $KubeScheduler $Kubectl $Kubelet

#关联项目 flannel
Flannel_Url="https://github.com/coreos/flannel.git"
Flannel_Dir="${ThirdParty}/Flannel"
Flannel_Tag="v0.4.1"
if [ "$Flag_Compile" == "true" ];then
	func_red_str "Start Compile ${Flannel_Dir}: "
	func_green_str "\t${Flannel_Url}"
	func_green_str "\t${Flannel_Tag}"
	func_error_cmd func_git_check_tag  $Flannel_Tag $Flannel_Dir $Flannel_Url
fi

if [ "$Flag_Compile" == "true" ];then
	curpath=`pwd`
	cd $Flannel_Dir
		func_error_cmd ./build
	cd $curpath
fi

Flanneld=$Flannel_Dir/bin/flanneld
func_force_copy $App $Flanneld

#关联项目 etcd
Etcd_Url="https://github.com/coreos/etcd.git"
Etcd_Dir="${ThirdParty}/Etcd"
Etcd_Tag="v2.0.11"
if [ "$Flag_Compile" == "true" ];then
	func_red_str "Start Compile ${Etcd_Dir}: "
	func_green_str "\t${Etcd_Url}"
	func_green_str "\t${Etcd_Tag}"
	func_error_cmd func_git_check_tag  $Etcd_Tag $Etcd_Dir $Etcd_Url
fi

if [ "$Flag_Compile" == "true" ];then
	curpath=`pwd`
	cd $Etcd_Dir
		func_error_cmd ./build
	cd $curpath
fi

Etcd=$Etcd_Dir/bin/etcd
Etcdctl=$Etcd_Dir/bin/etcdctl
func_force_copy $App $Etcd $Etcdctl

#Script Files
func_force_copy $Shell ./Shell/*
func_force_copy $Shell ./version

#################################### 打包 #####################################
TAR=${OutPut}/export.tar.gz
TAR_SHA1=${OutPut}/export_version
BASE=${Shell}/base.sh
BASE_SHA1=${OutPut}/base_version
FIRST_INSTALL=./first_install.sh

tar -czvf ${TAR} ${Export}
sha1sum ${TAR}  > ${TAR_SHA1}
sha1sum ${BASE} > ${BASE_SHA1}

func_force_copy ${Version} $TAR $TAR_SHA1 $BASE $BASE_SHA1
func_force_copy ${Lastest} $TAR $TAR_SHA1 $BASE $BASE_SHA1
func_force_copy ${FinalPackage} ${FIRST_INSTALL}
