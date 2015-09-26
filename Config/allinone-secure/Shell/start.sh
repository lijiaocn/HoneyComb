#!/bin/bash

compents="etcd registry flannel docker kube-apiserver kube-kubelet kube-proxy kube-controller-manager kube-scheduler"
for p in  ${compents}
do
	if [ -e ${p}/${p}.sh ];then
		cd ${p}; bash ${p}.sh start; cd ..
	fi
done
