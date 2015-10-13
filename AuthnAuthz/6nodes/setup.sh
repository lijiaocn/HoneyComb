#!/bin/bash

. ../../Shell/library.sh

create_dir(){
	if [ ! -d $1 ];then
		mkdir -p $1
	fi
}

collect_for_apiserver(){
	local authz="output/kube-apiserver/authz"
	local certapi="output/kube-apiserver/cert-api"
	local certauthn="output/kube-apiserver/cert-authn"
	local certkubelet="output/kube-apiserver/cert-kubelet"
	local certserviceAccount="output/kube-apiserver/cert-serviceAccount"
	
	create_dir  $authz
	create_dir  $certapi
	create_dir  $certauthn
	create_dir  $certkubelet
	create_dir  $certserviceAccount
	
	func_force_copy $authz  ./authz/policy.json
	func_force_copy $certapi  ./apiserver/output/192.168.183.59/cert.pem ./apiserver/output/192.168.183.59/key.pem  ./apiserver/ca/ca.pem

	func_force_copy $certauthn ./authn/ca/ca.pem 
	func_force_copy $certkubelet ./kubelets/output/192.168.183.59/cert.pem ./kubelets/output/192.168.183.59/key.pem
	func_force_copy $certkubelet ./kubelets/ca/ca.pem

	func_force_copy $certserviceAccount  ./serviceAccount/ca/ca.pem
}

collect_for_kube-controller-manager(){
	local certauthn="output/kube-controller-manager/cert-authn"
	local certserviceAccount="output/kube-controller-manager/cert-serviceAccount"
	local rootCAs="output/kube-controller-manager/rootCAs"
	local certapi="output/kube-controller-manager/cert-api"

	create_dir  $certauthn
	create_dir  $certserviceAccount
	create_dir  $rootCAs
	create_dir  $certapi

	func_force_copy $certauthn ./authn/output/kube-controller-manager/cert.pem ./authn/output/kube-controller-manager/key.pem  
	func_force_copy $certserviceAccount  ./serviceAccount/ca/ca-key.pem
	func_force_copy $rootCAs   ./apiserver/ca/ca.pem
	func_force_copy $certapi   ./apiserver/ca/ca.pem
	cat output/kube-apiserver/cert-kubelet/ca.pem >>${rootCAs}/ca.pem
}

collect_for_kube-kubelet(){
	local certauthn="output/kube-kubelet/cert-authn"
	local certself="output/kube-kubelet/cert-self"
	local certapi="output/kube-kubelet/cert-api"
	create_dir $certapi
	create_dir $certauthn
	create_dir $certself
	func_force_copy $certauthn ./authn/output/kube-kubelet/cert.pem  ./authn/output/kube-kubelet/key.pem
	func_force_copy $certapi ./apiserver/ca/ca.pem
}

collect_for_kube-proxy(){
	local certauthn="output/kube-proxy/cert-authn"
	local certapi="output/kube-proxy/cert-api"
	create_dir $certauthn
	create_dir $certapi
	func_force_copy $certauthn ./authn/output/kube-proxy/cert.pem  ./authn/output/kube-proxy/key.pem
	func_force_copy $certapi ./apiserver/ca/ca.pem
}

collect_for_kube-scheduler(){
	local certauthn="output/kube-scheduler/cert-authn"
	local certapi="output/kube-scheduler/cert-api"
	create_dir $certauthn
	create_dir $certapi
	func_force_copy $certauthn ./authn/output/kube-scheduler/cert.pem  ./authn/output/kube-scheduler/key.pem
	func_force_copy $certapi ./apiserver/ca/ca.pem
}

collect_for_kube-cli(){
	local kubecli="output/kube-cli/"
	create_dir $kubecli
	create_dir $kubecli/ca

	func_force_copy $kubecli       ./authn/output/user-*  ./authn/output/admin-*
	func_force_copy $kubecli/ca    ./apiserver/ca/ca.pem
}

collect_for_kube2sky(){
	local kube2sky="output/kube2sky/"
	create_dir $kube2sky
	create_dir $kube2sky/ca

	func_force_copy $kube2sky       ./authn/output/kube2sky
	func_force_copy $kube2sky/ca    ./apiserver/ca/ca.pem
}


collect_for_apiserver
collect_for_kube-controller-manager
collect_for_kube-kubelet
collect_for_kube-proxy
collect_for_kube-scheduler
collect_for_kube-cli
collect_for_kube2sky

if [[ $? != 0 ]];then
	func_yellow_str "go to subdir to generate the cert"
	exit
fi

CurPath=`pwd`

func_yellow_str "`ls ../../Config/`"
echo -n "Choose the Cluster:"
read Cluster

ShellPath="${CurPath}/../../Config/${Cluster}/Shell/"

for i in `ls ./output/`
do
	cp -rf ./output/$i/*  ${ShellPath}/$i
done
