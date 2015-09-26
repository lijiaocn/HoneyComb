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
	
	create_dir  $authz
	create_dir  $certapi
	create_dir  $certauthn
	create_dir  $certkubelet
	
	func_force_copy $authz  ./authz/policy.json
	func_force_copy $certapi  ./apiserver/output/localhost/cert.pem ./apiserver/output/localhost/key.pem  ./apiserver/ca/ca.pem

	func_force_copy $certauthn ./authn/ca/ca.pem 
	func_force_copy $certkubelet ./kubelets/output/localhost/cert.pem ./kubelets/output/localhost/key.pem
	func_force_copy $certkubelet ./kubelets/ca/ca.pem

}

collect_for_kube-controller-manager(){
	local certauthn="output/kube-controller-manager/cert-authn"
	create_dir $certauthn

	func_force_copy $certauthn ./authn/output/kube-controller-manager/cert.pem ./authn/output/kube-controller-manager/key.pem
	func_force_copy $certauthn ./apiserver/ca/ca.pem


}

collect_for_kube-kubelet(){
	local certauthn="output/kube-kubelet/cert-authn"
	local certself="output/kube-kubelet/cert-self"
	create_dir $certauthn
	create_dir $certself
	func_force_copy $certauthn ./authn/output/kube-kubelet/cert.pem  ./authn/output/kube-kubelet/key.pem
	func_force_copy $certself   ./kubelets/output/kubelet-127.0.0.1/cert.pem  ./kubelets/output/kubelet-127.0.0.1/key.pem
	func_force_copy $certauthn ./apiserver/ca/ca.pem
}

collect_for_kube-proxy(){
	local certauthn="output/kube-proxy/cert-authn"
	create_dir $certauthn
	func_force_copy $certauthn ./authn/output/kube-proxy/cert.pem  ./authn/output/kube-proxy/key.pem
	func_force_copy $certauthn ./apiserver/ca/ca.pem
}

collect_for_kube-scheduler(){
	local certauthn="output/kube-scheduler/cert-authn"
	create_dir $certauthn
	func_force_copy $certauthn ./authn/output/kube-scheduler/cert.pem  ./authn/output/kube-scheduler/key.pem
	func_force_copy $certauthn ./apiserver/ca/ca.pem
}


collect_for_kube-cli(){
	local kubecli="output/kube-cli/"
	create_dir $kubecli
	create_dir $kubecli/ca

	func_force_copy $kubecli       ./authn/output/user-*  ./authn/output/admin-*
	func_force_copy $kubecli/ca    ./apiserver/ca/ca.pem
}


collect_for_apiserver
collect_for_kube-controller-manager
collect_for_kube-kubelet
collect_for_kube-proxy
collect_for_kube-scheduler
collect_for_kube-cli

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
