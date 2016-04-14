#!/bin/bash

if [ ! $# -eq 1 ];then
	echo "Usage: $0 [start|stop|restart]"
	exit
fi

for i in registry.sh etcd-member.sh flannel-set.sh kube-apiserver.sh kube-controller-manager.sh kube-scheduler.sh kube-node.sh
do
	echo "============== $i =============="
	./$i $1
done
