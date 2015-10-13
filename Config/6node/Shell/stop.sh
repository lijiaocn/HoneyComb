#!/bin/bash

compents="kube2sky kube-controller-manager kube-scheduler kube-kubelet kube-proxy  kube-apiserver docker skydns flannel etcd registry"
for p in  ${compents}
do
	if [ -e ${p}/${p}.sh ];then
		cd ${p}; bash ${p}.sh stop; cd ..
	fi
done
